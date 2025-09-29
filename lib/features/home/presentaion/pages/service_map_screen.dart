import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    print('🎯 ServiceMap: Widget initialized with service: ${widget.service.name}');
    print('🎯 ServiceMap: Service location: ${widget.service.lat}, ${widget.service.lon}');
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    print('🗺️ ServiceMap: Initializing map...');
    try {
      // Get user location
      final position = await LocationService.getLocationWithFallback();
      print('✅ ServiceMap: User location obtained: ${position.latitude}, ${position.longitude}');
      
      setState(() {
        _userLocation = position;
        _isLoading = false;
      });

      // Add markers first
      _addMarkers();
      print('✅ ServiceMap: Markers added');
      
      // Wait longer for markers to be added
      await Future.delayed(Duration(milliseconds: 1000));
      
      // Add route polyline
      await _addRoutePolyline();
      print('✅ ServiceMap: Route polyline added');
      
      // Wait longer for polyline to be added
      await Future.delayed(Duration(milliseconds: 1000));
      
      // Animate to show both markers
      _animateToShowBothMarkers();
      print('✅ ServiceMap: Map animation completed');
    } catch (e) {
      print('❌ ServiceMap: Error initializing map: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMarkers() {
    if (_userLocation == null) {
      print('❌ ServiceMap: Cannot add markers - user location is null');
      return;
    }

    print('📍 ServiceMap: Adding markers...');
    
    // User location marker
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

    // Service location marker
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
            : BitmapDescriptor.hueGreen
        ),
      ),
    );
    
    print('✅ ServiceMap: Added ${_markers.length} markers');
  }

  Future<void> _addRoutePolyline() async {
    if (_userLocation == null) return;

    print('🗺️ ServiceMap: Getting route polyline...');
    try {
      const apiKey = 'AIzaSyCvFo9bVexv1f4O4lzdYqjPH7b-yf62k_c';
      final url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_userLocation!.latitude},${_userLocation!.longitude}&'
          'destination=${widget.service.lat},${widget.service.lon}&'
          'mode=driving&'
          'key=$apiKey';

      print('🌐 ServiceMap: Requesting route from Google Directions API...');
      print('📍 ServiceMap: Origin: ${_userLocation!.latitude},${_userLocation!.longitude}');
      print('📍 ServiceMap: Destination: ${widget.service.lat},${widget.service.lon}');
      print('🌐 ServiceMap: URL: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('📊 ServiceMap: API Response status: ${response.statusCode}');
      print('📊 ServiceMap: API Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📊 ServiceMap: API Response status: ${data['status']}');
        
        if (data['status'] == 'OK' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polylineEncoded = route['overview_polyline']['points'];
          
          print('✅ ServiceMap: Route found, decoding polyline...');
          final points = _decodePolyline(polylineEncoded);
          print('✅ ServiceMap: Polyline decoded with ${points.length} points');
          
          if (points.isNotEmpty) {
            setState(() {
              _polylines.clear(); // Clear existing polylines
              _polylines.add(
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: points,
                  color: Colors.blue,
                  width: 8, // Increased width for better visibility
                  geodesic: true,
                  patterns: [PatternItem.dot, PatternItem.gap(10)],
                  visible: true, // Ensure visibility
                ),
              );
            });
            print('✅ ServiceMap: Polyline added to map with ${points.length} points');
          } else {
            print('⚠️ ServiceMap: No points in polyline, using fallback');
            _addStraightLinePolyline();
          }
        } else {
          print('⚠️ ServiceMap: API Response error: ${data['status']}');
          if (data['error_message'] != null) {
            print('💬 ServiceMap: Error message: ${data['error_message']}');
          }
          // Fallback to straight line
          _addStraightLinePolyline();
        }
      } else {
        print('❌ ServiceMap: HTTP error: ${response.statusCode}');
        print('❌ ServiceMap: Response body: ${response.body}');
        // Fallback to straight line
        _addStraightLinePolyline();
      }
    } catch (e) {
      print('❌ ServiceMap: Error getting route polyline: $e');
      // Fallback to straight line
      _addStraightLinePolyline();
    }
  }

  void _addStraightLinePolyline() {
    if (_userLocation == null) return;
    
    print('📍 ServiceMap: Adding fallback straight line');
    setState(() {
      _polylines.clear(); // Clear existing polylines
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [
            LatLng(_userLocation!.latitude, _userLocation!.longitude),
            LatLng(widget.service.lat, widget.service.lon),
          ],
          color: AppColors.primary,
          width: 4,
          geodesic: true,
        ),
      );
    });
    print('✅ ServiceMap: Fallback straight line added');
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
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

      final p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  void _animateToShowBothMarkers() {
    if (_mapController == null || _userLocation == null) return;

    // Calculate bounds to show both markers
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

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50.0),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'المسار إلى ${widget.service.name}',
          style: AppTextStyles.blackS18W700,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: AppColors.primary, size: 24.sp),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Map Container
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16.w),
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
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              print('🗺️ ServiceMap: Map controller created');
                              // Delay animation to ensure markers and polylines are loaded
                              Future.delayed(Duration(milliseconds: 2000), () {
                                if (mounted) {
                                  _animateToShowBothMarkers();
                                  // Force refresh of polylines
                                  setState(() {});
                                }
                              });
                            },
                          initialCameraPosition: CameraPosition(
                            target: _userLocation != null
                                ? LatLng(_userLocation!.latitude, _userLocation!.longitude)
                                : LatLng(widget.service.lat, widget.service.lon),
                            zoom: 15.0,
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
                
                // Service Info Card
                Container(
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.gray.withOpacity(0.2),
                      width: 1,
                    ),
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
                              color: widget.service.type.toLowerCase().contains('mechanic') 
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
                                  style: AppTextStyles.blackS16W600,
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
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
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
    
    final distanceInKm = distanceInMeters / 1000;
    return distanceInKm.toStringAsFixed(1);
  }
}
