import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class SearchBarHomeScreen extends StatelessWidget {
  const SearchBarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.primary),
        suffixIcon: Icon(Icons.tune, color: Color(0xff6B7280)),
        hintText: 'Search by brand,model,or price',
        hintStyle: AppTextStyles.hintTextStyleWhiteS16W400,
      ),
    );
  }
}
