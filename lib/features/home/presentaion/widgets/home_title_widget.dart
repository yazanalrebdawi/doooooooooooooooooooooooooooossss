import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class HomeTitleWidget extends StatelessWidget {
  const HomeTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.car_repair, color: AppColors.white,),
        ),
        SizedBox(width: 8.w),
        Text(
          'Dooss',
          style: AppTextStyles.s16w600.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
