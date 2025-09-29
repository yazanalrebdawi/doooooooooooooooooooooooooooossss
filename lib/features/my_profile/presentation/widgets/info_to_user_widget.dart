import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoToUserWidget extends StatelessWidget {
  const InfoToUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      height: 102.h,
      margin: EdgeInsets.only(top: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10).r,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            spacing: 10.w,
            children: [
              Align(
                alignment: AlignmentGeometry.topCenter,
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Color(0xff2563EB),
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.buttonText,
                    size: 20.sp,
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.start,
                AppLocalizations.of(context)?.translate("Language Change") ??
                    "Language Change",
                style: AppTextStyles.s16w500.copyWith(color: Color(0xff1E3A8A)),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                AppLocalizations.of(context)?.translate(
                      "The app may need to restart to fully apply the new language settings.",
                    ) ??
                    "The app may need to restart to fully apply the new language settings.",
                style: AppTextStyles.s14w400.copyWith(color: Color(0xff1D4ED8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
