import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ProductDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      elevation: 0,
      title: Text(
        'Product Details',
        style: AppTextStyles.s16w500.copyWith(
          color: isDark ? AppColors.white : AppColors.black,
        ),
      ),
      centerTitle: false,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray.withOpacity(0.2) : AppColors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.white : AppColors.black,
            size: 20.sp,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: isDark ? AppColors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: () {
            print('Add to favorites');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.share,
            color: isDark ? AppColors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: () {
            print('Share product');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
