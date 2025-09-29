import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class EmptyCarsSectionWidget extends StatelessWidget {
  const EmptyCarsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(
            Icons.directions_car_outlined,
            color: AppColors.gray,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No cars available',
            style: AppTextStyles.blackS16W600,
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new listings',
            style: AppTextStyles.secondaryS14W400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
