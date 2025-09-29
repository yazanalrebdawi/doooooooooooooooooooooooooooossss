import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class SearchBarHomeScreen extends StatelessWidget {
  const SearchBarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.gray.withOpacity(0.2) : AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? AppColors.primary : AppColors.primary,
        ),
        suffixIcon: Icon(
          Icons.tune,
          color: isDark ? Colors.white70 : Color(0xff6B7280),
        ),
        hintText: 'Search by brand,model,or price',
        hintStyle: AppTextStyles.hintTextStyleWhiteS16W400.copyWith(
          color: isDark ? Colors.white70 : AppTextStyles.hintTextStyleWhiteS16W400.color,
        ),
      ),
    );
  }
}
