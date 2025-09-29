import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../manager/dealer_profile_cubit.dart';
import '../manager/dealer_profile_state.dart';

class DealerProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String dealerHandle;

  const DealerProfileAppBar({
    super.key,
    required this.dealerHandle,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DealerProfileCubit, DealerProfileState>(
      builder: (context, state) {
        final dealerName = state.dealer?.name ?? dealerHandle;

        return AppBar(
          backgroundColor: isDark ? Colors.black : AppColors.white,
=======
    return BlocBuilder<DealerProfileCubit, DealerProfileState>(
      builder: (context, state) {
        final dealerName = state.dealer?.name ?? dealerHandle;
        
        return AppBar(
          backgroundColor: AppColors.white,
>>>>>>> zoz
          elevation: 0,
          title: Text(
            dealerName,
            style: AppTextStyles.s16w600.copyWith(
<<<<<<< HEAD
              color: isDark ? Colors.white : AppColors.black,
=======
              color: AppColors.black,
>>>>>>> zoz
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
<<<<<<< HEAD
              color: isDark ? Colors.white : AppColors.primary,
=======
              color: AppColors.primary,
>>>>>>> zoz
              size: 24.sp,
            ),
            onPressed: () {
              // العودة للريلز بدلاً من pop العادي
              context.go(RouteNames.reelsScreen);
            },
          ),
          actions: const [],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
