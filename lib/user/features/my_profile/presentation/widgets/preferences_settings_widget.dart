import 'dart:developer';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/card_settings_widget.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/language_row_widget.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PreferencesSettingsWidget extends StatelessWidget {
  const PreferencesSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CardSettingsWidget(
      text: "Preferences",
      height: 179, // Updated height to accommodate both language and privacy policy
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LanguageRowWidget(
            iconBackgroundColor: Color(0xffF3E8FF),
            iconColor: Color(0xff9333EA),
            iconData: Icons.language,
            text: AppLocalizations.of(context)?.translate('language') ??
                'Language',
            onLanguageChanged: (String value) {
              log(value);
            },
          ),
          SettingsRowWidget(
            iconBackgroundColor: isDark ? Color(0xff1E3A5F) : Color(0xffDBEAFE),
            iconColor: isDark ? Color(0xff60A5FA) : Color(0xff2563EB),
            iconData: Icons.privacy_tip,
            text: "privacyPolicy",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: isDark ? Colors.grey[400] : Color(0xff9CA3AF),
            ),
            onTap: () {
              context.push(RouteNames.privacyPolicy);
            },
          ),
        ],
      ),
    );
  }
}
