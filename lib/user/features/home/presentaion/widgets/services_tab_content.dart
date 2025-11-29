import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart'
    as di;
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_state.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/service_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/services_section_widget.dart';

class ServicesTabContent extends StatelessWidget {
  const ServicesTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceCubit>(
      create: (context) => di.appLocator<ServiceCubit>(),
      child: const ServicesTabDataLoader(),
    );
  }
}

class ServicesTabDataLoader extends StatefulWidget {
  const ServicesTabDataLoader({super.key});

  @override
  State<ServicesTabDataLoader> createState() => _ServicesTabDataLoaderState();
}

class _ServicesTabDataLoaderState extends State<ServicesTabDataLoader> {
  int? _lastTabIndex;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() async {
    // Longer delay to ensure permission state is fully synced between packages
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    
    final cubit = context.read<ServiceCubit>();
    
    // Load services with type='station', will fallback to all services if none found
    // Use forceRefresh to ensure permission check syncs between Geolocator and location packages
    // Always force refresh when tab is selected to ensure fresh permission check with retries
    cubit.loadServices(
      limit: 10,
      type: 'station',
      radius: 5000,
      forceRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to HomeCubit to detect when services tab (index 1) is selected
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, homeState) {
        final currentIndex = homeState.currentIndex;
        
        // If services tab (index 1) is selected and it's different from last time
        if (currentIndex == 1 && _lastTabIndex != 1) {
          _lastTabIndex = 1;
          // Don't clear error here - let loadServices handle it
          // Reload services when tab becomes active - use post frame callback to ensure state is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              print('🔄 ServicesTab: Tab selected, reloading services...');
              _loadServices();
            }
          });
        } else if (currentIndex != 1) {
          _lastTabIndex = currentIndex;
        }
        
        return const ServicesSectionWidget();
      },
    );
  }
}
