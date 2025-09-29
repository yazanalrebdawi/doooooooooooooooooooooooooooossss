import 'dart:developer';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/card_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportSettingsWidget extends StatelessWidget {
  const SupportSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardSettingsWidget(
      height: 179,
      text: "Support",
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsRowWidget(
            iconBackgroundColor: Color(0xffCFFAFE),
            iconColor: Color(0xff0891B2),
            iconData: Icons.help,
            text: "Help Center",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: Color(0xff9CA3AF),
            ),
            onTap: () {
              log('Help Center tapped');
            },
          ),
          SettingsRowWidget(
            iconBackgroundColor: Color(0xffCCFBF1),
            iconColor: Color(0xff0D9488),
            iconData: Icons.support_agent    ,
            text: "Contact Support",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: Color(0xff9CA3AF),
            ),
            onTap: () {
              log('Contact Support');
            },
          ),
        ],
      ),
    );
  }
}
