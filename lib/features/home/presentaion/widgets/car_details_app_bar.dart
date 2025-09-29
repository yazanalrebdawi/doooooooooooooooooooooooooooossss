import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class CarDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CarDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : AppColors.white,
=======
    return AppBar(
      backgroundColor: const Color(0xFF2C2C2C), // Dark grey header
>>>>>>> zoz
      elevation: 0,
      title: Text(
        'Car Details',
        style: AppTextStyles.s16w500.copyWith(
<<<<<<< HEAD
          color: isDark ? AppColors.white : AppColors.black,
=======
          color: AppColors.white,
>>>>>>> zoz
        ),
      ),
      centerTitle: false,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
<<<<<<< HEAD
          color: isDark ? Colors.white12 : const Color(0xFFE0E0E0),
=======
          color: const Color(0xFFE0E0E0), // Light grey circle
>>>>>>> zoz
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
<<<<<<< HEAD
            color: isDark ? Colors.white : AppColors.black,
=======
            color: AppColors.black,
>>>>>>> zoz
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
