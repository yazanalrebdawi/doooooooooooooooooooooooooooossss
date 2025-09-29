import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ProductDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
=======
    return AppBar(
      backgroundColor: const Color(0xFF2C2C2C), // Dark grey header
>>>>>>> zoz
      elevation: 0,
      title: Text(
        'Product Details',
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
          color: isDark ? AppColors.gray.withOpacity(0.2) : AppColors.white,
=======
          color: const Color(0xFFE0E0E0), // Light grey circle
>>>>>>> zoz
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
<<<<<<< HEAD
            color: isDark ? AppColors.white : AppColors.black,
=======
            color: AppColors.black,
>>>>>>> zoz
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.favorite_border,
<<<<<<< HEAD
            color: isDark ? AppColors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: () {
=======
            color: AppColors.white,
            size: 24.sp,
          ),
          onPressed: () {
            
>>>>>>> zoz
            print('Add to favorites');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.share,
<<<<<<< HEAD
            color: isDark ? AppColors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: () {
=======
            color: AppColors.white,
            size: 24.sp,
          ),
          onPressed: () {
            
>>>>>>> zoz
            print('Share product');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
