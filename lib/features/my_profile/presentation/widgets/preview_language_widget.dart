import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewLanguageWidget extends StatelessWidget {
  const PreviewLanguageWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      width: 358.w,
      height: 166.h,
      padding: EdgeInsets.all(15).r,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10.w,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xffEFF6FF),
                child: Icon(
                  Icons.remove_red_eye_rounded,
                  color: Color(0xff2563EB),
                ),
              ),
              Text(
                AppLocalizations.of(context)?.translate("Preview") ?? "Preview",
                style: AppTextStyles.s16w600.copyWith(color: Color(0xff111827)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 30.h),
            child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  AppLocalizations.of(
                        context,
                      )?.translate("App interface will appear in:") ??
                      "App interface will appear in:",
                  style: AppTextStyles.s14w400.copyWith(
                    color: Color(0xff4B5563),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.translate(text) ?? text,
                  style: AppTextStyles.s16w500.copyWith(
                    color: Color(0xff111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
