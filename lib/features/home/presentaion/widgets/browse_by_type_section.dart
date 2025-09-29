import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';

class BrowseByTypeSection extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BrowseByTypeSection({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Browse by Type',
            style: AppTextStyles.blackS18W700.withThemeColor(context),
          ),
        ),
        SizedBox(height: 16.h),
        // Type Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                  child: _buildTypeButton(
                      context, 'Cars', Icons.directions_car, 0, isDark)),
              SizedBox(width: 12.w),
              Expanded(
                  child: _buildTypeButton(
                      context, 'Products', Icons.shopping_bag, 1, isDark)),
              SizedBox(width: 12.w),
              Expanded(
                  child: _buildTypeButton(
                      context, 'Services', Icons.build, 2, isDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context, String title, IconData icon,
      int index, bool isDark) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 84.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : (isDark
                  ? const Color(0xFF2A2A2A)
                  : AppColors.primary.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : AppColors.primary),
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyles.s14w700.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white70 : AppColors.primary),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
