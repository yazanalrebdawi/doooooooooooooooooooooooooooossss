import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class PromotionalBanner extends StatelessWidget {
  const PromotionalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.startGradient,
            AppColors.endGradient,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Image Placeholder
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 100.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Icon(
                Icons.directions_car,
                size: 40.sp,
                color: AppColors.white.withOpacity(0.3),
              ),
            ),
          ),
          
          // Text Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get the best value for your car',
                  style: AppTextStyles.whiteS18W700,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Explore Now',
                    style: AppTextStyles.s12w400.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
