import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../core/services/location_service.dart';
import '../manager/product_cubit.dart';
import '../manager/product_state.dart';

import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_description_section.dart';
import '../widgets/product_specifications_section.dart';
import '../widgets/seller_info_section.dart';
import '../widgets/product_details_bottom_bar.dart';
import '../../data/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Position? _userLocation;
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    final userLocation = await LocationService.getCurrentLocation();
    if (userLocation != null) {
      setState(() {
        _userLocation = userLocation;
      });
      print('✅ User location: ${userLocation.latitude}, ${userLocation.longitude}');
    } else {
      print('❌ Failed to get user location');
    }
  }

  LatLng _getProductCoordinates(ProductModel product) {
    if (product.locationCoords != null) {
      final lat = product.locationCoords!['lat'] ?? product.locationCoords!['latitude'];
      final lng = product.locationCoords!['lng'] ?? product.locationCoords!['longitude'];

      if (lat != null && lng != null) {
        final latDouble = lat is String ? double.tryParse(lat) : lat.toDouble();
        final lngDouble = lng is String ? double.tryParse(lng) : lng.toDouble();
        if (latDouble != null && lngDouble != null) {
          return LatLng(latDouble, lngDouble);
        }
      }
    }
    // Fallback coordinates (Dubai)
    return const LatLng(25.2048, 55.2708);
  }

  Future<void> _loadRoute(double productLat, double productLon) async {
    if (_userLocation == null) return;

    setState(() => _isLoadingRoute = true);

    try {
      final markers = <Marker>{
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId('product_location'),
          position: LatLng(productLat, productLon),
          infoWindow: const InfoWindow(title: 'Product Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      };

      final polyline = await _getRoutePolyline(productLat, productLon);

      setState(() {
        _markers = markers;
        _polylines = polyline != null
            ? {polyline}
            : {
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: [
                    LatLng(_userLocation!.latitude, _userLocation!.longitude),
                    LatLng(productLat, productLon),
                  ],
                  color: Colors.blue,
                  width: 4,
                  geodesic: true,
                ),
              };
        _isLoadingRoute = false;
      });
    } catch (e) {
      print('❌ Error loading route: $e');
      setState(() => _isLoadingRoute = false);
    }
  }

  Future<Polyline?> _getRoutePolyline(double productLat, double productLon) async {
    if (_userLocation == null) return null;

    try {
      const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=$productLat,$productLon&mode=driving&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['routes'] != null && data['routes'].isNotEmpty) {
          final points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          if (points.isNotEmpty) {
            return Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: Colors.blue,
              width: 8,
              geodesic: true,
            );
          }
        }
      }
    } catch (e) {
      print('❌ Error getting route polyline: $e');
    }
    return null;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return poly;
  }

  @override
  Widget build(BuildContext context) {
    final currentProductId = widget.productId;

    return BlocProvider(
      create: (_) => di.appLocator<ProductCubit>()..loadProductDetails(widget.productId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: null,
        body: Stack(
          children: [
            BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading ||
                  previous.selectedProduct != current.selectedProduct ||
                  previous.error != current.error,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64.sp, color: AppColors.gray),
                        SizedBox(height: 16.h),
                        Text('Error loading product details',
                            style: AppTextStyles.s16w500.copyWith(color: AppColors.gray)),
                        SizedBox(height: 8.h),
                        Text(state.error!,
                            style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }

                if (state.selectedProduct == null) {
                  return const Center(child: Text('Product not found'));
                }

                final product = state.selectedProduct!;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageGallery(images: product.images, mainImage: product.imageUrl),
                      ProductInfoSection(product: product),
                      ProductDescriptionSection(description: product.description),
                      ProductSpecificationsSection(product: product),
                      SellerInfoSection(
                        sellerName: 'AutoParts Store',
                        sellerType: 'Store',
                        sellerImage: 'assets/images/seller_avatar.png',
                        onCallPressed: () => print('Call seller'),
                        onMessagePressed: () {
                          final dealerId = product.dealer;
                          context.go('${RouteNames.chatConversationScreen}/$dealerId',
                              extra: currentProductId);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppColors.gray, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text('Product Location', style: AppTextStyles.blackS16W600),
                                const Spacer(),
                                if (_isLoadingRoute)
                                  SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: CircularProgressIndicator(strokeWidth: 2)),
                                GestureDetector(
                                  onTap: () {
                                    final coords = _getProductCoordinates(product);
                                    _loadRoute(coords.latitude, coords.longitude);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                          color: AppColors.primary.withOpacity(0.3), width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.map, color: AppColors.primary, size: 16.sp),
                                        SizedBox(width: 4.w),
                                        Text('View Route',
                                            style: AppTextStyles.s12w400.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              height: 200.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _getProductCoordinates(product),
                                    zoom: 15,
                                  ),
                                  markers: _markers,
                                  polylines: _polylines,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  compassEnabled: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              product.location.isNotEmpty ? product.location : 'Dubai, UAE',
                              style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100.h), // Space for bottom bar
                    ],
                  ),
                );
              },
            ),
            // Custom Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 16.w,
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.black, size: 20.sp),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) => BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) => ProductDetailsBottomBar(
              onChatPressed: () {
                final dealerId = state.selectedProduct?.dealer ?? 1;
                context.go('${RouteNames.chatConversationScreen}/$dealerId', extra: currentProductId);
              },
              onCallPressed: () => print('Call seller'),
            ),
          ),
        ),
      ),
    );
  }
}
