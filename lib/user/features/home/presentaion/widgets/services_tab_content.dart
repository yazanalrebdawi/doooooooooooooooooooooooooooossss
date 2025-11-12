import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart'
    as di;
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
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoaded && mounted) {
        _hasLoaded = true;
        final cubit = context.read<ServiceCubit>();
        // Only load if we don't already have services (avoid unnecessary reload)
        if (cubit.state.services.isEmpty) {
          // Load services with type='station', will fallback to all services if none found
          cubit.loadServices(
            limit: 10,
            type: 'station',
            radius: 5000,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ServicesSectionWidget();
  }
}
