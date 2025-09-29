import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64.sp,
            color: AppColors.gray,
          ),
          SizedBox(height: 16.h),
          Text(
            'Account',
            style: AppTextStyles.blackS18W700,
          ),
          SizedBox(height: 8.h),
          Text(
            'Profile settings',
            style: AppTextStyles.s16w400.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}
