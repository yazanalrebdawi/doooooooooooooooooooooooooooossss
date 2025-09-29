import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/services/location_service.dart';
import '../../data/models/service_model.dart';

class NearbyServicesMapWidget extends StatefulWidget {
  final List<ServiceModel> services;

  const NearbyServicesMapWidget({
    super.key,
    required this.services,
  });

  @override
  State<NearbyServicesMapWidget> createState() =>
      _NearbyServicesMapWidgetState();
}

class _NearbyServicesMapWidgetState extends State<NearbyServicesMapWidget> {
  GoogleMapController? _mapController;
  Position? _userLocation;
  Set<Marker> _markers = {};
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
    } catch (e) {
      print('❌ Error initializing map: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addMarkers() {
    if (_userLocation == null) return;

    _markers.clear();

    // User marker
    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: LatLng(_userLocation!.latitude, _userLocation!.longitude),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Current device location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      ),
    );

    // Service markers
    for (int i = 0; i < widget.services.length && i < 6; i++) {
      final service = widget.services[i];
      final isMechanic = service.type.toLowerCase().contains('mechanic') ||
          service.name.toLowerCase().contains('garage') ||
          service.name.toLowerCase().contains('repair');

      _markers.add(
        Marker(
          markerId: MarkerId('service_${service.id}'),
          position: LatLng(service.lat, service.lon),
          infoWindow: InfoWindow(
            title: service.name,
            snippet: service.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isMechanic ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.gray.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: _isLoading
            ? Container(
                color: AppColors.gray.withOpacity(0.1),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              )
            : GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _userLocation != null
                      ? LatLng(_userLocation!.latitude, _userLocation!.longitude)
                      : const LatLng(
                          AppConfig.defaultLatitude,
                          AppConfig.defaultLongitude,
                        ),
                  zoom: AppConfig.defaultZoom,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
              ),
      ),
    );
  }
}
