import 'dart:developer';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/models/enums/app_language_enum.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/language_option_widget.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/preview_language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedLanguageWidget extends StatelessWidget {
  const SelectedLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive width: 90% of screen width with min 300 and max 358
    final responsiveWidth = (screenWidth * 0.9).clamp(300, 358).toDouble();
    // Calculate responsive height: 50% of screen height with min 350 and max 450
    final responsiveHeight = (screenHeight * 0.5).clamp(350, 450).toDouble();

    return Column(
      children: [
        ContainerBaseWidget(
          margin: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
          width: responsiveWidth,
          height: responsiveHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 24.h, left: 20.w, right: 20.w, bottom: 16.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Color(0xffecf4ee),
                      child: Icon(Icons.language,
                          color: AppColors.primary, size: 24.r),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                                  context,
                                )?.translate("Select Language") ??
                                "Select Language",
                            style: AppTextStyles.s16w600.copyWith(
                              color: Color(0xff111827),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            AppLocalizations.of(context)?.translate(
                                  "Choose your preferred language",
                                ) ??
                                "Choose your preferred language",
                            style: AppTextStyles.s14w400.copyWith(
                              color: AppColors.rating,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.field, thickness: 1.h, height: 4.h),
              BlocSelector<AppManagerCubit, AppManagerState, Locale>(
                selector: (state) {
                  return state.locale;
                },
                builder: (context, state) {
                  final AppLanguageEnum appLanguage;
                  if (state == const Locale("ar")) {
                    appLanguage = AppLanguageEnum.arabic;
                  } else if (state == const Locale("tr")) {
                    appLanguage = AppLanguageEnum.turkish;
                  } else {
                    appLanguage = AppLanguageEnum.english;
                  }
                  return LanguageOptionWidget(
                    selectedLanguage: appLanguage,
                    onChanged: (code) {
                      log("Selected: $code");
                      context.read<AppManagerCubit>().saveChanegTemp(code);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        BlocSelector<AppManagerCubit, AppManagerState, Locale>(
          selector: (state) => state.locale,
          builder: (context, locale) {
            final String appLanguage;
            if (locale.languageCode == "ar") {
              log(context.read<AppManagerCubit>().state.lastApply.toString());
              appLanguage =
                  AppLocalizations.of(context)?.translate("Arabic") ?? "Arabic";
            } else if (locale.languageCode == "tr") {
              log(context.read<AppManagerCubit>().state.lastApply.toString());
              appLanguage =
                  AppLocalizations.of(context)?.translate("Turkish") ??
                      "Turkish";
            } else {
              log(context.read<AppManagerCubit>().state.lastApply.toString());
              appLanguage =
                  AppLocalizations.of(context)?.translate("English") ??
                      "English";
            }
            return PreviewLanguageWidget(text: appLanguage);
          },
        ),
      ],
    );
  }
}
