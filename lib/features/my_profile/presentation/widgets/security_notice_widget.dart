import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/split_shield_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityNoticeWidget extends StatelessWidget {
  const SecurityNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      height: 102.h,
      padding: EdgeInsets.all(16.r),
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
                child: SplitShieldIconWidget(size: 25.w),
              ),
              Text(
                textAlign: TextAlign.start,
                AppLocalizations.of(context)?.translate("Security Notice") ??
                    "Security Notice",
                style: AppTextStyles.s16w500.copyWith(color: Color(0xff1E3A8A)),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 13.w, right: 13.w, top: 3.h),
              child: Text(
                AppLocalizations.of(context)?.translate(
                      'For your security, we recommend changin your password regularly.',
                    ) ??
                    'For your security, we recommend changin your password regularly.',
                style: AppTextStyles.s14w400.copyWith(color: Color(0xff1D4ED8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
