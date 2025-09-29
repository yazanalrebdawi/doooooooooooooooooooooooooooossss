import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/row_with_switch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationTypesWidget extends StatelessWidget {
  const NotificationTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBaseWidget(
      height: 330,
      width: 358,
      padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.12.h),
            child: Text(
              AppLocalizations.of(context)?.translate("Notification Types") ??
                  "Notification Types",
              style: AppTextStyles.s16w500.copyWith(color: Color(0xff111827)),
            ),
          ),
          RowWithSwitchWidget(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 18.h),
            iconBackgroundColor: const Color(0xffEFF6FF),
            iconColor: Color(0xff3B82F6),
            iconData: Icons.messenger,
            topRightText: "New Messages",
            bottomRightText: "Get notified when you receive new\nmessages",
          ),
          Divider(color: AppColors.field, thickness: 1, height: 9.h),
          RowWithSwitchWidget(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 18.h),
            iconBackgroundColor: const Color(0xffFFF7ED),
            iconColor: Color(0xffF97316),
            iconData: Icons.sell,
            topRightText: "Promotions",
            bottomRightText: "Special offers and promotional content",
          ),
          Divider(color: AppColors.field, thickness: 1, height: 9.h),
          RowWithSwitchWidget(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 18.h),
            iconBackgroundColor: const Color(0xffFAF5FF),
            iconColor: Color(0xffA855F7),
            iconData: Icons.directions_car,
            topRightText: "Listing Updates",
            bottomRightText: "Updates on your car listings and inquiries",
          ),
        ],
      ),
    );
  }
}
