import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
=======
import 'package:go_router/go_router.dart';
>>>>>>> zoz
import '../../../../core/constants/colors.dart';

class HomeActionsWidget extends StatelessWidget {
  const HomeActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : AppColors.gray;

=======
>>>>>>> zoz
    return Row(
      children: [
        // Notification Icon
        Stack(
          children: [
            Icon(
              Icons.notifications,
<<<<<<< HEAD
              color: iconColor,
=======
              color: AppColors.gray,
>>>>>>> zoz
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
<<<<<<< HEAD
          color: iconColor,
=======
          color: AppColors.gray,
>>>>>>> zoz
          size: 24.sp,
        ),
      ],
    );
  }
}
