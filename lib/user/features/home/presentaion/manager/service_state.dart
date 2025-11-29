// Service State
// Single state class for service feature

import '../../data/models/service_model.dart';

class ServiceState {
  final List<ServiceModel> services;
  final List<ServiceModel> filteredServices;
  final ServiceModel? selectedService;
  final bool isLoading;
  final bool isLoadingDetails;
  final String? error;
  final String selectedFilter;
  final bool hasAttemptedLoad; // Track if we've tried to load at least once

  const ServiceState({
    this.services = const [],
    this.filteredServices = const [],
    this.selectedService,
    this.isLoading = false,
    this.isLoadingDetails = false,
    this.error,
    this.selectedFilter = 'All',
    this.hasAttemptedLoad = false,
  });

  ServiceState copyWith({
    List<ServiceModel>? services,
    List<ServiceModel>? filteredServices,
    ServiceModel? selectedService,
    bool? isLoading,
    bool? isLoadingDetails,
    String? error,
    String? selectedFilter,
    bool? hasAttemptedLoad,
    bool clearError = false, // Flag to explicitly clear error
  }) {
    return ServiceState(
      services: services ?? this.services,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedService: selectedService ?? this.selectedService,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      error: clearError ? null : (error ?? this.error), // Clear error if flag is set
      selectedFilter: selectedFilter ?? this.selectedFilter,
      hasAttemptedLoad: hasAttemptedLoad ?? this.hasAttemptedLoad,
    );
  }
}
