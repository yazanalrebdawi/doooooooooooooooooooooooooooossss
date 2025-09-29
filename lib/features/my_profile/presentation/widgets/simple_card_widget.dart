import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleCardWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color squareBorderColor;
  final Color longLineColor;
  final Color shortLineColor;
  final Color moreIconColor;
  const SimpleCardWidget({
    super.key,
    this.backgroundColor = const Color(0xFFF9FAFB),
    this.squareBorderColor = const Color(0xFFE5E7EB),
    this.longLineColor = const Color(0xFFD1D5DB),
    this.shortLineColor = const Color(0xFFE5E7EB),
    this.moreIconColor = const Color(0xFFD1D5DB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 322.w,
      height: 80.h,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5.w),
      ),
      child: Column(
        spacing: 5.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 24.0.w,
                height: 24.0.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.0.r),
                  border: Border.all(color: squareBorderColor),
                ),
              ),
              Icon(Icons.more_horiz, color: moreIconColor, size: 26.sp),
            ],
          ),
          Container(
            width: 223.5.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: longLineColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Container(
            width: 149.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: shortLineColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
