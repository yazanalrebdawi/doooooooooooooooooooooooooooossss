import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class FilterButtonWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final IconData icon;
  final VoidCallback? onTap;

  const FilterButtonWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isSelected
        ? AppColors.primary
        : isDark
            ? Colors.grey[800]
            : AppColors.gray.withOpacity(0.1);
    final iconColor = isSelected
        ? AppColors.white
        : isDark
            ? Colors.grey[400]
            : AppColors.gray;
    final textColor = iconColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: iconColor,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: AppTextStyles.s12w400.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
