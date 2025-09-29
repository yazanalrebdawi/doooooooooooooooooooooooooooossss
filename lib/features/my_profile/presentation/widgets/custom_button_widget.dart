import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtonWidget extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final IconData? icon;

  const CustomButtonWidget({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: const Color(0xFFE5E7EB), width: 1.w),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          spacing: icon != null ? 5.w : 0.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? Icon(icon, color: AppColors.buttonText) : SizedBox(),
            Flexible(
              child: Text(
                maxLines: 1,
                AppLocalizations.of(context)?.translate(text) ?? text,
                style:
                    textStyle ??
                    AppTextStyles.s16w500.copyWith(
                      color: AppColors.buttonText,
                      fontFamily: AppTextStyles.fontPoppins,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
