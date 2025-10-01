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
  }

  Future<void> _addRoutePolyline() async {
    if (_userLocation == null) return;

    try {
      const apiKey = 'AIzaSyCvFo9bVexv1f4O4lzdYqjPH7b-yf62k_c';
      final url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${widget.service.lat},${widget.service.lon}&mode=driving&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final polylineEncoded =
              data['routes'][0]['overview_polyline']['points'];
          final points = _decodePolyline(polylineEncoded);
          if (points.isNotEmpty) {
            setState(() {
              _polylines.clear();
              _polylines.add(
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: points,
                  color: Colors.blue,
                  width: 6,
                  geodesic: true,
                  patterns: [PatternItem.dot, PatternItem.gap(10)],
                ),
              );
            });
          } else {
            _addStraightLinePolyline();
          }
        } else {
          _addStraightLinePolyline();
        }
      } else {
        _addStraightLinePolyline();
      }
    } catch (e) {
      _addStraightLinePolyline();
    }
  }

  void _addStraightLinePolyline() {
    if (_userLocation == null) return;

    setState(() {
      _polylines.clear();
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
