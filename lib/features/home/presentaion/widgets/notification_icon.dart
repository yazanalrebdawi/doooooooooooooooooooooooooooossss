// في ملف منفصل مثل notification_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class NotificationIcon extends StatelessWidget {
  final int? count;
  final VoidCallback? onPressed;
  final Color? badgeColor;

  const NotificationIcon({
    Key? key,
    this.count,
    this.onPressed,
    this.badgeColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            size: 30,
            Icons.notifications_none,
            color: AppColors.primary,
          ),
          onPressed: onPressed,
        ),
        if (count != null && count! > 0)
          Positioned(
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
              ),
            ),
          ),
      ],
    );
  }
}