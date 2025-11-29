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
    // Defer location initialization to avoid blocking the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeMap();
      }
    });
  }

  Future<void> _initializeMap() async {
    // Add a small delay to ensure the screen is fully rendered
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!mounted) return;
    
    try {
      final userLocation = await LocationService.getCurrentLocation();
      if (userLocation != null && mounted) {
        // Use post-frame callback to avoid build during frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _userLocation = userLocation;
            });
          }
        });
        print(
            '✅ User location: ${userLocation.latitude}, ${userLocation.longitude}');
      } else {
        print('⚠️ LocationService: Could not get user location (will work without it)');
      }
    } catch (e) {
      print('❌ LocationService: Error initializing map location: $e');
      // Don't crash - app can work without location
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

    // Use post-frame callback to avoid build during frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isLoadingRoute = true);
      }
    });

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

      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _markers = markers;
            // Only set polyline if we got a real route from Directions API
            // Don't fallback to straight line - show error or retry instead
            if (polyline != null) {
              _polylines = {polyline};
              print('✅ ProductDetails: Real route polyline added to map');
            } else {
              // Clear polylines if route failed - don't show straight line
              _polylines = {};
              print('⚠️ ProductDetails: Route not available - no polyline shown');
            }
            _isLoadingRoute = false;
          });
        }
      });
    } catch (e) {
      print('❌ Error loading route: $e');
      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isLoadingRoute = false);
        }
      });
    }
  }

  Future<Polyline?> _getRoutePolyline(
      double productLat, double productLon) async {
    if (_userLocation == null) {
      print('❌ ProductDetails: Cannot get route polyline - user location is null');
      return null;
    }

    try {
      // Use the exact format: origin=LAT1,LNG1&destination=LAT2,LNG2&key=YOUR_KEY
      final originLat = _userLocation!.latitude;
      final originLng = _userLocation!.longitude;
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$productLat,$productLon&mode=driving&key=${AppConfig.googleMapsApiKey}';
      
      print('🗺️ ProductDetails: Requesting route from Google Directions API...');
      print('🗺️ ProductDetails: Origin: $originLat, $originLng');
      print('🗺️ ProductDetails: Destination: $productLat, $productLon');
      
      final response = await http.get(Uri.parse(url));
      print('🗺️ ProductDetails: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🗺️ ProductDetails: Directions API response status: ${data['status']}');
        
        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          // Get the overview_polyline from the route
          final route = data['routes'][0];
          final overviewPolyline = route['overview_polyline'];
          
          if (overviewPolyline != null && overviewPolyline['points'] != null) {
            final polylineEncoded = overviewPolyline['points'] as String;
            print('🗺️ ProductDetails: Got encoded polyline: ${polylineEncoded.substring(0, polylineEncoded.length > 50 ? 50 : polylineEncoded.length)}...');
            
            // Decode the polyline to get LatLng list
            final points = _decodePolyline(polylineEncoded);
            print('🗺️ ProductDetails: Decoded ${points.length} route points');
            
            if (points.isNotEmpty) {
              print('✅ ProductDetails: Route polyline created successfully');
              print('✅ ProductDetails: First point: ${points.first}');
              print('✅ ProductDetails: Last point: ${points.last}');
              
              // Create and return the Polyline
              return Polyline(
                polylineId: const PolylineId('route'),
                points: points, // List<LatLng> from decoded polyline
                color: const Color(0xFF2196F3), // Bright blue
                width: 8, // Thicker line for better visibility
                geodesic: false, // Set to false for accurate street-level routing
                patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                visible: true,
              );
            } else {
              print('⚠️ ProductDetails: Decoded polyline has no points');
            }
          } else {
            print('⚠️ ProductDetails: No overview_polyline in route response');
          }
        } else {
          print('⚠️ ProductDetails: Directions API returned status: ${data['status']}');
          if (data['error_message'] != null) {
            print('⚠️ ProductDetails: Error message: ${data['error_message']}');
          }
          
          // If Google API failed due to billing, try OpenRouteService as fallback
          if (data['status'] == 'REQUEST_DENIED' || data['status'] == 'OVER_QUERY_LIMIT') {
            print('🔄 ProductDetails: Google API unavailable, trying OpenRouteService fallback...');
            return await _getRouteFromOpenRouteService(productLat, productLon);
          }
        }
      } else {
        print('❌ ProductDetails: HTTP error: ${response.statusCode}');
        print('❌ ProductDetails: Response body: ${response.body}');
        // Try OpenRouteService as fallback
        print('🔄 ProductDetails: Trying OpenRouteService fallback...');
        return await _getRouteFromOpenRouteService(productLat, productLon);
      }
    } catch (e) {
      print('❌ ProductDetails: Error getting route polyline: $e');
      print('❌ ProductDetails: Stack trace: ${StackTrace.current}');
      // Try OpenRouteService as fallback
      print('🔄 ProductDetails: Trying OpenRouteService fallback...');
      try {
        return await _getRouteFromOpenRouteService(productLat, productLon);
      } catch (fallbackError) {
        print('❌ ProductDetails: OpenRouteService also failed: $fallbackError');
      }
    }

    return null;
  }

  /// Fallback route using OpenRouteService (free alternative)
  Future<Polyline?> _getRouteFromOpenRouteService(double productLat, double productLon) async {
    if (_userLocation == null) return null;

    try {
      // OpenRouteService - API key should be in Authorization header with "Bearer" prefix
      // Or use it as query parameter: ?api_key=...
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248&start=${_userLocation!.longitude},${_userLocation!.latitude}&end=$productLon,$productLat';
      
      print('🗺️ ProductDetails: Requesting route from OpenRouteService...');
      print('🗺️ ProductDetails: OpenRouteService URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json, application/geo+json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final geometry = data['features'][0]['geometry'];
          if (geometry != null && geometry['coordinates'] != null) {
            // OpenRouteService returns coordinates as [lon, lat] pairs
            final coordinates = geometry['coordinates'] as List;
            final points = coordinates.map((coord) {
              return LatLng(coord[1] as double, coord[0] as double);
            }).toList();

            if (points.isNotEmpty) {
              print('✅ ProductDetails: OpenRouteService route created with ${points.length} points');
              return Polyline(
                polylineId: const PolylineId('route'),
                points: points,
                color: const Color(0xFF2196F3),
                width: 8,
                geodesic: false,
                patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                visible: true,
              );
            }
          }
        }
      } else {
        print('⚠️ ProductDetails: OpenRouteService HTTP error: ${response.statusCode}');
        print('⚠️ ProductDetails: OpenRouteService response: ${response.body}');
        // Try OSRM as another free alternative
        print('🔄 ProductDetails: Trying OSRM as alternative...');
        return await _getRouteFromOSRM(productLat, productLon);
      }
    } catch (e) {
      print('❌ ProductDetails: OpenRouteService error: $e');
      // Try OSRM as another free alternative
      print('🔄 ProductDetails: Trying OSRM as alternative...');
      try {
        return await _getRouteFromOSRM(productLat, productLon);
      } catch (osrmError) {
        print('❌ ProductDetails: OSRM also failed: $osrmError');
      }
    }

    return null;
  }

  /// Free routing service - OSRM (Open Source Routing Machine)
  Future<Polyline?> _getRouteFromOSRM(double productLat, double productLon) async {
    if (_userLocation == null) return null;

    try {
      // OSRM is a free, open-source routing service (no API key needed)
      // Format: /route/v1/driving/{lon1},{lat1};{lon2},{lat2}?overview=full&geometries=geojson
      final url =
          'https://router.project-osrm.org/route/v1/driving/${_userLocation!.longitude},${_userLocation!.latitude};$productLon,$productLat?overview=full&geometries=geojson';
      
      print('🗺️ ProductDetails: Requesting route from OSRM...');
      print('🗺️ ProductDetails: OSRM URL: $url');
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          
          if (geometry != null && geometry['coordinates'] != null) {
            // OSRM returns coordinates as [lon, lat] pairs in GeoJSON format
            final coordinates = geometry['coordinates'] as List;
            final points = coordinates.map((coord) {
              return LatLng(coord[1] as double, coord[0] as double);
            }).toList();

            if (points.isNotEmpty) {
              print('✅ ProductDetails: OSRM route created with ${points.length} points');
              return Polyline(
                polylineId: const PolylineId('route'),
                points: points,
                color: const Color(0xFF2196F3),
                width: 8,
                geodesic: false,
                patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                visible: true,
              );
            }
          }
        } else {
          print('⚠️ ProductDetails: OSRM returned code: ${data['code']}');
        }
      } else {
        print('⚠️ ProductDetails: OSRM HTTP error: ${response.statusCode}');
        print('⚠️ ProductDetails: OSRM response: ${response.body}');
      }
    } catch (e) {
      print('❌ ProductDetails: OSRM error: $e');
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
      create: (_) {
        final cubit = di.appLocator<ProductCubit>();
        // Defer loading to avoid blocking the initial build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          cubit.loadProductDetails(widget.productId);
        });
        return cubit;
      },
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
                                      // Use post-frame callback to avoid build during frame
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          setState(() {
                                            _userLocation = userLocation;
                                          });
                                        }
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
                                    // Use post-frame callback to avoid build during frame
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          _isMapInteracting = true;
                                        });
                                      }
                                    });
                                  },
                                  onPointerUp: (_) {
                                    Future.delayed(
                                        const Duration(milliseconds: 150), () {
                                      if (mounted) {
                                        // Use post-frame callback to avoid build during frame
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(() {
                                              _isMapInteracting = false;
                                            });
                                          }
                                        });
                                      }
                                    });
                                  },
                                  onPointerCancel: (_) {
                                    // Use post-frame callback to avoid build during frame
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          _isMapInteracting = false;
                                        });
                                      }
                                    });
                                  },
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: _getProductCoordinates(product),
                                      zoom: 15,
                                    ),
                                    markers: _markers,
                                    polylines: _polylines,
                                    myLocationEnabled: _userLocation != null,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: true,
                                    mapToolbarEnabled: false,
                                    compassEnabled: true,
                                    scrollGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                    tiltGesturesEnabled: true,
                                    rotateGesturesEnabled: true,
                                    liteModeEnabled: false,
                                    onMapCreated: (GoogleMapController controller) {
                                      // Map is ready, can perform additional setup if needed
                                    },
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
