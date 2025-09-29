import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_smooth_tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarProfileWidget(title: "Saved Items"),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () {
          return context.read<MyProfileCubit>().getFavorites();
        },
        child: const CustomSmoothTabBarWidget(),
      ),
    );
  }
}
