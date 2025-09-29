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

  const ServiceState({
    this.services = const [],
    this.filteredServices = const [],
    this.selectedService,
    this.isLoading = false,
    this.isLoadingDetails = false,
    this.error,
    this.selectedFilter = 'All',
  });

  ServiceState copyWith({
    List<ServiceModel>? services,
    List<ServiceModel>? filteredServices,
    ServiceModel? selectedService,
    bool? isLoading,
    bool? isLoadingDetails,
    String? error,
    String? selectedFilter,
  }) {
    return ServiceState(
      services: services ?? this.services,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedService: selectedService ?? this.selectedService,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      error: error ?? this.error,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
