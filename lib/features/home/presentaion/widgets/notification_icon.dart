<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
=======
// في ملف منفصل مثل notification_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
>>>>>>> zoz

class NotificationIcon extends StatelessWidget {
  final int? count;
  final VoidCallback? onPressed;
  final Color? badgeColor;

  const NotificationIcon({
    Key? key,
    this.count,
    this.onPressed,
<<<<<<< HEAD
    this.badgeColor,
=======
    this.badgeColor = Colors.red,
>>>>>>> zoz
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
<<<<<<< HEAD
            Icons.notifications_none,
            size: 30.sp,
=======
            size: 30,
            Icons.notifications_none,
>>>>>>> zoz
            color: AppColors.primary,
          ),
          onPressed: onPressed,
        ),
        if (count != null && count! > 0)
          Positioned(
<<<<<<< HEAD
            right: 6.w,
            top: 6.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 1.5,
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 16.w,
                minHeight: 16.h,
              ),
              child: Center(
                child: Text(
                  count! > 9 ? '9+' : count.toString(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
=======
            right: 10,
            top: 7,
            child: Container(
              // padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                // border: Border.all(
                //   color: Colors.white,
                //   width: 1.5,
                // ),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count! > 9 ? '9+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
>>>>>>> zoz
              ),
            ),
          ),
      ],
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> zoz
