// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pinput/pinput.dart';
// import '../constants/colors.dart';
// import '../constants/text_styles.dart';

// class AppThemes {
//   static final ThemeData _lightTheme = ThemeData.light().copyWith(
//     cardTheme: const CardThemeData(
//       color: AppColors.primary,
//       elevation: 3,
//       shadowColor: Colors.grey,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//       ),
//     ),
//     // ############ Scaffold Theme ###################
//     scaffoldBackgroundColor: AppColors.white,
//     textSelectionTheme: const TextSelectionThemeData(
//       cursorColor: AppColors.primary,
//     ),
//     appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
//     radioTheme: RadioThemeData(splashRadius: 26),

//     switchTheme: const SwitchThemeData(),
//     // ############ Field Theme ###################
//     inputDecorationTheme: InputDecorationTheme(
//       hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
//       filled: true,
//       fillColor: AppColors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12.r),
//         borderSide: const BorderSide(color: AppColors.gray, width: 1),
//         gapPadding: 0,
//       ),
//     ),

//     // ############ Circler Indecator ###################
//     progressIndicatorTheme: const ProgressIndicatorThemeData(
//       color: AppColors.primary,
//     ),
//     // ############ Field Theme ###################
//   );

//   static PinTheme pinTheme(BuildContext context) {
//     if (Theme.of(context).brightness == Brightness.light) {
//       return PinTheme(
//         height: 63.h,
//         width: 67.w,
//         textStyle: AppTextStyles.primaryS16W600,
//         decoration: BoxDecoration(
//           border: Border.all(width: 1.0.r, color: AppColors.gray),
//           color: AppColors.white,
//           borderRadius: BorderRadius.all(Radius.circular(10.r)),
//         ),
//       );
//     } else {
//       return PinTheme(
//         height: 60,
//         width: 60,
//         textStyle: AppTextStyles.whiteS22W700,
//         decoration: const BoxDecoration(
//           color: AppColors.primary,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.secondary,
//               blurRadius: 5,
//               spreadRadius: 0.01,
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   static ThemeData get lightTheme => _lightTheme;
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class AppThemes {
  // ###################### Light Theme ######################
  static final ThemeData _lightTheme = ThemeData.light().copyWith(
    cardTheme: CardThemeData(
      color: AppColors.primary,
      elevation: 3,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    scaffoldBackgroundColor: AppColors.white,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    radioTheme: RadioThemeData(splashRadius: 26),
    switchTheme: const SwitchThemeData(),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.gray, width: 1),
        gapPadding: 0,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
  );

  // ###################### Dark Theme ######################
  static final ThemeData _darkTheme = ThemeData.dark().copyWith(
    cardTheme: CardThemeData(
      color: Color(0xFF1E1E1E),
      elevation: 3,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    radioTheme: RadioThemeData(splashRadius: 26),
    switchTheme: const SwitchThemeData(),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.hintTextStyleWhiteS20W400.copyWith(
        color: Colors.grey[400],
      ),
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
        gapPadding: 0,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
  );

  // ###################### Pin Theme ######################
  static PinTheme pinTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return PinTheme(
        height: 63.h,
        width: 67.w,
        textStyle: AppTextStyles.primaryS16W600,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0.r, color: AppColors.gray),
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
      );
    } else {
      return PinTheme(
        height: 60,
        width: 60,
        textStyle: AppTextStyles.whiteS22W700,
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

  // ###################### Getters ######################
  static ThemeData get lightTheme => _lightTheme;
  static ThemeData get darkTheme => _darkTheme;
}
