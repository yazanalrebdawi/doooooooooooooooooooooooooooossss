import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class EmptyCarsSectionWidget extends StatelessWidget {
  const EmptyCarsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(
            Icons.directions_car_outlined,
            color: isDark ? Colors.white54 : AppColors.gray,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No cars available',
            style: AppTextStyles.blackS16W600.withThemeColor(context)
            
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new listings',
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: isDark ? Colors.white70 : AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
