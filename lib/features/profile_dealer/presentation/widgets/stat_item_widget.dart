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
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.s18w700.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.s14w400.copyWith(
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
