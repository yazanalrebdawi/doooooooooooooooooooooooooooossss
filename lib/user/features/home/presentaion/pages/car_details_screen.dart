import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as widget;
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
import '../manager/car_cubit.dart';
import '../manager/car_state.dart';
import '../widgets/car_image_section.dart';
import '../widgets/car_overview_section.dart';
import '../widgets/car_specifications_section.dart';
import '../widgets/seller_notes_section.dart';
import '../widgets/seller_info_section.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key, required this.carId});
  final int carId;

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Position? _userLocation;
  bool _isLoadingRoute = false;
  LatLng? _carCoordinates;
  GoogleMapController? _mapController;
  final ScrollController _scrollController = ScrollController();
  bool _isMapInteracting = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    print('🗺️ CarDetails: Initializing map...');
    try {
      final userLocation = await LocationService.getCurrentLocation();
      if (userLocation != null && mounted) {
        print(
          '✅ CarDetails: User location obtained: ${userLocation.latitude}, ${userLocation.longitude}',
        );
        // Use post-frame callback to avoid build during frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _userLocation = userLocation;
            });
          }
        });
      } else {
        print('⚠️ CarDetails: Could not get user location (will work without it)');
      }
    } catch (e) {
      print('❌ CarDetails: Error initializing map location: $e');
      // Don't crash - app can work without location
    }
  }

  Future<LatLng> _getCarCoordinates(String location) async {
    if (location.isEmpty) {
      print('⚠️ CarDetails: Location is empty, using fallback');
      return const LatLng(25.2048, 55.2708);
    }

    print('🗺️ CarDetails: Parsing location: $location');

    // Check if location is already in PostGIS format (with or without SRID)
    if (location.contains('POINT')) {
      final coordsMatch = RegExp(r'POINT\s*\(([^)]+)\)').firstMatch(location);
      if (coordsMatch != null) {
        final coordsStr = coordsMatch.group(1)?.trim() ?? '';
        // Split by space or comma
        final coords = coordsStr
            .split(RegExp(r'[\s,]+'))
            .where((s) => s.isNotEmpty)
            .toList();
        if (coords.length >= 2) {
          final lng = double.tryParse(coords[0]) ?? 0.0;
          final lat = double.tryParse(coords[1]) ?? 0.0;
          if (lat != 0.0 &&
              lng != 0.0 &&
              lat >= -90 &&
              lat <= 90 &&
              lng >= -180 &&
              lng <= 180) {
            print('✅ CarDetails: Parsed PostGIS coordinates: $lat, $lng');
            return LatLng(lat, lng);
          } else {
            print('⚠️ CarDetails: Invalid PostGIS coordinates: $lat, $lng');
          }
        }
      }
    }

    // Check if location is in "lat, lng" or "lng, lat" format (from parsed PostGIS)
    final coordMatch =
        RegExp(r'^([\d.+\-]+)[,\s]+([\d.+\-]+)$').firstMatch(location.trim());
    if (coordMatch != null) {
      final first = double.tryParse(coordMatch.group(1)?.trim() ?? '') ?? 0.0;
      final second = double.tryParse(coordMatch.group(2)?.trim() ?? '') ?? 0.0;

      // Determine which is lat and which is lng based on value ranges
      double lat, lng;
      if (first.abs() <= 90 && second.abs() <= 180) {
        // First is likely lat, second is lng
        lat = first;
        lng = second;
      } else if (first.abs() <= 180 && second.abs() <= 90) {
        // First is likely lng, second is lat
        lng = first;
        lat = second;
      } else {
        // Try both combinations
        lat = first;
        lng = second;
      }

      if (lat != 0.0 &&
          lng != 0.0 &&
          lat >= -90 &&
          lat <= 90 &&
          lng >= -180 &&
          lng <= 180) {
        print('✅ CarDetails: Parsed coordinate string: $lat, $lng');
        return LatLng(lat, lng);
      } else {
        print('⚠️ CarDetails: Invalid coordinate string: $lat, $lng');
      }
    }

    // Fallback to geocoding if it's an address string
    try {
      final encodedLocation = Uri.encodeComponent(location);
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedLocation&key=${AppConfig.googleMapsApiKey}';
      print('🌐 CarDetails: Geocoding location: $location');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final result = data['results'][0];
          final locationData = result['geometry']['location'];
          final lat = locationData['lat'].toDouble();
          final lng = locationData['lng'].toDouble();
          print('✅ CarDetails: Geocoded coordinates: $lat, $lng');
          return LatLng(lat, lng);
        }
      }
      print('⚠️ CarDetails: Geocoding failed, using fallback');
      return const LatLng(25.2048, 55.2708);
    } catch (e) {
      print('❌ CarDetails: Geocoding error: $e');
      return const LatLng(25.2048, 55.2708);
    }
  }

  Future<void> _loadRoute(double carLat, double carLon) async {
    if (_userLocation == null) {
      print('❌ CarDetails: Cannot load route - user location is null');
      return;
    }
    print('🗺️ CarDetails: Starting route load...');
    
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
          markerId: const MarkerId('car_location'),
          position: LatLng(carLat, carLon),
          infoWindow: const InfoWindow(title: 'Car Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };

      final polyline = await _getRoutePolyline(carLat, carLon);

      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _markers = markers;
            // Set polyline if we got a real route from Directions API
            if (polyline != null) {
              _polylines = {polyline};
              print('✅ CarDetails: Real route polyline added to map with ${polyline.points.length} points');
              print('✅ CarDetails: Polyline visible: ${polyline.visible}, color: ${polyline.color}, width: ${polyline.width}');
            } else {
              // If route failed, try one more time after a short delay
              _polylines = {};
              print('⚠️ CarDetails: Route not available - will retry...');
              
              // Retry once after a short delay
              Future.delayed(const Duration(seconds: 2), () async {
                if (mounted && _userLocation != null) {
                  print('🔄 CarDetails: Retrying route request...');
                  final retryPolyline = await _getRoutePolyline(carLat, carLon);
                  if (mounted && retryPolyline != null) {
                    setState(() {
                      _polylines = {retryPolyline};
                      print('✅ CarDetails: Route loaded successfully on retry with ${retryPolyline.points.length} points!');
                    });
                  } else if (mounted) {
                    // Show error message only if retry also failed
                    print('❌ CarDetails: Route failed even after retry');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)?.translate('errorLoadingRoute') ??
                              'Unable to load route. Please check your internet connection and try again.',
                        ),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: 'Retry',
                          textColor: Colors.white,
                          onPressed: () {
                            _loadRoute(carLat, carLon);
                          },
                        ),
                      ),
                    );
                  }
                }
              });
            }
            _isLoadingRoute = false;
          });
        }
      });

      // Update camera to fit both markers
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateCameraToFitRoute(carLat, carLon);
      });
    } catch (e) {
      print('❌ CarDetails: Error loading route: $e');
      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isLoadingRoute = false);
        }
      });
    }
  }

  Future<Polyline?> _getRoutePolyline(double carLat, double carLon) async {
    if (_userLocation == null) {
      print('❌ CarDetails: Cannot get route polyline - user location is null');
      return null;
    }

    try {
      // Use the exact format: origin=LAT1,LNG1&destination=LAT2,LNG2&key=YOUR_KEY
      final originLat = _userLocation!.latitude;
      final originLng = _userLocation!.longitude;
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$carLat,$carLon&key=${AppConfig.googleMapsApiKey}';
      
      print('🗺️ CarDetails: Requesting route from Google Directions API...');
      print('🗺️ CarDetails: Origin: $originLat, $originLng');
      print('🗺️ CarDetails: Destination: $carLat, $carLon');
      print('🗺️ CarDetails: URL: $url');
      
      final response = await http.get(Uri.parse(url));
      print('🗺️ CarDetails: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🗺️ CarDetails: Directions API response status: ${data['status']}');
        
        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          // Get the overview_polyline from the route
          final route = data['routes'][0];
          final overviewPolyline = route['overview_polyline'];
          
          if (overviewPolyline != null && overviewPolyline['points'] != null) {
            final polylineEncoded = overviewPolyline['points'] as String;
            print('🗺️ CarDetails: Got encoded polyline: ${polylineEncoded.substring(0, polylineEncoded.length > 50 ? 50 : polylineEncoded.length)}...');
            
            // Decode the polyline to get LatLng list
            final points = _decodePolyline(polylineEncoded);
            print('🗺️ CarDetails: Decoded ${points.length} route points');
            
            if (points.isNotEmpty) {
              print('✅ CarDetails: Route polyline created successfully');
              print('✅ CarDetails: First point: ${points.first}');
              print('✅ CarDetails: Last point: ${points.last}');
              
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
              print('⚠️ CarDetails: Decoded polyline has no points');
            }
          } else {
            print('⚠️ CarDetails: No overview_polyline in route response');
          }
        } else {
          print('⚠️ CarDetails: Directions API returned status: ${data['status']}');
          if (data['error_message'] != null) {
            print('⚠️ CarDetails: Error message: ${data['error_message']}');
          }
          
          // If Google API failed due to billing, try OpenRouteService as fallback
          if (data['status'] == 'REQUEST_DENIED' || data['status'] == 'OVER_QUERY_LIMIT') {
            print('🔄 CarDetails: Google API unavailable, trying OpenRouteService fallback...');
            return await _getRouteFromOpenRouteService(carLat, carLon);
          }
        }
      } else {
        print('❌ CarDetails: HTTP error: ${response.statusCode}');
        print('❌ CarDetails: Response body: ${response.body}');
        // Try OpenRouteService as fallback
        print('🔄 CarDetails: Trying OpenRouteService fallback...');
        return await _getRouteFromOpenRouteService(carLat, carLon);
      }
    } catch (e) {
      print('❌ CarDetails: Error getting route polyline: $e');
      print('❌ CarDetails: Stack trace: ${StackTrace.current}');
      // Try OpenRouteService as fallback
      print('🔄 CarDetails: Trying OpenRouteService fallback...');
      try {
        return await _getRouteFromOpenRouteService(carLat, carLon);
      } catch (fallbackError) {
        print('❌ CarDetails: OpenRouteService also failed: $fallbackError');
      }
    }

    return null;
  }

  /// Fallback route using OpenRouteService (free alternative)
  Future<Polyline?> _getRouteFromOpenRouteService(double carLat, double carLon) async {
    if (_userLocation == null) return null;

    try {
      // OpenRouteService - API key should be in Authorization header with "Bearer" prefix
      // Or use it as query parameter: ?api_key=...
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248&start=${_userLocation!.longitude},${_userLocation!.latitude}&end=$carLon,$carLat';
      
      print('🗺️ CarDetails: Requesting route from OpenRouteService...');
      print('🗺️ CarDetails: OpenRouteService URL: $url');
      
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
              print('✅ CarDetails: OpenRouteService route created with ${points.length} points');
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
        print('⚠️ CarDetails: OpenRouteService HTTP error: ${response.statusCode}');
        print('⚠️ CarDetails: OpenRouteService response: ${response.body}');
        // Try OSRM as another free alternative
        print('🔄 CarDetails: Trying OSRM as alternative...');
        return await _getRouteFromOSRM(carLat, carLon);
      }
    } catch (e) {
      print('❌ CarDetails: OpenRouteService error: $e');
      // Try OSRM as another free alternative
      print('🔄 CarDetails: Trying OSRM as alternative...');
      try {
        return await _getRouteFromOSRM(carLat, carLon);
      } catch (osrmError) {
        print('❌ CarDetails: OSRM also failed: $osrmError');
      }
    }

    return null;
  }

  /// Free routing service - OSRM (Open Source Routing Machine)
  Future<Polyline?> _getRouteFromOSRM(double carLat, double carLon) async {
    if (_userLocation == null) return null;

    try {
      // OSRM is a free, open-source routing service (no API key needed)
      // Format: /route/v1/driving/{lon1},{lat1};{lon2},{lat2}?overview=full&geometries=geojson
      final url =
          'https://router.project-osrm.org/route/v1/driving/${_userLocation!.longitude},${_userLocation!.latitude};$carLon,$carLat?overview=full&geometries=geojson';
      
      print('🗺️ CarDetails: Requesting route from OSRM...');
      print('🗺️ CarDetails: OSRM URL: $url');
      
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
              print('✅ CarDetails: OSRM route created with ${points.length} points');
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
          print('⚠️ CarDetails: OSRM returned code: ${data['code']}');
        }
      } else {
        print('⚠️ CarDetails: OSRM HTTP error: ${response.statusCode}');
        print('⚠️ CarDetails: OSRM response: ${response.body}');
      }
    } catch (e) {
      print('❌ CarDetails: OSRM error: $e');
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
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return poly;
  }

  void _updateCameraToFitRoute(double carLat, double carLon) {
    if (_mapController == null || _userLocation == null) {
      print(
          '⚠️ CarDetails: Cannot update camera - map controller or user location is null');
      return;
    }

    try {
      // Calculate bounds to include both user location and car location
      final userLat = _userLocation!.latitude;
      final userLng = _userLocation!.longitude;

      final minLat = userLat < carLat ? userLat : carLat;
      final maxLat = userLat > carLat ? userLat : carLat;
      final minLng = userLng < carLon ? userLng : carLon;
      final maxLng = userLng > carLon ? userLng : carLon;

      // Calculate center point
      final centerLat = (minLat + maxLat) / 2;
      final centerLng = (minLng + maxLng) / 2;

      // Calculate zoom level based on distance
      final latDiff = maxLat - minLat;
      final lngDiff = maxLng - minLng;
      final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

      double zoom;
      if (maxDiff < 0.01) {
        zoom = 15.0;
      } else if (maxDiff < 0.05) {
        zoom = 13.0;
      } else if (maxDiff < 0.1) {
        zoom = 11.0;
      } else if (maxDiff < 0.5) {
        zoom = 9.0;
      } else {
        zoom = 7.0;
      }

      print(
          '🗺️ CarDetails: Updating camera to center: $centerLat, $centerLng, zoom: $zoom');

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(centerLat, centerLng),
            zoom: zoom,
          ),
        ),
      );
    } catch (e) {
      print('❌ CarDetails: Error updating camera: $e');
    }
  }

  @override
  widget.Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) =>
          di.appLocator<CarCubit>()..loadCarDetails(this.widget.carId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocBuilder<CarCubit, CarState>(
          buildWhen: (previous, current) =>
              previous.selectedCar != current.selectedCar ||
              previous.isLoading != current.isLoading ||
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
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: isDark ? Colors.white : AppColors.gray,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading car details',
                      style: AppTextStyles.s16w500.copyWith(
                        color: isDark ? Colors.white : AppColors.gray,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.error!,
                      style: AppTextStyles.s14w400.copyWith(
                        color: isDark ? Colors.white : AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state.selectedCar == null) {
              return const Center(child: Text('Car not found'));
            }

            final car = state.selectedCar!;

            // Load car coordinates if not already loaded
            if (_carCoordinates == null && car.location.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) async {
                  final coords = await _getCarCoordinates(car.location);
                  if (mounted) {
                    setState(() {
                      _carCoordinates = coords;
                    });
                  }
                },
              );
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: _isMapInteracting
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarImageSection(
                        imageUrl: car.imageUrl,
                        carName: car.name,
                      ),
                      // Seller Name Row

                      CarOverviewSection(
                        carName: car.name,
                        price: car.price,
                        isNew: car.isNew,
                        location: car.location,
                        mileage: car.mileage,
                      ),
                      CarSpecificationsSection(
                        year: car.year,
                        transmission: car.transmission,
                        engine: car.engine,
                        fuelType: car.fuelType,
                        color: car.color,
                        doors: car.doors,
                      ),
                      SellerNotesSection(notes: car.sellerNotes),
                      SellerInfoSection(
                        sellerName: car.sellerName,
                        sellerType: car.sellerType,
                        sellerImage: car.sellerImage,
                        onCallPressed: () async {
                          final phone = car.seller['phone']?.toString() ??
                              car.seller['contact_phone']?.toString() ??
                              car.seller['phone_number']?.toString();
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
                          print('🔵 CarDetails: Message button pressed');
                          print('🔵 CarDetails: car.seller = ${car.seller}');
                          print('🔵 CarDetails: car.dealerId = ${car.dealerId}');

                          // Use seller id if available, otherwise fallback to dealerId
                          int? sellerId;

                          // Try to get seller id from seller object
                          if (car.seller.isNotEmpty &&
                              car.seller.containsKey('id')) {
                            final sellerIdValue = car.seller['id'];
                            print(
                                '🔵 CarDetails: Found seller id: $sellerIdValue (type: ${sellerIdValue.runtimeType})');

                            if (sellerIdValue is int) {
                              sellerId = sellerIdValue;
                            } else if (sellerIdValue != null) {
                              sellerId = int.tryParse(sellerIdValue.toString());
                            }
                          } else {
                            print(
                                '🔵 CarDetails: Seller object empty or no id found');
                          }

                          // Fallback to dealerId if seller id is not available
                          if (sellerId == null || sellerId <= 0) {
                            print(
                                '🔵 CarDetails: Using dealerId as fallback: ${car.dealerId}');
                            sellerId = car.dealerId;
                          }

                          print('🔵 CarDetails: Final sellerId: $sellerId');

                          // Validate that we have a valid id
                          if (sellerId <= 0) {
                            print('❌ CarDetails: Invalid sellerId: $sellerId');
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

                          final dealerName = car.seller['name']?.toString() ??
                              car.seller['seller_name']?.toString() ??
                              (car.sellerName.isNotEmpty
                                  ? car.sellerName
                                  : 'Dealer');

                          print(
                              '🔵 CarDetails: Navigating to create chat with sellerId: $sellerId, dealerName: $dealerName');

                          // Navigate to CreateChatScreen first to create chat and connect WebSocket
                          context.push('/create-chat', extra: {
                            'dealerId': sellerId,
                            'dealerName': dealerName,
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
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.gray,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Car Location',
                                  style: AppTextStyles.blackS16W600,
                                ),
                                const Spacer(),
                                if (_isLoadingRoute)
                                  SizedBox(
                                    width: 16.w,
                                    height: 16.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () async {
                                    print(
                                        '🗺️ CarDetails: View Route button tapped');
                                    print(
                                        '🗺️ CarDetails: Car location string: ${car.location}');

                                    if (_userLocation == null) {
                                      print(
                                          '⚠️ CarDetails: User location is null, requesting...');
                                      // Try to get location again
                                      final userLocation = await LocationService
                                          .getCurrentLocation();
                                      if (userLocation == null) {
                                        print(
                                            '❌ CarDetails: Failed to get user location');
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
                                      print(
                                          '✅ CarDetails: User location obtained: ${userLocation.latitude}, ${userLocation.longitude}');
                                    }

                                    // Use existing coordinates if available, otherwise parse
                                    LatLng coords;
                                    if (_carCoordinates != null) {
                                      coords = _carCoordinates!;
                                      print(
                                          '🗺️ CarDetails: Using existing car coordinates: ${coords.latitude}, ${coords.longitude}');
                                    } else {
                                      print(
                                          '🗺️ CarDetails: Getting car coordinates...');
                                      coords = await _getCarCoordinates(
                                          car.location);
                                      setState(() {
                                        _carCoordinates = coords;
                                      });
                                      print(
                                          '🗺️ CarDetails: Parsed car coordinates: ${coords.latitude}, ${coords.longitude}');
                                    }

                                    print(
                                        '🗺️ CarDetails: Loading route from user (${_userLocation!.latitude}, ${_userLocation!.longitude}) to car (${coords.latitude}, ${coords.longitude})');
                                    await _loadRoute(
                                      coords.latitude,
                                      coords.longitude,
                                    );
                                    print('✅ CarDetails: Route loaded');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.map,
                                          color: AppColors.primary,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'View Route',
                                          style: AppTextStyles.s12w400.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
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
                                  width: 1,
                                ),
                              ),
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
                                      target: _carCoordinates ??
                                          const LatLng(25.2048, 55.2708),
                                      zoom: 15.0,
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
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _mapController = controller;
                                      print(
                                          '🗺️ CarDetails: Map controller created');
                                      // Update camera if we have both locations
                                      if (_userLocation != null &&
                                          _carCoordinates != null) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _updateCameraToFitRoute(
                                            _carCoordinates!.latitude,
                                            _carCoordinates!.longitude,
                                          );
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              car.location.isNotEmpty
                                  ? car.location
                                  : 'Dubai, UAE',
                              style: AppTextStyles.s14w400.copyWith(
                                color: AppColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8.h,
                  left: 8.w,
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 20.sp,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
