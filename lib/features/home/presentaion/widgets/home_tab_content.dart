import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/services/locator_service.dart' as di;
import 'package:dooss_business_app/features/home/presentaion/manager/car_cubit.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/home_tab_car_provider.dart';

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CarCubit>(
      create: (_) => di.appLocator<CarCubit>(),
      child: const HomeTabCarProvider(),
    );
  }
}
