import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class AppThemes {
  // #################### LIGHT THEME ####################
  static final ThemeData _lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      background: AppColors.white,
      onBackground: Colors.black, // default text color
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    cardTheme: const CardTheme(
      color: AppColors.primary,
      elevation: 3,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.s30w600.copyWith(color: Colors.black),
      headlineMedium: AppTextStyles.s30w600.copyWith(color: Colors.black),
      headlineSmall: AppTextStyles.s24w600.copyWith(color: Colors.black),
      bodyLarge: AppTextStyles.s18w600.copyWith(color: Colors.black),
      bodyMedium: AppTextStyles.s16w600.copyWith(color: Colors.black),
      bodySmall: AppTextStyles.s14w400.copyWith(color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.s16w400.copyWith(color: Colors.grey[700]),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.gray, width: 1),
        gapPadding: 0,
      ),
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primary),
    radioTheme: RadioThemeData(splashRadius: 26),
    switchTheme: const SwitchThemeData(),
  );

  // #################### DARK THEME ####################
  static final ThemeData _darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF1E1E1E).withAlpha(255),
    colorScheme: const ColorScheme.dark(
      background: AppColors.black,
      onBackground: Colors.white, // default text color
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    cardTheme: const CardTheme(
      color: AppColors.primary,
      elevation: 3,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E).withAlpha(255),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.s30w600.copyWith(color: Colors.white),
      headlineMedium: AppTextStyles.s30w600.copyWith(color: Colors.white),
      headlineSmall: AppTextStyles.s24w600.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.s18w600.copyWith(color: Colors.white),
      bodyMedium: AppTextStyles.s16w600.copyWith(color: Colors.white),
      bodySmall: AppTextStyles.s14w400.copyWith(color: Colors.white70),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.s16w400.copyWith(color: Colors.white70),
      filled: true,
      fillColor: AppColors.hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.gray, width: 1),
        gapPadding: 0,
      ),
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primary),
    radioTheme: RadioThemeData(splashRadius: 26),
    switchTheme: const SwitchThemeData(),
  );

  // #################### PIN THEME ####################
  static PinTheme pinTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return PinTheme(
        height: 63.h,
        width: 67.w,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0.r, color: AppColors.gray),
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
      );
    } else {
      return PinTheme(
        height: 60.h,
        width: 60.w,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary,
              blurRadius: 5,
              spreadRadius: 0.01,
            ),
          ],
        ),
      );
    }
  }

  static ThemeData get lightTheme => _lightTheme;
  static ThemeData get darkTheme => _darkTheme;
}
