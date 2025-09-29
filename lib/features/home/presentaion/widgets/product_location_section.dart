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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      color: isDark ? AppColors.darkCard : Colors.transparent,
=======
    return Container(
      padding: EdgeInsets.all(16.w),
>>>>>>> zoz
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
<<<<<<< HEAD
            style: AppTextStyles.s18w700.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
=======
            style: AppTextStyles.s18w700,
>>>>>>> zoz
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
<<<<<<< HEAD
                style: AppTextStyles.s14w400.copyWith(
                  color: isDark ? AppColors.gray.withOpacity(0.8) : AppColors.gray,
                ),
=======
                style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Map placeholder
          Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
<<<<<<< HEAD
              color: isDark
                  ? AppColors.darkCard.withOpacity(0.5)
                  : AppColors.gray.withOpacity(0.1),
=======
              color: AppColors.gray.withOpacity(0.1),
>>>>>>> zoz
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(
                Icons.map,
<<<<<<< HEAD
                color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
=======
                color: AppColors.gray,
>>>>>>> zoz
                size: 48.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
