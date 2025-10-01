import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart' as di;
import 'package:dooss_business_app/user/features/home/presentaion/manager/product_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/home_tab_product_provider.dart';

class HomeTabCarProvider extends StatelessWidget {
  const HomeTabCarProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductCubit>(
      create: (_) => di.appLocator<ProductCubit>(),
      child: const HomeTabProductProvider(),
    );
  }
}
