import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart' as material;
import 'package:dooss_business_app/user/core/constants/text_styles.dart';

class TextFormFieldStyle {
  static InputDecoration baseForm(
    String label,
    BuildContext context, [
    material.TextStyle? style,
  ]) {
    final translatedLabel =
        AppLocalizations.of(context)?.translate(label) ?? "";

    return InputDecoration(
      hintText: translatedLabel,
      hintStyle:
          style ??
          material.TextStyle(fontSize: 14.sp, color: AppColors.borderBrand),
      contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      errorStyle: AppTextStyles.s12w400.copyWith(color: material.Colors.red),

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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: material.Colors.red, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: material.Colors.red, width: 2.w),
      ),
    );
  }
}
