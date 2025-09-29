import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class CarSpecItemWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const CarSpecItemWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Row(
      children: [
        Icon(
          icon,
<<<<<<< HEAD
          color: isDark ? Colors.white70 : AppColors.gray,
=======
          color: AppColors.gray,
>>>>>>> zoz
          size: 14.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
<<<<<<< HEAD
          style: AppTextStyles.secondaryS12W400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
=======
          style: AppTextStyles.secondaryS12W400,
>>>>>>> zoz
        ),
      ],
    );
  }
}
