import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ProductLocationSection extends StatelessWidget {
  final String location;

  const ProductLocationSection({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      color: isDark ? AppColors.darkCard : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: AppTextStyles.s18w700.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                location.isNotEmpty ? location : 'Sharjah, UAE',
                style: AppTextStyles.s14w400.copyWith(
                  color: isDark ? AppColors.gray.withOpacity(0.8) : AppColors.gray,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Map placeholder
          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard.withOpacity(0.5)
                  : AppColors.gray.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(
                Icons.map,
                color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
                size: 48.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
