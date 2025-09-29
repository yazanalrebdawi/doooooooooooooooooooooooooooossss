import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

abstract class AppTextStyles {
  static const String _fontFamily = 'RobotoCondensedSemiBold';
  static const String fontPoppins = 'Poppins';

  // Base Styles
  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
  }) => TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
    fontFamily: _fontFamily,
    height: height,
  );

  // Regular Styles - Black
  static TextStyle get s12w400 => _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static TextStyle get s12w600 => _baseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get s14w400 => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle get s14w500 => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static TextStyle get s14w600 => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get s14w700 => _baseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get s16w400 => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle get s16w500 => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get s16w600 => _baseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get s18w500 => _baseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static TextStyle get s18w600 => _baseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get s18w700 => _baseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get s20w400 => _baseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static TextStyle get s20w700 => _baseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get s20w500 => _baseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get s21w600 => _baseStyle(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get s22w500 => _baseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get s22w700 => _baseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get s24w600 => _baseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle get s25w500 => _baseStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get s25w700 => _baseStyle(
    fontSize: 25,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static TextStyle get s30w600 => _baseStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Primary Color Styles
  static TextStyle get primaryS14W700 =>
      s14w700.copyWith(color: AppColors.primary);
  static TextStyle get primaryS14W400 =>
      s14w400.copyWith(color: AppColors.primary);
  static TextStyle get primaryS14W500 =>
      s14w500.copyWith(color: AppColors.primary);
  static TextStyle get primaryS16W500 =>
      s16w500.copyWith(color: AppColors.primary);
  static TextStyle get primaryS16W600 =>
      s16w600.copyWith(color: AppColors.primary);
  static TextStyle get primaryS16W700 =>
      s16w600.copyWith(color: AppColors.primary);

  // White Styles
  static TextStyle get whiteS16W400 => s16w400.copyWith(color: Colors.white);
  static TextStyle get whiteS16W600 => s16w600.copyWith(color: Colors.white);
  static TextStyle get whiteS18W600 => s18w600.copyWith(color: Colors.white);
  static TextStyle get whiteS18W700 => s18w700.copyWith(color: Colors.white);
  static TextStyle get whiteS22W700 => s22w700.copyWith(color: Colors.white);
  static TextStyle get whiteS12W400 => s12w400.copyWith(color: Colors.white);
  static TextStyle get whiteS12W600 => s12w600.copyWith(color: Colors.white);
  static TextStyle get whiteS14W600 => s14w600.copyWith(color: Colors.white);
  static TextStyle get whiteS14W400 => s14w400.copyWith(color: Colors.white);
  static TextStyle get whiteS32W700 => _baseStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // Rating Styles
  static TextStyle get ratingS12W400 =>
      s12w400.copyWith(color: AppColors.rating);
  static TextStyle get ratingS14W400 =>
      s14w400.copyWith(color: AppColors.rating);

  // Hint Styles
  static TextStyle get hintS16W400 =>
      s16w500.copyWith(color: AppColors.hint.withOpacity(0.5));
  static TextStyle get hintS20W400 =>
      s20w400.copyWith(color: AppColors.hint.withOpacity(0.5));

  // Description Styles with Opacity
  static TextStyle get descriptionS15W500 =>
      s14w500.copyWith(fontSize: 15.sp, color: Colors.black.withOpacity(0.3));
  static TextStyle get descriptionS18W500 =>
      s18w500.copyWith(color: Colors.black.withOpacity(0.3));
  static TextStyle get descriptionS18W400 =>
      s18w500.copyWith(color: Colors.black.withOpacity(0.3));
  static TextStyle get descriptionS14W400 =>
      s14w400.copyWith(color: Colors.black.withOpacity(0.3));

  // Secondary Text Styles
  static TextStyle get secondaryS12W400 =>
      s12w400.copyWith(color: AppColors.textSecondary);
  static TextStyle get secondaryS14W400 =>
      s14w400.copyWith(color: AppColors.textSecondary);

  // Button Text Styles
  static TextStyle get buttonS14W500 =>
      s14w500.copyWith(color: AppColors.buttonText);
  static TextStyle get buttonS16W600 =>
      s16w600.copyWith(color: AppColors.buttonText);
  static TextStyle get buttonTextStyleWhiteS22W700 =>
      s22w700.copyWith(color: Colors.white);
  static TextStyle get buttonTextStyleWhiteS18W700 =>
      s18w700.copyWith(color: Colors.white);

  // Hint Text Styles
  static TextStyle get hintTextStyleWhiteS20W400 =>
      s20w400.copyWith(color: AppColors.hint.withOpacity(0.5));
  static TextStyle get hintTextStyleWhiteS16W400 =>
      s16w400.copyWith(color: AppColors.hint.withOpacity(0.5));

  // App Bar and Header Styles
  static TextStyle get blackS14W700 => s14w700.copyWith(color: Colors.black);
  static TextStyle get blackS18W700 => s18w700.copyWith(color: Colors.black);
  static TextStyle get blackS21W600 => s21w600.copyWith(color: Colors.black);
  static TextStyle get blackS25W700 => s25w700.copyWith(color: Colors.black);
  static TextStyle get blackS25W500 => s25w500.copyWith(color: Colors.black);
  static TextStyle get blackS18W500 => s18w500.copyWith(color: Colors.black);
  static TextStyle get blackS16W600 => s16w600.copyWith(color: Colors.black);
  static TextStyle get blackS12W400 => s12w400.copyWith(color: Colors.black);
  static TextStyle get blackS12W600 => s12w600.copyWith(color: Colors.black);
  static TextStyle get blackS14W600 => s14w600.copyWith(color: Colors.black);
  static TextStyle get blackS14W500 => s14w500.copyWith(color: Colors.black);
  static TextStyle get blackS20W500 => s20w500.copyWith(color: Colors.black);
  static TextStyle get blackS24W600 => s24w600.copyWith(color: Colors.black);

  static TextStyle get grayS12W400 => s12w400.copyWith(color: AppColors.gray);
  static TextStyle get grayS14W400 => s14w400.copyWith(color: AppColors.gray);
  static TextStyle get grayS16W600 => s16w600.copyWith(color: AppColors.gray);

  static TextStyle get headLineBoardingBlackS25W700 =>
      s25w700.copyWith(color: Colors.black);
  static TextStyle get lableTextStyleBlackS22W500 =>
      s22w500.copyWith(color: Colors.black);
  static TextStyle get headLineBoardingBlackS22W700 =>
      s22w700.copyWith(color: Colors.black);
  static TextStyle get appBarTextStyleUserNameBlackS16W500 =>
      s16w500.copyWith(color: Colors.black);
  static TextStyle get headCategoriesTextStyleS16W500 =>
      s16w500.copyWith(color: AppColors.primary);
  static TextStyle get appBarTextStyleBlackS12W400 =>
      s12w400.copyWith(color: Colors.black);
  static TextStyle get headLineBlackS30W600 =>
      s30w600.copyWith(color: Colors.black);
}
