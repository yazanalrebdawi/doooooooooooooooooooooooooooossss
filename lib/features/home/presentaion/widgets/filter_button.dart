import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback? onTap;

  const FilterButton({
    Key? key, 
    required this.text, 
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.gray,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.s14w500.copyWith(
            color: isActive ? Colors.white : AppColors.gray,
          ),
        ),
      ),
    );
  }
} 