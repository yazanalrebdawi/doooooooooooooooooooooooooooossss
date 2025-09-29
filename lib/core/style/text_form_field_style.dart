import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldStyle {
  static InputDecoration baseForm(
    String label,
    BuildContext context, [
    TextStyle? style,
  ]) {
    return InputDecoration(
      hintStyle:
          style ?? TextStyle(fontSize: 14.sp, color: AppColors.borderBrand),
      hintText: AppLocalizations.of(context)?.translate(label) ?? "",
      contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      errorStyle: AppTextStyles.s12w400.copyWith(color: Colors.red),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.borderBrand),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.borderBrand),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primary, width: 2.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red, width: 2.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      ),
    );
  }
}
