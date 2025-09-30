import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
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
  State<NearbyServicesMapWidget> createState() => _NearbyServicesMapWidgetState();
}

class ServiceClusterItem extends ClusterItem {
  final ServiceModel service;

  ServiceClusterItem(this.service) : super(LatLng(service.lat, service.lon));
}

class _NearbyServicesMapWidgetState extends State<NearbyServicesMapWidget> {
  GoogleMapController? _mapController;
  Position? _userLocation;
  bool _isLoading = true;

  late ClusterManager<ServiceClusterItem> _clusterManager;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _clusterManager = ClusterManager<ServiceClusterItem>(
      widget.services.map((service) => ServiceClusterItem(service)).toList(),
      _updateMarkers,
      markerBuilder: _markerBuilder,
      stopClusteringZoom: 17,
    );
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      final position = await LocationService.getLocationWithFallback();
      setState(() {
        _userLocation = position;
        _isLoading = false;
      });
      // Initialize markers via cluster manager
      _clusterManager.setMapId(_mapController?.mapId);
      _clusterManager.updateMap();
    } catch (e) {
      print('❌ Error initializing map: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
      // Add user location marker manually
      if (_userLocation != null) {
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
      }
    });
  }

  Future<Marker> _markerBuilder(Cluster<ServiceClusterItem> cluster) async {
    if (cluster.isMultiple) {
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(125, 125)),
          'assets/cluster_icon.png',
        ),
        onTap: () {
          _mapController?.animateCamera(CameraUpdate.zoomTo(
              _mapController!.cameraPosition.zoom + 2));
        },
      );
    } else {
      final service = cluster.items.first.service;
      bool isMechanic = service.type.toLowerCase().contains('mechanic') ||
          service.name.toLowerCase().contains('garage') ||
          service.name.toLowerCase().contains('repair');
      return Marker(
        markerId: MarkerId('service_${service.id}'),
        position: cluster.location,
        infoWindow: InfoWindow(
          title: service.name,
          snippet: service.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isMechanic ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
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
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  _clusterManager.setMapId(controller.mapId);
                  _clusterManager.updateMap();
                },
                initialCameraPosition: CameraPosition(
                  target: _userLocation != null
                      ? LatLng(_userLocation!.latitude, _userLocation!.longitude)
                      : const LatLng(AppConfig.defaultLatitude, AppConfig.defaultLongitude),
                  zoom: AppConfig.defaultZoom,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                onCameraMove: _clusterManager.onCameraMove,
                onCameraIdle: _clusterManager.updateMap,
              ),
      ),
    );
  }
}
