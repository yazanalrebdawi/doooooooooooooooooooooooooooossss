import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/core/models/enums/app_them_enum.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/features/my_profile/presentation/pages/theme_settings_screen.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/card_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/language_row_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/settings_switch_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesSettingsWidget extends StatelessWidget {
  const PreferencesSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CardSettingsWidget(
      text: "Preferences",
      height: 243,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LanguageRowWidget(
            iconBackgroundColor: Color(0xffF3E8FF),
            iconColor: Color(0xff9333EA),
            iconData: Icons.language,
            text: "Language",
            onLanguageChanged: (String value) {
              log(value);
            },
          ),

          BlocSelector<AppManagerCubit, AppManagerState, bool>(
            selector: (state) {
              return state.tempThem;
            },
            builder: (context, state) {
              return SettingsSwitchRowWidget(
                iconBackgroundColor: Color(0xffFEF9C3),
                iconColor: Color(0xffCA8A04),
                iconData: Icons.color_lens,
                text: "Theme",
                initialValue: true,
                onChanged: (value) {
                  log('Theme switched to $value');
                  if (value == false) {
                    context.read<AppManagerCubit>().setTempTheme(false);
                    context.read<AppManagerCubit>().setTheme(
                      AppThemeEnum.light,
                    );
                    appLocator<SharedPreferencesService>().saveThemeModeInCache(
                      true,
                    );
                    log(
                      context
                          .read<AppManagerCubit>()
                          .state
                          .themeMode
                          .toString(),
                    );
                  } else {
                    context.read<AppManagerCubit>().setTempTheme(true);
                  }
                },
                onTapRow: () {
                  if (state) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemeSettingsScreen(),
                      ),
                    );
                  } else {
                    return;
                  }
                },
              );
            },
          ),
          SettingsSwitchRowWidget(
            switchEnabled: false,
            iconBackgroundColor: Color(0xffE0E7FF),
            iconColor: Color(0xff4F46E5),
            iconData: Icons.notifications,
            text: "Notifications",
            initialValue: true,
            onChanged: (value) {
              log('Notifications switched to $value');
            },
            onTapRow: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SettingsNotificationsScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
