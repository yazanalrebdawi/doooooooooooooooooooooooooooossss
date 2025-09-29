import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardSettingsWidget extends StatelessWidget {
  final Widget? widget;
  final String text;
  final double height;

  const CardSettingsWidget({
    super.key,
    this.widget,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      width: 358.w,
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8.r,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(2, 0),
            blurRadius: 4.r,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(-2, 0),
            blurRadius: 4.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Column(
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 9.12.h, left: 16.w),
                child: Text(
                  AppLocalizations.of(context)?.translate(text) ?? text,
                  style: AppTextStyles.s16w500.copyWith(
                    fontFamily: AppTextStyles.fontPoppins,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Divider(color: AppColors.field, thickness: 1, height: 8.h),
            ],
          ),

          widget ?? SizedBox(),
        ],
      ),
    );
  }
}
