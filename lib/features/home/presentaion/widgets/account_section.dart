import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 64.sp,
              color: isDark ? Colors.white : AppColors.gray,
            ),
            SizedBox(height: 16.h),
            Text(
              'Account',
              style: AppTextStyles.blackS18W700.withThemeColor(context),
            ),
            SizedBox(height: 8.h),
            Text(
              'Profile settings',
              style: AppTextStyles.s16w400.copyWith(
                color: isDark ? Colors.white70 : AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
