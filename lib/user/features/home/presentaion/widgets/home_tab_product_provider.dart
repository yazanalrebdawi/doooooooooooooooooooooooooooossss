import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart' as di;
import 'package:dooss_business_app/user/features/home/presentaion/manager/service_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/home_tab_service_provider.dart';

class HomeTabProductProvider extends StatelessWidget {
  const HomeTabProductProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceCubit>(
      create: (_) => di.appLocator<ServiceCubit>(),
      child: const HomeTabServiceProvider(),
    );
  }
}
