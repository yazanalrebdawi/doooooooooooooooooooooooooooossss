import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class StatItemWidget extends StatelessWidget {
  final String label;
  final String value;

  const StatItemWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final valueColor = isDark ? AppColors.white : AppColors.black;
    final labelColor = isDark ? AppColors.gray : AppColors.gray;

    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.s18w700.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.s14w400.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
