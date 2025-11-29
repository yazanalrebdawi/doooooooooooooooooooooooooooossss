import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/cars_available_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/products_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/services_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/services_section_widget.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/reels_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/messages_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/account_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/loading_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/error_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_state.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/car_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/car_state.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/product_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/product_state.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/service_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/service_state.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_state.dart';
import 'package:dooss_business_app/user/core/services/location_service.dart';

class ContentSection extends StatefulWidget {
  const ContentSection({super.key});

  @override
  State<ContentSection> createState() => _ContentSectionState();
}

class _ContentSectionState extends State<ContentSection> {
  int? _lastSelectedBrowseType;
  int? _lastCurrentIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex ||
          previous.selectedBrowseType != current.selectedBrowseType,
      builder: (context, homeState) {
        // Content based on home tab browse type
        if (homeState.currentIndex == 0) {
          switch (homeState.selectedBrowseType) {
            case 0: // Cars
              return _buildCarsSection(context);
            case 1: // Products
              return _buildProductsSection(context);
            case 2: // Services
              return _buildServicesSection(context);
            default:
              return _buildCarsSection(context);
          }
        }

        // Content based on bottom navigation
        switch (homeState.currentIndex) {
          case 1: // Services
            return _buildServicesSection(context);
          case 2: // Reels
            return _buildReelsSection(context);
          case 3: // Messages
            return const MessagesSection();
          case 4: // Account
            return const AccountSection();
          default:
            return _buildCarsSection(context);
        }
      },
    );
  }

  Widget _buildCarsSection(BuildContext context) {
    return BlocBuilder<CarCubit, CarState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.error != current.error ||
          previous != current,
      builder: (context, state) {
        if (state.isLoading) {
          return LoadingSection(
            title: AppLocalizations.of(context)
                    ?.translate('carsAvailableNow') ??
                'Cars Available Now',
          );
        }
        if (state.error != null) {
          return ErrorSection(
            title: AppLocalizations.of(context)?.translate('carsAvailableNow') ??
                'Cars Available Now',
            message: state.error!,
          );
        }
        if (state.cars.isNotEmpty) {
          return CarsAvailableSection(
            cars: state.cars,
            onViewAllPressed: () => context.push(RouteNames.allCarsScreen),
            // onCarPressed: () =>
            //     context.push('/car-details/${state.}'), // Example navigation
          );
        }
        return LoadingSection(
          title: AppLocalizations.of(context)?.translate('carsAvailableNow') ??
              'Cars Available Now',
        );
      },
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.error != current.error ||
          previous != current,
      builder: (context, state) {
        if (state.isLoading) {
          return LoadingSection(
            title: AppLocalizations.of(context)?.translate('carProducts') ??
                'Car Products',
          );
        }
        if (state.error != null) {
          return ErrorSection(
            title: AppLocalizations.of(context)?.translate('carProducts') ??
                'Car Products',
            message: state.error!,
          );
        }
        if (state.products.isNotEmpty) {
          return ProductsSection(products: state.products);
        }
        return LoadingSection(
          title: AppLocalizations.of(context)?.translate('carProducts') ??
              'Car Products',
        );
      },
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.selectedBrowseType != current.selectedBrowseType ||
          previous.currentIndex != current.currentIndex,
      builder: (context, homeState) {
        // When services tab is selected, reload services
        final isServicesTab = (homeState.currentIndex == 0 && homeState.selectedBrowseType == 2) ||
            homeState.currentIndex == 1;
        
        // Only reload if tab actually changed
        final browseTypeChanged = _lastSelectedBrowseType != homeState.selectedBrowseType;
        final indexChanged = _lastCurrentIndex != homeState.currentIndex;
        
        if (isServicesTab && (browseTypeChanged || indexChanged)) {
          _lastSelectedBrowseType = homeState.selectedBrowseType;
          _lastCurrentIndex = homeState.currentIndex;
          
          // Use post frame callback to reload when tab is selected
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (mounted && context.mounted) {
              final cubit = context.read<ServiceCubit>();
              print('🔄 ServicesSection: Reloading services for tab (browseType: ${homeState.selectedBrowseType}, index: ${homeState.currentIndex})...');
              
              // Check permission first - if denied, loadServices will set error
              // If granted, use loadServicesWithoutPermissionCheck for faster loading
              final hasPermission = await LocationService.checkLocationPermission(forceRefresh: true);
              if (hasPermission) {
                cubit.clearError();
                cubit.loadServicesWithoutPermissionCheck(
                  limit: 10,
                  type: 'station',
                  radius: 5000,
                );
              } else {
                // Permission denied - use loadServices to set proper error state
                cubit.loadServices(
                  limit: 10,
                  type: 'station',
                  radius: 5000,
                  forceRefresh: true,
                );
              }
            }
          });
        } else if (!isServicesTab) {
          // Reset tracking when not on services tab
          _lastSelectedBrowseType = homeState.selectedBrowseType;
          _lastCurrentIndex = homeState.currentIndex;
        }
        
        return BlocBuilder<ServiceCubit, ServiceState>(
          // Rebuild on any state change to ensure UI updates
          buildWhen: (previous, current) {
            final shouldRebuild = 
                previous.isLoading != current.isLoading ||
                previous.error != current.error ||
                previous.services.length != current.services.length ||
                previous.hasAttemptedLoad != current.hasAttemptedLoad ||
                previous.services != current.services; // Check list equality
            if (shouldRebuild) {
              print('🔄 ServicesSection BlocBuilder: Will rebuild (isLoading: ${current.isLoading}, services: ${current.services.length}, error: ${current.error})');
            }
            return shouldRebuild;
          },
          builder: (context, state) {
            print('🔄 ServicesSection BlocBuilder: Building UI (isLoading: ${state.isLoading}, services: ${state.services.length}, error: ${state.error})');
            
            // Priority 1: Show error if present (don't show loading if there's an error)
            if (state.error != null) {
              // Check if it's a location permission error
              if (state.error!.contains('location') || state.error!.contains('permission')) {
                // Show the permission widget from ServicesSectionWidget
                return const ServicesSectionWidget();
              }
              return ErrorSection(
                title: AppLocalizations.of(context)
                        ?.translate('nearbyCarServices') ??
                    'Nearby Car Services',
                message: state.error!,
              );
            }
            
            // Priority 2: Show services if we have them
            if (state.services.isNotEmpty) {
              print('✅ Showing services: ${state.services.length} services');
              return ServicesSection(services: state.services);
            }
            
            // Priority 3: Show loading if actively loading
            if (state.isLoading) {
              return LoadingSection(
                title: AppLocalizations.of(context)
                        ?.translate('nearbyCarServices') ??
                    'Nearby Car Services',
              );
            }
            
            // Priority 4: Default to loading if we haven't attempted to load yet
            if (!state.hasAttemptedLoad) {
              return LoadingSection(
                title: AppLocalizations.of(context)?.translate('nearbyCarServices') ??
                    'Nearby Car Services',
              );
            }
            
            // Priority 5: Show empty state if we've attempted to load but got no services
            return ServicesSection(services: []);
          },
        );
      },
    );
  }

  Widget _buildReelsSection(BuildContext context) {
    return BlocBuilder<ReelCubit, ReelState>(
      builder: (context, state) {
        if (state.isLoading) {
          return LoadingSection(
            title: AppLocalizations.of(context)?.translate('marketReels') ??
                'Market Reels',
          );
        }
        if (state.error != null) {
          return ErrorSection(
            title: AppLocalizations.of(context)?.translate('marketReels') ??
                'Market Reels',
            message: state.error!,
          );
        }
        if (state.reels.isNotEmpty) return ReelsSection(reels: state.reels);
        return LoadingSection(
          title: AppLocalizations.of(context)?.translate('marketReels') ??
              'Market Reels',
        );
      },
    );
  }
}
