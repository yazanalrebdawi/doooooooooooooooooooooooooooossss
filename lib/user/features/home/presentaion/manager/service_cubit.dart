import 'package:dooss_business_app/user/core/cubits/optimized_cubit.dart';
import 'service_state.dart';
import 'package:dooss_business_app/user/features/home/data/data_source/service_remote_data_source.dart';
import 'package:dooss_business_app/user/core/services/location_service.dart';
import 'package:dooss_business_app/user/features/home/data/models/service_model.dart';
import 'package:geolocator/geolocator.dart';

class ServiceCubit extends OptimizedCubit<ServiceState> {
  final ServiceRemoteDataSource dataSource;
  String? _lastLoadedType; // Track the last loaded type to detect changes

  ServiceCubit(this.dataSource) : super(const ServiceState());

  /// Clear error state - useful when permission is granted
  void clearError() {
    print('🧹 ServiceCubit: Clearing error state (current error: ${state.error})');
    safeEmit(state.copyWith(clearError: true, isLoading: false));
    print('🧹 ServiceCubit: Error cleared (new error: ${state.error})');
  }

  /// Load services without checking permission (use when permission is already granted)
  Future<void> loadServicesWithoutPermissionCheck({
    int limit = 5,
    String? type,
    int radius = 5000,
  }) async {
    _lastLoadedType = type;
    // Force a state change to trigger UI rebuild
    print('🔄 ServiceCubit: Starting load (current services: ${state.services.length})');
    safeEmit(state.copyWith(isLoading: true, clearError: true, hasAttemptedLoad: true));
    
    try {
      print('🔍 ServiceCubit: Loading services without permission check...');

      // Try to get location directly (skip permission check)
      Position? currentPosition;
      try {
        currentPosition = await LocationService.getCurrentLocation();
        if (currentPosition == null) {
          print('🔄 Retrying location fetch...');
          await Future.delayed(const Duration(milliseconds: 500));
          currentPosition = await LocationService.getCurrentLocation();
        }
      } catch (e) {
        print('❌ Error getting location: $e');
      }

      // Use fallback if needed
      final position = currentPosition ?? await LocationService.getLocationWithFallback();

      print('📍 Location for services: lat=${position.latitude}, lon=${position.longitude}');

      // Load services
      final services = await dataSource.fetchNearbyServices(
        lat: position.latitude,
        lon: position.longitude,
        type: type,
        radius: radius,
        limit: limit,
        offset: 0,
      );

      print('✅ Services loaded successfully: ${services.length} services found');

      // If no services found and we have a type filter, try without type as fallback
      if (services.isEmpty && type != null) {
        print('⚠️ No services found with type=$type, trying without type filter...');
        try {
          final allServices = await dataSource.fetchNearbyServices(
            lat: position.latitude,
            lon: position.longitude,
            type: null, // Try without type
            radius: radius,
            limit: limit,
            offset: 0,
          );
          if (allServices.isNotEmpty) {
            print('✅ Found ${allServices.length} services without type filter');
            final newState = state.copyWith(
              services: allServices,
              isLoading: false,
              clearError: true,
              hasAttemptedLoad: true,
            );
            safeEmit(newState);
            await calculateServiceDistances();
            safeEmit(state.copyWith(services: state.services, clearError: true));
            print('📤 ServiceCubit: Emitted updated state after distance calculation');
            return;
          }
        } catch (e) {
          print('❌ Error loading services without type: $e');
        }
      }

      // Emit new state with services - explicitly clear error using clearError flag
      final newState = state.copyWith(
        services: services, 
        isLoading: false, 
        clearError: true, // Explicitly clear error
        hasAttemptedLoad: true,
      );
      safeEmit(newState);
      print('📤 ServiceCubit: Emitted new state with ${services.length} services (error cleared: ${newState.error})');

      if (services.isNotEmpty) {
        await calculateServiceDistances();
        // Emit again after distances are calculated to trigger UI update - make sure error is cleared
        safeEmit(state.copyWith(services: state.services, clearError: true));
        print('📤 ServiceCubit: Emitted updated state after distance calculation (error cleared)');
      }
    } catch (e) {
      print('❌ ServiceCubit error: $e');
      safeEmit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  //! Done ✅
  void loadServices(
      {int limit = 5,
      String? type,
      int radius = 5000,
      bool forceRefresh = false}) async {
    // Don't reload if services already exist, same type, and we're not forcing a refresh
    // But always reload if type parameter changes OR if there's an error
    final currentType = _lastLoadedType;
    if (!forceRefresh &&
        state.services.isNotEmpty &&
        !state.isLoading &&
        currentType == type &&
        state.error == null) { // Also reload if there's an error
      print(
          '🔍 ServiceCubit: Services already loaded with same type ($type), skipping...');
      return;
    }

    _lastLoadedType = type;
    safeEmit(
        state.copyWith(isLoading: true, clearError: true, hasAttemptedLoad: true));
    try {
      print(
          '🔍 ServiceCubit: Starting to load services (limit: $limit, type: $type, radius: $radius)...');

      // Check location permission first (with force refresh to sync between packages)
      bool hasPermission = await _checkLocationPermission(forceRefresh: forceRefresh);
      if (!hasPermission) {
        safeEmit(
          state.copyWith(
            error: 'location_permission_required',
            isLoading: false,
            hasAttemptedLoad: true, // Ensure hasAttemptedLoad is set when permission is denied
          ),
        );
        return;
      }

      // Try to get location (with optimized retry - only 1 retry for speed)
      Position? currentPosition;
      try {
        currentPosition = await LocationService.getCurrentLocation();
        // If first attempt fails, try once more with a short delay
        if (currentPosition == null) {
          print('🔄 Retrying location fetch (1 retry only)...');
          await Future.delayed(Duration(milliseconds: 300));
          currentPosition = await LocationService.getCurrentLocation();
        }
      } catch (e) {
        print('❌ Error getting location: $e');
      }

      // Use fallback only if we couldn't get real location
      final position =
          currentPosition ?? await LocationService.getLocationWithFallback();

      print(
        '📍 Location for services: lat=${position.latitude}, lon=${position.longitude}',
      );

      // Warn if using fallback location
      if (position.latitude == 25.2048 && position.longitude == 55.2708) {
        print(
            '⚠️ WARNING: Using fallback location (Dubai). Real location unavailable.');
      }

      // Load nearby services based on location with pagination
      final services = await dataSource.fetchNearbyServices(
        lat: position.latitude,
        lon: position.longitude,
        type: type,
        radius: radius,
        limit: limit,
        offset: 0,
      );
      print(
        '✅ Services loaded successfully: ${services.length} services found',
      );

      // If no services found and we have a type filter, try without type as fallback
      if (services.isEmpty && type != null && state.services.isEmpty) {
        print(
            '⚠️ No services found with type=$type, trying without type filter...');
        try {
          final allServices = await dataSource.fetchNearbyServices(
            lat: position.latitude,
            lon: position.longitude,
            type: null, // Try without type
            radius: radius,
            limit: limit,
            offset: 0,
          );
          if (allServices.isNotEmpty) {
            print('✅ Found ${allServices.length} services without type filter');
            safeEmit(state.copyWith(services: allServices, isLoading: false));
            await calculateServiceDistances();
            return;
          }
        } catch (e) {
          print('❌ Error loading services without type: $e');
        }
      }

      // Always update with the result, even if empty (for new instances)
      safeEmit(state.copyWith(services: services, isLoading: false));

      // Only calculate distances if we have services
      if (services.isNotEmpty) {
        await calculateServiceDistances();
      }
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

  Future<bool> _checkLocationPermission({bool forceRefresh = false}) async {
    // Only check if permission is already granted (don't request - UI must show disclosure first)
    // forceRefresh ensures sync between Geolocator and location packages
    return await LocationService.checkLocationPermission(forceRefresh: forceRefresh);
  }

  void loadNearbyServices({
    required double lat,
    required double lon,
    String? type,
    int radius = 5000,
  }) async {
    safeEmit(state.copyWith(isLoading: true, clearError: true));
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
      // Don't calculate if services list is empty
      if (state.services.isEmpty) {
        print('⚠️ No services to calculate distances for');
        return;
      }

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

      // Only update if we have services
      if (servicesWithDistance.isNotEmpty) {
        safeEmit(state.copyWith(services: servicesWithDistance));
      }
    } catch (e) {
      print('❌ Error calculating distances: $e');
      // Don't clear services on error, just log it
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
