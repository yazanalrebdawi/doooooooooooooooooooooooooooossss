import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../../data/models/service_model.dart';

class ServiceMapScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceMapScreen({super.key, required this.service});

  @override
  State<ServiceMapScreen> createState() => _ServiceMapScreenState();
}

class _ServiceMapScreenState extends State<ServiceMapScreen> {
  GoogleMapController? _mapController;
  Position? _userLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      final position = await LocationService.getLocationWithFallback();
      setState(() {
        _userLocation = position;
        _isLoading = false;
      });

      _addMarkers();
      await Future.delayed(const Duration(milliseconds: 500));
      await _addRoutePolyline();
      await Future.delayed(const Duration(milliseconds: 500));
      _animateToShowBothMarkers();
    } catch (e) {
      print('❌ Error initializing map: $e');
      setState(() => _isLoading = false);
    }
  }

  void _addMarkers() {
    if (_userLocation == null) return;

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
          infoWindow: const InfoWindow(
            title: 'موقعك الحالي',
            snippet: 'موقع الجهاز',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('service_${widget.service.id}'),
          position: LatLng(widget.service.lat, widget.service.lon),
          infoWindow: InfoWindow(
            title: widget.service.name,
            snippet: widget.service.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            widget.service.type.toLowerCase().contains('mechanic')
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueGreen,
          ),
        ),
      );
    });
  }

  Future<void> _addRoutePolyline() async {
    if (_userLocation == null) {
      print('❌ ServiceMap: Cannot get route polyline - user location is null');
      return;
    }

    final serviceLat = widget.service.lat;
    final serviceLon = widget.service.lon;

    try {
      // Use the exact format: origin=LAT1,LNG1&destination=LAT2,LNG2&key=YOUR_KEY
      final originLat = _userLocation!.latitude;
      final originLng = _userLocation!.longitude;
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$serviceLat,$serviceLon&mode=driving&key=${AppConfig.googleMapsApiKey}';
      
      print('🗺️ ServiceMap: Requesting route from Google Directions API...');
      print('🗺️ ServiceMap: Origin: $originLat, $originLng');
      print('🗺️ ServiceMap: Destination: $serviceLat, $serviceLon');
      
      final response = await http.get(Uri.parse(url));
      print('🗺️ ServiceMap: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🗺️ ServiceMap: Directions API response status: ${data['status']}');
        
        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          // Get the overview_polyline from the route
          final route = data['routes'][0];
          final overviewPolyline = route['overview_polyline'];
          
          if (overviewPolyline != null && overviewPolyline['points'] != null) {
            final polylineEncoded = overviewPolyline['points'] as String;
            print('🗺️ ServiceMap: Got encoded polyline: ${polylineEncoded.substring(0, polylineEncoded.length > 50 ? 50 : polylineEncoded.length)}...');
            
            // Decode the polyline to get LatLng list
            final points = _decodePolyline(polylineEncoded);
            print('🗺️ ServiceMap: Decoded ${points.length} route points');
            
            if (points.isNotEmpty) {
              print('✅ ServiceMap: Route polyline created successfully');
              print('✅ ServiceMap: First point: ${points.first}');
              print('✅ ServiceMap: Last point: ${points.last}');
              
              setState(() {
                _polylines.clear();
                _polylines.add(
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: points, // List<LatLng> from decoded polyline
                    color: const Color(0xFF2196F3), // Bright blue
                    width: 8, // Thicker line for better visibility
                    geodesic: false, // Set to false for accurate street-level routing
                    patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                    visible: true,
                  ),
                );
              });
            } else {
              print('⚠️ ServiceMap: Decoded polyline has no points');
              // Try fallback services
              final fallbackPolyline = await _getRouteFromOpenRouteService(serviceLat, serviceLon);
              if (fallbackPolyline != null) {
                setState(() {
                  _polylines.clear();
                  _polylines.add(fallbackPolyline);
                });
              } else {
                setState(() {
                  _polylines.clear();
                });
              }
            }
          } else {
            print('⚠️ ServiceMap: No overview_polyline in route response');
            // Try fallback services
            final fallbackPolyline = await _getRouteFromOpenRouteService(serviceLat, serviceLon);
            if (fallbackPolyline != null) {
              setState(() {
                _polylines.clear();
                _polylines.add(fallbackPolyline);
              });
            } else {
              setState(() {
                _polylines.clear();
              });
            }
          }
        } else {
          print('⚠️ ServiceMap: Directions API returned status: ${data['status']}');
          if (data['error_message'] != null) {
            print('⚠️ ServiceMap: Error message: ${data['error_message']}');
          }
          
          // If Google API failed due to billing, try OpenRouteService as fallback
          if (data['status'] == 'REQUEST_DENIED' || data['status'] == 'OVER_QUERY_LIMIT') {
            print('🔄 ServiceMap: Google API unavailable, trying OpenRouteService fallback...');
            final fallbackPolyline = await _getRouteFromOpenRouteService(serviceLat, serviceLon);
            if (fallbackPolyline != null) {
              setState(() {
                _polylines.clear();
                _polylines.add(fallbackPolyline);
              });
            } else {
              setState(() {
                _polylines.clear();
              });
            }
          } else {
            setState(() {
              _polylines.clear();
            });
          }
        }
      } else {
        print('❌ ServiceMap: HTTP error: ${response.statusCode}');
        print('❌ ServiceMap: Response body: ${response.body}');
        // Try OpenRouteService as fallback
        print('🔄 ServiceMap: Trying OpenRouteService fallback...');
        final fallbackPolyline = await _getRouteFromOpenRouteService(serviceLat, serviceLon);
        if (fallbackPolyline != null) {
          setState(() {
            _polylines.clear();
            _polylines.add(fallbackPolyline);
          });
        } else {
          setState(() {
            _polylines.clear();
          });
        }
      }
    } catch (e) {
      print('❌ ServiceMap: Error getting route polyline: $e');
      print('❌ ServiceMap: Stack trace: ${StackTrace.current}');
      // Try OpenRouteService as fallback
      print('🔄 ServiceMap: Trying OpenRouteService fallback...');
      try {
        final fallbackPolyline = await _getRouteFromOpenRouteService(serviceLat, serviceLon);
        if (fallbackPolyline != null) {
          setState(() {
            _polylines.clear();
            _polylines.add(fallbackPolyline);
          });
        } else {
          setState(() {
            _polylines.clear();
          });
        }
      } catch (fallbackError) {
        print('❌ ServiceMap: OpenRouteService also failed: $fallbackError');
        setState(() {
          _polylines.clear();
        });
      }
    }
  }

  /// Fallback route using OpenRouteService (free alternative)
  Future<Polyline?> _getRouteFromOpenRouteService(double serviceLat, double serviceLon) async {
    if (_userLocation == null) return null;

    try {
      // OpenRouteService - API key should be in Authorization header with "Bearer" prefix
      // Or use it as query parameter: ?api_key=...
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248&start=${_userLocation!.longitude},${_userLocation!.latitude}&end=$serviceLon,$serviceLat';
      
      print('🗺️ ServiceMap: Requesting route from OpenRouteService...');
      print('🗺️ ServiceMap: OpenRouteService URL: $url');
      
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
              print('✅ ServiceMap: OpenRouteService route created with ${points.length} points');
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
        print('⚠️ ServiceMap: OpenRouteService HTTP error: ${response.statusCode}');
        print('⚠️ ServiceMap: OpenRouteService response: ${response.body}');
        // Try OSRM as another free alternative
        print('🔄 ServiceMap: Trying OSRM as alternative...');
        return await _getRouteFromOSRM(serviceLat, serviceLon);
      }
    } catch (e) {
      print('❌ ServiceMap: OpenRouteService error: $e');
      // Try OSRM as another free alternative
      print('🔄 ServiceMap: Trying OSRM as alternative...');
      try {
        return await _getRouteFromOSRM(serviceLat, serviceLon);
      } catch (osrmError) {
        print('❌ ServiceMap: OSRM also failed: $osrmError');
      }
    }

    return null;
  }

  /// Free routing service - OSRM (Open Source Routing Machine)
  Future<Polyline?> _getRouteFromOSRM(double serviceLat, double serviceLon) async {
    if (_userLocation == null) return null;

    try {
      // OSRM is a free, open-source routing service (no API key needed)
      // Format: /route/v1/driving/{lon1},{lat1};{lon2},{lat2}?overview=full&geometries=geojson
      final url =
          'https://router.project-osrm.org/route/v1/driving/${_userLocation!.longitude},${_userLocation!.latitude};$serviceLon,$serviceLat?overview=full&geometries=geojson';
      
      print('🗺️ ServiceMap: Requesting route from OSRM...');
      print('🗺️ ServiceMap: OSRM URL: $url');
      
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
              print('✅ ServiceMap: OSRM route created with ${points.length} points');
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
          print('⚠️ ServiceMap: OSRM returned code: ${data['code']}');
        }
      } else {
        print('⚠️ ServiceMap: OSRM HTTP error: ${response.statusCode}');
        print('⚠️ ServiceMap: OSRM response: ${response.body}');
      }
    } catch (e) {
      print('❌ ServiceMap: OSRM error: $e');
    }

    return null;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int shift = 0, result = 0, b;
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

  void _animateToShowBothMarkers() {
    if (_mapController == null || _userLocation == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        _userLocation!.latitude < widget.service.lat
            ? _userLocation!.latitude
            : widget.service.lat,
        _userLocation!.longitude < widget.service.lon
            ? _userLocation!.longitude
            : widget.service.lon,
      ),
      northeast: LatLng(
        _userLocation!.latitude > widget.service.lat
            ? _userLocation!.latitude
            : widget.service.lat,
        _userLocation!.longitude > widget.service.lon
            ? _userLocation!.longitude
            : widget.service.lon,
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'المسار إلى ${widget.service.name}',
          style: AppTextStyles.blackS18W700.copyWith(
            color: isDark ? Colors.white : AppColors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: AppColors.primary,
              size: 24.sp,
            ),
            onPressed: () {
              if (_userLocation != null && _mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(_userLocation!.latitude, _userLocation!.longitude),
                  ),
                );
              }
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white54
                                  : AppColors.gray.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            _mapController = controller;
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              _animateToShowBothMarkers,
                            );
                          },
                          initialCameraPosition: CameraPosition(
                            target:
                                _userLocation != null
                                    ? LatLng(
                                      _userLocation!.latitude,
                                      _userLocation!.longitude,
                                    )
                                    : LatLng(
                                      widget.service.lat,
                                      widget.service.lon,
                                    ),
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
                  ),
                  _buildServiceInfoCard(isDark),
                ],
              ),
    );
  }

  Widget _buildServiceInfoCard(bool isDark) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color:
                      widget.service.type.toLowerCase().contains('mechanic')
                          ? Colors.red
                          : Colors.blue,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  widget.service.type.toLowerCase().contains('mechanic')
                      ? Icons.build
                      : Icons.local_gas_station,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.name,
                      style: AppTextStyles.blackS16W600.copyWith(
                        color: isDark ? Colors.white : AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.service.address,
                      style: AppTextStyles.secondaryS14W400.copyWith(
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                '${_calculateDistance()} كم',
                style: AppTextStyles.secondaryS14W400.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: widget.service.openNow ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  widget.service.openNow ? 'مفتوح' : 'مغلق',
                  style: AppTextStyles.secondaryS12W400.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateDistance() {
    if (_userLocation == null) return '0.0';
    final distanceInMeters = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      widget.service.lat,
      widget.service.lon,
    );
    return (distanceInMeters / 1000).toStringAsFixed(1);
  }
}
