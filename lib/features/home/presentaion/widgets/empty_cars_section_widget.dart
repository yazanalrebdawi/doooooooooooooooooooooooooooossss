import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class EmptyCarsSectionWidget extends StatelessWidget {
  const EmptyCarsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(
            Icons.directions_car_outlined,
<<<<<<< HEAD
            color: isDark ? Colors.white54 : AppColors.gray,
=======
            color: AppColors.gray,
>>>>>>> zoz
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No cars available',
<<<<<<< HEAD
            style: AppTextStyles.blackS16W600.withThemeColor(context)
            
=======
            style: AppTextStyles.blackS16W600,
>>>>>>> zoz
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new listings',
<<<<<<< HEAD
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: isDark ? Colors.white70 : AppColors.gray,
            ),
=======
            style: AppTextStyles.secondaryS14W400,
>>>>>>> zoz
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
