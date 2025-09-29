import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ProductDescriptionSection extends StatelessWidget {
  final String description;

  const ProductDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTextStyles.s18w700.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description.isNotEmpty
                ? description
                : 'High-quality LED rear lights specifically designed for Nissan Sunny 2015 models. These lights provide enhanced visibility and safety while driving.',
            style: AppTextStyles.s14w400.copyWith(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 16.h),

          // What makes it special
          Text(
            'What makes it special:',
            style: AppTextStyles.s16w600.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Bright LED technology, waterproof design, and easy installation process.',
            style: AppTextStyles.s14w400.copyWith(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 16.h),

          // Installation
          Text(
            'Installation:',
            style: AppTextStyles.s16w600.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Direct replacement for original lights. No wiring modifications required.',
            style: AppTextStyles.s14w400.copyWith(
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 16.h),

          // Warranty
          Text(
            'Warranty:',
            style: AppTextStyles.s16w600.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '12 months manufacturer warranty included.',
            style: AppTextStyles.s14w400.copyWith(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
