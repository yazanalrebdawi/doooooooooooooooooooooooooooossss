import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class HomeTitleWidget extends StatelessWidget {
  const HomeTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
<<<<<<< HEAD
          child: Icon(
            Icons.car_repair,
            color: AppColors.white,
          ),
=======
          child: Icon(Icons.car_repair, color: AppColors.white,),
>>>>>>> zoz
        ),
        SizedBox(width: 8.w),
        Text(
          'Dooss',
<<<<<<< HEAD
          style: AppTextStyles.s16w600
              .copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.black, // theme-aware color
              ),
=======
          style: AppTextStyles.s16w600.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
>>>>>>> zoz
        ),
      ],
    );
  }
}
