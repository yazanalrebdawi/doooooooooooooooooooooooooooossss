import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/location_service.dart';
import '../../data/models/service_model.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  Position? _userLocation;
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    print(
      '🎯 ServiceDetails: Widget initialized with service: ${widget.service.name}',
    );
    print(
        '🎯 ServiceDetails: Service data - ID: ${widget.service.id}, Name: ${widget.service.name}, Address: ${widget.service.address}');

    // Set initial marker for service immediately so map shows something
    _markers = {
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
    };

    // Initialize map asynchronously without blocking UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    try {
      final userLocation = await LocationService.getCurrentLocation();
      if (userLocation != null) {
        if (mounted) {
          setState(() => _userLocation = userLocation);
          await _loadRoute();
        }
      } else {
        print('❌ ServiceDetails: Failed to get user location');
        // Still show the map with just the service location
        if (mounted) {
          setState(() {
            _markers = {
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
            };
          });
        }
      }
    } catch (e) {
      print('❌ ServiceDetails: Error initializing map: $e');
      // Still show the map with just the service location
      if (mounted) {
        setState(() {
          _markers = {
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
          };
        });
      }
    }
  }

  Future<void> _loadRoute() async {
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
      };

      final polyline = await _getRoutePolyline();

      setState(() {
        _markers = markers;
        // Only set polyline if we got a real route from Directions API
        // Don't fallback to straight line - show error or retry instead
        if (polyline != null) {
          _polylines = {polyline};
          print('✅ ServiceDetails: Real route polyline added to map');
        } else {
          // Clear polylines if route failed - don't show straight line
          _polylines = {};
          print('⚠️ ServiceDetails: Route not available - no polyline shown');
        }
        _isLoadingRoute = false;
      });
    } catch (e) {
      print('❌ ServiceDetails: Error loading route: $e');
      setState(() => _isLoadingRoute = false);
    }
  }

  Future<Polyline?> _getRoutePolyline() async {
    if (_userLocation == null) {
      print('❌ ServiceDetails: Cannot get route polyline - user location is null');
      return null;
    }

    final serviceLat = widget.service.lat;
    final serviceLon = widget.service.lon;

    try {
      // Use the exact format: origin=LAT1,LNG1&destination=LAT2,LNG2&key=YOUR_KEY
      final originLat = _userLocation!.latitude;
      final originLng = _userLocation!.longitude;
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLng&destination=$serviceLat,$serviceLon&mode=driving&key=${AppConfig.googleMapsApiKey}';
      
      print('🗺️ ServiceDetails: Requesting route from Google Directions API...');
      print('🗺️ ServiceDetails: Origin: $originLat, $originLng');
      print('🗺️ ServiceDetails: Destination: $serviceLat, $serviceLon');
      
      final response = await http.get(Uri.parse(url));
      print('🗺️ ServiceDetails: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🗺️ ServiceDetails: Directions API response status: ${data['status']}');
        
        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          // Get the overview_polyline from the route
          final route = data['routes'][0];
          final overviewPolyline = route['overview_polyline'];
          
          if (overviewPolyline != null && overviewPolyline['points'] != null) {
            final polylineEncoded = overviewPolyline['points'] as String;
            print('🗺️ ServiceDetails: Got encoded polyline: ${polylineEncoded.substring(0, polylineEncoded.length > 50 ? 50 : polylineEncoded.length)}...');
            
            // Decode the polyline to get LatLng list
            final points = _decodePolyline(polylineEncoded);
            print('🗺️ ServiceDetails: Decoded ${points.length} route points');
            
            if (points.isNotEmpty) {
              print('✅ ServiceDetails: Route polyline created successfully');
              print('✅ ServiceDetails: First point: ${points.first}');
              print('✅ ServiceDetails: Last point: ${points.last}');
              
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
              print('⚠️ ServiceDetails: Decoded polyline has no points');
            }
          } else {
            print('⚠️ ServiceDetails: No overview_polyline in route response');
          }
        } else {
          print('⚠️ ServiceDetails: Directions API returned status: ${data['status']}');
          if (data['error_message'] != null) {
            print('⚠️ ServiceDetails: Error message: ${data['error_message']}');
          }
          
          // If Google API failed due to billing, try OpenRouteService as fallback
          if (data['status'] == 'REQUEST_DENIED' || data['status'] == 'OVER_QUERY_LIMIT') {
            print('🔄 ServiceDetails: Google API unavailable, trying OpenRouteService fallback...');
            return await _getRouteFromOpenRouteService(serviceLat, serviceLon);
          }
        }
      } else {
        print('❌ ServiceDetails: HTTP error: ${response.statusCode}');
        print('❌ ServiceDetails: Response body: ${response.body}');
        // Try OpenRouteService as fallback
        print('🔄 ServiceDetails: Trying OpenRouteService fallback...');
        return await _getRouteFromOpenRouteService(serviceLat, serviceLon);
      }
    } catch (e) {
      print('❌ ServiceDetails: Error getting route polyline: $e');
      print('❌ ServiceDetails: Stack trace: ${StackTrace.current}');
      // Try OpenRouteService as fallback
      print('🔄 ServiceDetails: Trying OpenRouteService fallback...');
      try {
        return await _getRouteFromOpenRouteService(serviceLat, serviceLon);
      } catch (fallbackError) {
        print('❌ ServiceDetails: OpenRouteService also failed: $fallbackError');
      }
    }

    return null;
  }

  /// Fallback route using OpenRouteService (free alternative)
  Future<Polyline?> _getRouteFromOpenRouteService(double serviceLat, double serviceLon) async {
    if (_userLocation == null) return null;

    try {
      // OpenRouteService - API key should be in Authorization header with "Bearer" prefix
      // Or use it as query parameter: ?api_key=...
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248&start=${_userLocation!.longitude},${_userLocation!.latitude}&end=$serviceLon,$serviceLat';
      
      print('🗺️ ServiceDetails: Requesting route from OpenRouteService...');
      print('🗺️ ServiceDetails: OpenRouteService URL: $url');
      
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
              print('✅ ServiceDetails: OpenRouteService route created with ${points.length} points');
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
        print('⚠️ ServiceDetails: OpenRouteService HTTP error: ${response.statusCode}');
        print('⚠️ ServiceDetails: OpenRouteService response: ${response.body}');
        // Try OSRM as another free alternative
        print('🔄 ServiceDetails: Trying OSRM as alternative...');
        return await _getRouteFromOSRM(serviceLat, serviceLon);
      }
    } catch (e) {
      print('❌ ServiceDetails: OpenRouteService error: $e');
      // Try OSRM as another free alternative
      print('🔄 ServiceDetails: Trying OSRM as alternative...');
      try {
        return await _getRouteFromOSRM(serviceLat, serviceLon);
      } catch (osrmError) {
        print('❌ ServiceDetails: OSRM also failed: $osrmError');
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
      
      print('🗺️ ServiceDetails: Requesting route from OSRM...');
      print('🗺️ ServiceDetails: OSRM URL: $url');
      
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
              print('✅ ServiceDetails: OSRM route created with ${points.length} points');
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
          print('⚠️ ServiceDetails: OSRM returned code: ${data['code']}');
        }
      } else {
        print('⚠️ ServiceDetails: OSRM HTTP error: ${response.statusCode}');
        print('⚠️ ServiceDetails: OSRM response: ${response.body}');
      }
    } catch (e) {
      print('❌ ServiceDetails: OSRM error: $e');
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.translate('serviceLocation'),
          style: AppTextStyles.blackS18W700,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppColors.black, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(isDark),
            _buildDistanceSection(),
            _buildWorkingHoursSection(),
            _buildContactSection(),
            _buildMapSection(),
            _buildAboutSection(),
            _buildServicesSection(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.service.name,
                  style: AppTextStyles.blackS18W700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: widget.service.openNow ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  widget.service.openNow ? 'Open Now' : 'Closed',
                  style: AppTextStyles.secondaryS12W400.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            widget.service.address,
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildDistanceSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(Icons.directions_car, color: AppColors.gray, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            widget.service.distance != null
                ? '${(widget.service.distance! / 1000).toStringAsFixed(1)} ${AppLocalizations.of(context)!.translate('kmAway')}'
                : AppLocalizations.of(
                    context,
                  )!
                    .translate('distanceNotAvailable'),
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: AppColors.gray,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final url = widget.service.mapsUrl;
              if (await canLaunchUrl(Uri.parse(url)))
                await launchUrl(Uri.parse(url));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.send, color: AppColors.white, size: 14.sp),
                SizedBox(width: 8.w),
                Text(
                  'Get\nDirections',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.secondaryS12W400.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.gray, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.translate('workingHours'),
                style: AppTextStyles.blackS16W600,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.service.open24h
                ? '24 Hours'
                : widget.service.openingText.isNotEmpty
                    ? widget.service.openingText
                    : '${widget.service.openFrom ?? 'N/A'} - ${widget.service.openTo ?? 'N/A'}',
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('contact'),
            style: AppTextStyles.blackS16W600,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = widget.service.callUrl;
                if (await canLaunchUrl(Uri.parse(url)))
                  await launchUrl(Uri.parse(url));
              },
              icon: Icon(Icons.phone, color: AppColors.white, size: 18.sp),
              label: Text(
                '${AppLocalizations.of(context)!.translate('callNow')}: ${widget.service.phonePrimary}',
                style: AppTextStyles.secondaryS14W400.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.gray, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.translate('location'),
                style: AppTextStyles.blackS16W600,
              ),
              const Spacer(),
              if (_isLoadingRoute)
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              GestureDetector(
                onTap: () =>
                    context.push('/service-map', extra: widget.service),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map, color: AppColors.primary, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'View Map',
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
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.service.lat, widget.service.lon),
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
            widget.service.address,
            style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('aboutServiceProvider'),
            style: AppTextStyles.blackS16W600,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: widget.service.type.toLowerCase().contains('station')
                      ? Colors.blue
                      : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.service.type.toLowerCase().contains('station')
                      ? Icons.local_gas_station
                      : Icons.directions_car,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.name,
                      style: AppTextStyles.blackS16W600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    if (widget.service.services.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('servicesAtLocation'),
            style: AppTextStyles.blackS16W600,
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: widget.service.services
                .map(
                  (serviceName) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.gray.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      serviceName,
                      style: AppTextStyles.secondaryS12W400.copyWith(
                        color: AppColors.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gray.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
