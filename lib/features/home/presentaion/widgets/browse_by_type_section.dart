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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Browse by Type',
            style: AppTextStyles.blackS18W700,
          ),
        ),
        SizedBox(height: 16.h),
        // Type Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(child: _buildTypeButton('Cars', Icons.directions_car, 0)),
              SizedBox(width: 12.w),
              Expanded(child: _buildTypeButton('Products', Icons.shopping_bag, 1)),
              SizedBox(width: 12.w),
              Expanded(child: _buildTypeButton('Services', Icons.build, 2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(String title, IconData icon, int index) {
    final isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 84.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
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
              color: AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyles.s14w700.copyWith(
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 