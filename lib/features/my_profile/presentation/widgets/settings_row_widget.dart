import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsRowWidget extends StatelessWidget {
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData iconData;
  final String text;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool? isWidgetLogOut;

  const SettingsRowWidget({
    super.key,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.iconData,
    required this.text,
    this.onTap,
    this.trailing,
    this.isWidgetLogOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        splashColor: Colors.black.withOpacity(0.05),
        highlightColor: Colors.black.withOpacity(0.02),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: 358.w,
          height: 65.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(child: Icon(iconData, color: iconColor)),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    AppLocalizations.of(context)?.translate(text) ?? text,
                    style: AppTextStyles.s14w400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color:
                          isWidgetLogOut == true
                              ? Color(0xffDC2626)
                              : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              trailing ?? SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
