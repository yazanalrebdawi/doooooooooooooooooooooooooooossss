import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';

class HomeActionsWidget extends StatelessWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Notification Icon
        Stack(
          children: [
            Icon(
              Icons.notifications,
              color: AppColors.gray,
              size: 24.sp,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 16.w),
        // Search Icon
        Icon(
          Icons.search,
          color: AppColors.gray,
          size: 24.sp,
        ),
      ],
    );
  }
}
