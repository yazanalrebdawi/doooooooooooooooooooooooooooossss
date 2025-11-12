import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen to locale changes to rebuild when language changes
    return BlocBuilder<AppManagerCubit, AppManagerState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (context, state) {
        return _buildNavigation(context, isDark);
      },
    );
  }

  Widget _buildNavigation(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home,
                  AppLocalizations.of(context)?.translate('Home') ?? 'Home'),
              _buildNavItem(
                  context,
                  1,
                  Icons.build,
                  AppLocalizations.of(context)?.translate('Services') ??
                      'Services'),
              _buildNavItem(context, 2, Icons.play_circle_outline,
                  AppLocalizations.of(context)?.translate('Reels') ?? 'Reels'),
              _buildNavItem(
                  context,
                  3,
                  Icons.chat_bubble_outline,
                  AppLocalizations.of(context)?.translate('Messages') ??
                      'Messages'),
              _buildNavItem(
                  context,
                  4,
                  Icons.person_outline,
                  AppLocalizations.of(context)?.translate('Account') ??
                      'Account'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? AppColors.primary
        : (isDark ? Colors.white : AppColors.gray);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 4.h),
          Text(label, style: AppTextStyles.s12w400.copyWith(color: color)),
        ],
      ),
    );
  }
}
