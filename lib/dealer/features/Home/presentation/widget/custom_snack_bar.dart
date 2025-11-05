
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnakeBar extends StatelessWidget {
  const CustomSnakeBar({super.key, required this.text, this.isFailure = false});
  final String text;
  final bool? isFailure;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      width: 358.w,
      // height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: isFailure == true ? AppColors.red : Color(0xff22C55E),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(33, 0, 0, 0),
            blurRadius: 15.r,
            offset: Offset(0, 15.w),
          ),
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, 6.w),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            isFailure == true
                ? Icon(Icons.error, color: Colors.white, size: 20.r)
                : Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
            SizedBox(width: 8.w),
            SizedBox(
              width: 250.w,
              child: Text(
                text,
                style: AppTextStyle.poppins416white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
