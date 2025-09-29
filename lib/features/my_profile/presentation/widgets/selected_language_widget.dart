import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/models/enums/app_language_enum.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/language_option_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/preview_language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedLanguageWidget extends StatelessWidget {
  const SelectedLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainerBaseWidget(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          width: 358,
          height: 210,
          child: Column(
            children: [
              Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 9.12.h, left: 16.w),
                    child: Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xffecf4ee),
                          child: Icon(Icons.language, color: AppColors.primary),
                        ),
                        Column(
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
                      ],
                    ),
                  ),
                  Divider(color: AppColors.field, thickness: 1, height: 8.h),
                ],
              ),
              BlocSelector<AppManagerCubit, AppManagerState, Locale>(
                selector: (state) {
                  return state.locale;
                },
                builder: (context, state) {
                  final AppLanguageEnum appLanguage;
                  if (state == Locale("ar")) {
                    appLanguage = AppLanguageEnum.arabic;
                  } else {
                    appLanguage = AppLanguageEnum.english;
                  }
                  return LanguageOptionWidget(
                    selectedLanguage: appLanguage,
                    onChanged: (code) {
                      log("اخترت: $code");
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
              appLanguage = "Arabic";
            } else {
              log(context.read<AppManagerCubit>().state.lastApply.toString());
              appLanguage = "English";
            }
            return PreviewLanguageWidget(text: appLanguage);
          },
        ),
      ],
    );
  }
}
