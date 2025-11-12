import 'dart:developer';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/card_settings_widget.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/language_row_widget.dart';
import 'package:flutter/material.dart';

class PreferencesSettingsWidget extends StatelessWidget {
  const PreferencesSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardSettingsWidget(
      text: "Preferences",
      height: 114,
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
        ],
      ),
    );
  }
}
