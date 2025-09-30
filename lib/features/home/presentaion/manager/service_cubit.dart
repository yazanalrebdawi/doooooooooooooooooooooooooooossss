import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import 'service_state.dart';
import 'package:dooss_business_app/features/home/data/data_source/service_remote_data_source.dart';
import 'package:dooss_business_app/core/services/location_service.dart';
import 'package:dooss_business_app/features/home/data/models/service_model.dart';
import 'package:geolocator/geolocator.dart';

class ServiceCubit extends OptimizedCubit<ServiceState> {
  final ServiceRemoteDataSource dataSource;

  ServiceCubit(this.dataSource) : super(const ServiceState());

  //! Done ✅
  void loadServices({int limit = 5}) async {
    safeEmit(state.copyWith(isLoading: true, error: null));
    try {
      print('🔍 ServiceCubit: Starting to load services (limit: $limit)...');

      // Check location permission first
      bool hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        safeEmit(
          state.copyWith(
            error: 'location_permission_required',
            isLoading: false,
          ),
        );
        return;
      }

      // Get location with fallback
      final position = await LocationService.getLocationWithFallback();
      print(
        '📍 Location for services: lat=${position.latitude}, lon=${position.longitude}',
      );

      // Load nearby services based on location with pagination
      final services = await dataSource.fetchNearbyServices(
        lat: position.latitude,
        lon: position.longitude,
        radius: 10000, // 10km radius
        limit: limit,
        offset: 0,
      );
      print(
        '✅ Services loaded successfully: ${services.length} services found',
      );

      safeEmit(state.copyWith(services: services, isLoading: false));

      // Calculate distances for all services
      await calculateServiceDistances();
    } catch (e) {
      print('❌ ServiceCubit error: $e');
      safeEmit(
        state.copyWith(
          error: 'Failed to load services: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  Future<bool> _checkLocationPermission() async {
    return await LocationService.requestLocationPermission();
  }

  void loadNearbyServices({
    required double lat,
    required double lon,
    String? type,
    int radius = 5000,
  }) async {
    safeEmit(state.copyWith(isLoading: true, error: null));
    try {
      final services = await dataSource.fetchNearbyServices(
        lat: lat,
        lon: lon,
        type: type,
        radius: radius,
      );
      safeEmit(
        state.copyWith(
          services: services,
          isLoading: false,
          selectedFilter: 'All',
        ),
      );
    } catch (e) {
      print('ServiceCubit loadNearbyServices error: $e');
      safeEmit(
        state.copyWith(
          error: 'Failed to load nearby services',
          isLoading: false,
        ),
      );
    }
  }

  void loadServiceDetails(int serviceId) async {
    emit(state.copyWith(isLoadingDetails: true, error: null));
    try {
      final service = await dataSource.fetchServiceDetails(serviceId);
      safeEmit(
        state.copyWith(selectedService: service, isLoadingDetails: false),
      );
    } catch (e) {
      print('ServiceCubit loadServiceDetails error: $e');
      safeEmit(
        state.copyWith(
          error: 'Failed to load service details',
          isLoadingDetails: false,
        ),
      );
    }
  }

  /// حساب المسافات لكل الخدمات
  Future<void> calculateServiceDistances() async {
    try {
      final position = await LocationService.getLocationWithFallback();
      final servicesWithDistance = <ServiceModel>[];

      for (final service in state.services) {
        final distance = await LocationService.calculateDistance(
          startLatitude: position.latitude,
          startLongitude: position.longitude,
          endLatitude: service.lat,
          endLongitude: service.lon,
        );

        final serviceWithDistance = service.copyWith(distance: distance);
        servicesWithDistance.add(serviceWithDistance);
      }

      safeEmit(state.copyWith(services: servicesWithDistance));
    } catch (e) {
      print('❌ Error calculating distances: $e');
    }
  }

  //! Done ✅
  void filterServices(String filter, {int limit = 10}) async {
    emit(state.copyWith(selectedFilter: filter, isLoading: true));

    try {
      final position = await LocationService.getLocationWithFallback();

      if (filter.toLowerCase() == 'all') {
        final services = await dataSource.fetchNearbyServices(
          lat: position.latitude,
          lon: position.longitude,
          radius: 10000,
          limit: limit,
          offset: 0,
        );
        safeEmit(state.copyWith(services: services, isLoading: false));
      } else if (filter.toLowerCase() == 'mechanics') {
        final services = await dataSource.fetchNearbyServices(
          lat: position.latitude,
          lon: position.longitude,
          type: 'mechanic',
          radius: 10000,
          limit: limit,
          offset: 0,
        );
        safeEmit(state.copyWith(services: services, isLoading: false));
      } else if (filter.toLowerCase() == 'petrol') {
        final services = await dataSource.fetchNearbyServices(
          lat: position.latitude,
          lon: position.longitude,
          type: 'petrol_station',
          radius: 10000,
          limit: limit,
          offset: 0,
        );
        safeEmit(state.copyWith(services: services, isLoading: false));
      } else if (filter.toLowerCase() == 'opennow' ||
          filter.toLowerCase() == 'open now') {
        final services = await dataSource.fetchNearbyServices(
          lat: position.latitude,
          lon: position.longitude,
          radius: 10000,
          limit: limit,
          offset: 0,
        );
        final openServices =
            services.where((service) => service.openNow).toList();
        safeEmit(state.copyWith(services: openServices, isLoading: false));
      }
    } catch (e) {
      print('❌ ServiceCubit filterServices error: $e');
      safeEmit(
        state.copyWith(error: 'Failed to filter services', isLoading: false),
      );
    }
  }

  /// تبديل حالة المفضلة
  void toggleServiceFavorite(int serviceId) {
    // هنا عادةً يتم تحديث الحالة في الـ backend
    // مؤقتًا سنقوم فقط بإعادة إرسال الحالة نفسها
    emit(state.copyWith());
  }
}
