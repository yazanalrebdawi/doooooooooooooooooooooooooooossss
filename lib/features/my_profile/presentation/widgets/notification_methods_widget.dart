import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/row_with_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationMethodsWidget extends StatelessWidget {
  const NotificationMethodsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBaseWidget(
      height: 203,
      width: 358,
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.12.w, vertical: 13.h),
            child: Text(
              AppLocalizations.of(context)?.translate("Notification Methods") ??
                  "Notification Methods",
              style: AppTextStyles.s16w500.copyWith(color: Color(0xff111827)),
            ),
          ),
          RowWithSwitchWidget(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
            iconBackgroundColor: const Color(0xffEFF6FF),
            iconColor: Color(0xff3B82F6),
            iconData: Icons.phone_android,
            topRightText: "Push Notifications",
            bottomRightText: "Receive notifications on your device",
          ),
          Divider(color: AppColors.field, thickness: 1, height: 9.h),
          RowWithSwitchWidget(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
            iconBackgroundColor: const Color(0xffFEF2F2),
            iconColor: Color(0xffEF4444),
            iconData: Icons.email,
            topRightText: "Email Notifications",
            bottomRightText: "Receive notifications via email",
          ),
        ],
      ),
    );
  }
}
