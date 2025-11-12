import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isMapInteracting = false;

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
      print(
          '✅ User location: ${userLocation.latitude}, ${userLocation.longitude}');
    } else {
      print('❌ Failed to get user location');
    }
  }

  LatLng _getProductCoordinates(ProductModel product) {
    if (product.locationCoords != null) {
      final lat =
          product.locationCoords!['lat'] ?? product.locationCoords!['latitude'];
      final lng = product.locationCoords!['lng'] ??
          product.locationCoords!['longitude'];

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
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
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

  Future<Polyline?> _getRoutePolyline(
      double productLat, double productLon) async {
    if (_userLocation == null) return null;

    try {
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=$productLat,$productLon&mode=driving&key=${AppConfig.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final points =
              _decodePolyline(data['routes'][0]['overview_polyline']['points']);
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
    return BlocProvider(
      create: (_) =>
          di.appLocator<ProductCubit>()..loadProductDetails(widget.productId),
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
                        Icon(Icons.error_outline,
                            size: 64.sp, color: AppColors.gray),
                        SizedBox(height: 16.h),
                        Text('Error loading product details',
                            style: AppTextStyles.s16w500
                                .copyWith(color: AppColors.gray)),
                        SizedBox(height: 8.h),
                        Text(state.error!,
                            style: AppTextStyles.s14w400
                                .copyWith(color: AppColors.gray),
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
                  controller: _scrollController,
                  physics: _isMapInteracting
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageGallery(
                          images: product.images, mainImage: product.imageUrl),
                      ProductInfoSection(product: product),
                      ProductDescriptionSection(
                          description: product.description),
                      ProductSpecificationsSection(product: product),
                      SellerInfoSection(
                        sellerName: product.seller['name']?.toString() ??
                            product.seller['seller_name']?.toString() ??
                            product.seller['store_name']?.toString() ??
                            'Dealer',
                        sellerType: product.seller['type']?.toString() ??
                            product.seller['seller_type']?.toString() ??
                            'Store',
                        sellerImage: product.seller['image']?.toString() ??
                            product.seller['logo']?.toString() ??
                            product.seller['avatar']?.toString() ??
                            '',
                        onCallPressed: () async {
                          final phone = product.seller['phone']?.toString() ??
                              product.seller['contact_phone']?.toString() ??
                              product.seller['phone_number']?.toString();
                          if (phone != null && phone.isNotEmpty) {
                            final phoneUrl = 'tel:$phone';
                            if (await canLaunchUrl(Uri.parse(phoneUrl))) {
                              await launchUrl(Uri.parse(phoneUrl));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)
                                            ?.translate('cannotMakeCall') ??
                                        'Cannot make call',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)?.translate(
                                          'phoneNumberNotAvailable') ??
                                      'Phone number not available',
                                ),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        onMessagePressed: () {
                          print('🔵 ProductDetails: Message button pressed');
                          print(
                              '🔵 ProductDetails: product.seller = ${product.seller}');
                          print(
                              '🔵 ProductDetails: product.dealer = ${product.dealer}');

                          // Use seller id if available, otherwise fallback to dealer
                          int? sellerId;

                          // Try to get seller id from seller object
                          if (product.seller.isNotEmpty &&
                              product.seller.containsKey('id')) {
                            final sellerIdValue = product.seller['id'];
                            print(
                                '🔵 ProductDetails: Found seller id: $sellerIdValue (type: ${sellerIdValue.runtimeType})');

                            if (sellerIdValue is int) {
                              sellerId = sellerIdValue;
                            } else if (sellerIdValue != null) {
                              sellerId = int.tryParse(sellerIdValue.toString());
                            }
                          } else {
                            print(
                                '🔵 ProductDetails: Seller object empty or no id found');
                          }

                          // Fallback to dealer if seller id is not available
                          if (sellerId == null || sellerId <= 0) {
                            print(
                                '🔵 ProductDetails: Using dealer as fallback: ${product.dealer}');
                            sellerId = product.dealer;
                          }

                          print('🔵 ProductDetails: Final sellerId: $sellerId');

                          // Validate that we have a valid id
                          if (sellerId <= 0) {
                            print(
                                '❌ ProductDetails: Invalid sellerId: $sellerId');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)
                                          ?.translate('unableToStartChat') ??
                                      'Unable to start chat: Invalid seller information',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final dealerName =
                              product.seller['name']?.toString() ??
                                  product.seller['seller_name']?.toString() ??
                                  'Dealer';

                          print(
                              '🔵 ProductDetails: Navigating to create chat with sellerId: $sellerId, dealerName: $dealerName');

                          // Navigate to CreateChatScreen first to create chat and connect WebSocket
                          context.push('/create-chat', extra: {
                            'dealerId': sellerId,
                            'dealerName': dealerName,
                            'productId': product.id,
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: AppColors.gray, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text('Product Location',
                                    style: AppTextStyles.blackS16W600),
                                const Spacer(),
                                if (_isLoadingRoute)
                                  SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                GestureDetector(
                                  onTap: () async {
                                    if (_userLocation == null) {
                                      // Try to get location again
                                      final userLocation = await LocationService
                                          .getCurrentLocation();
                                      if (userLocation == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(context)
                                                      ?.translate(
                                                          'locationPermissionRequired') ??
                                                  'Location permission is required to view route',
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        _userLocation = userLocation;
                                      });
                                    }
                                    final coords =
                                        _getProductCoordinates(product);
                                    _loadRoute(
                                        coords.latitude, coords.longitude);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity(0.3),
                                          width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.map,
                                            color: AppColors.primary,
                                            size: 16.sp),
                                        SizedBox(width: 4.w),
                                        Text('View Route',
                                            style: AppTextStyles.s12w400
                                                .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                                  border: Border.all(
                                      color: AppColors.gray.withOpacity(0.2),
                                      width: 1)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Listener(
                                  onPointerDown: (_) {
                                    setState(() {
                                      _isMapInteracting = true;
                                    });
                                  },
                                  onPointerUp: (_) {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      if (mounted) {
                                        setState(() {
                                          _isMapInteracting = false;
                                        });
                                      }
                                    });
                                  },
                                  onPointerCancel: (_) {
                                    setState(() {
                                      _isMapInteracting = false;
                                    });
                                  },
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: _getProductCoordinates(product),
                                      zoom: 15,
                                    ),
                                    markers: _markers,
                                    polylines: _polylines,
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: true,
                                    mapToolbarEnabled: false,
                                    compassEnabled: true,
                                    scrollGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                    tiltGesturesEnabled: true,
                                    rotateGesturesEnabled: true,
                                    liteModeEnabled: false,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              product.locationText.isNotEmpty
                                  ? product.locationText
                                  : (product.location.isNotEmpty
                                      ? product.location
                                      : 'Location not available'),
                              style: AppTextStyles.s14w400
                                  .copyWith(color: AppColors.gray),
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
                decoration: const BoxDecoration(
                    color: Color(0xFFE0E0E0), shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: AppColors.black, size: 20.sp),
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
                final product = state.selectedProduct;
                if (product != null) {
                  print('🔵 ProductDetails: Bottom bar chat button pressed');
                  print(
                      '🔵 ProductDetails: product.seller = ${product.seller}');
                  print(
                      '🔵 ProductDetails: product.dealer = ${product.dealer}');

                  // Use seller id if available, otherwise fallback to dealer
                  int? sellerId;

                  // Try to get seller id from seller object
                  if (product.seller.isNotEmpty &&
                      product.seller.containsKey('id')) {
                    final sellerIdValue = product.seller['id'];
                    print(
                        '🔵 ProductDetails: Found seller id: $sellerIdValue (type: ${sellerIdValue.runtimeType})');

                    if (sellerIdValue is int) {
                      sellerId = sellerIdValue;
                    } else if (sellerIdValue != null) {
                      sellerId = int.tryParse(sellerIdValue.toString());
                    }
                  } else {
                    print(
                        '🔵 ProductDetails: Seller object empty or no id found');
                  }

                  // Fallback to dealer if seller id is not available
                  if (sellerId == null || sellerId <= 0) {
                    print(
                        '🔵 ProductDetails: Using dealer as fallback: ${product.dealer}');
                    sellerId = product.dealer;
                  }

                  print('🔵 ProductDetails: Final sellerId: $sellerId');

                  // Validate that we have a valid id
                  if (sellerId <= 0) {
                    print('❌ ProductDetails: Invalid sellerId: $sellerId');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                                  ?.translate('unableToStartChat') ??
                              'Unable to start chat: Invalid seller information',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final dealerName = product.seller['name']?.toString() ??
                      product.seller['seller_name']?.toString() ??
                      'Dealer';

                  print(
                      '🔵 ProductDetails: Navigating to create chat with sellerId: $sellerId, dealerName: $dealerName');

                  // Navigate to CreateChatScreen first to create chat and connect WebSocket
                  context.push('/create-chat', extra: {
                    'dealerId': sellerId,
                    'dealerName': dealerName,
                    'productId': product.id,
                  });
                }
              },
              onCallPressed: () async {
                final product = state.selectedProduct;
                if (product != null) {
                  final phone = product.seller['phone']?.toString() ??
                      product.seller['contact_phone']?.toString() ??
                      product.seller['phone_number']?.toString();
                  if (phone != null && phone.isNotEmpty) {
                    final phoneUrl = 'tel:$phone';
                    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
                      await launchUrl(Uri.parse(phoneUrl));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)
                                    ?.translate('cannotMakeCall') ??
                                'Cannot make call',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                                  ?.translate('phoneNumberNotAvailable') ??
                              'Phone number not available',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
