import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/cars_available_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/products_section.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/services_section.dart';
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

class ContentSection extends StatelessWidget {
  const ContentSection({super.key});

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
    return BlocBuilder<ServiceCubit, ServiceState>(
      buildWhen: (previous, current) =>
          previous.isLoading != current.isLoading ||
          previous.error != current.error ||
          previous != current,
      builder: (context, state) {
        if (state.isLoading) {
          return LoadingSection(
            title: AppLocalizations.of(context)
                    ?.translate('nearbyCarServices') ??
                'Nearby Car Services',
          );
        }
        if (state.error != null) {
          return ErrorSection(
            title: AppLocalizations.of(context)
                    ?.translate('nearbyCarServices') ??
                'Nearby Car Services',
            message: state.error!,
          );
        }
        if (state.services.isNotEmpty) {
          return ServicesSection(services: state.services);
        }
        return LoadingSection(
          title: AppLocalizations.of(context)?.translate('nearbyCarServices') ??
              'Nearby Car Services',
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
