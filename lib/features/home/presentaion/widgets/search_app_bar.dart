import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchPressed;

  const SearchAppBar({
    super.key,
    required this.title,
    this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.black),
=======
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black),
>>>>>>> zoz
        onPressed: () => context.pop(),
      ),
      title: Text(
        title,
<<<<<<< HEAD
        style: AppTextStyles.s18w700.copyWith(
          color: isDark ? Colors.white : AppColors.black,
        ),
=======
        style: AppTextStyles.s18w700.copyWith(color: AppColors.black),
>>>>>>> zoz
      ),
      centerTitle: true,
      actions: [
        IconButton(
<<<<<<< HEAD
          icon: Icon(Icons.search, color: isDark ? Colors.white : AppColors.black),
          onPressed: onSearchPressed ?? () {
=======
          icon: Icon(Icons.search, color: AppColors.black),
          onPressed: onSearchPressed ?? () {
            
>>>>>>> zoz
            print('Search pressed');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
