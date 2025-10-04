import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final int value;
  final bool warning;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 173.w,
      height: 115.h,
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
      padding: EdgeInsets.only(left: 16.w, top: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, width: 0.1),
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(29, 0, 0, 0),
            blurRadius: 2.r,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon),
              // Icon
              //   icon,
              //   color: warning ? Colors.red : Colors.green,
              //   size: 26.r,
              // ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          SizedBox(height: 5.h),
          Text('$value', style: AppTextStyle.Poppins718),
        ],
      ),
    );
  }
}
