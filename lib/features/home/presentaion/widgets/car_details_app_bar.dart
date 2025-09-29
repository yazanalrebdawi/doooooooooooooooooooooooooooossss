import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class CarDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CarDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2C2C2C), // Dark grey header
      elevation: 0,
      title: Text(
        'Car Details',
        style: AppTextStyles.s16w500.copyWith(
          color: AppColors.white,
        ),
      ),
      centerTitle: false,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0), // Light grey circle
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        // Add any additional actions here if needed
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
