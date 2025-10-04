import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';

class CustomButtonWithIcon extends StatelessWidget {
  const CustomButtonWithIcon({
    super.key,
    required this.type,
    required this.iconButton,
    required this.ontap,
  });
  final String type;
  final IconData iconButton;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Container(
    
        width: 358.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconButton, color: Colors.white, size: 20),
            SizedBox(width: 4.w),
            Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
