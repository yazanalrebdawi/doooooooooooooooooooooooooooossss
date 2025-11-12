import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/change_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageRowWidget extends StatelessWidget {
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData iconData;
  final String text;
  final double iconSize;

  final ValueChanged<String> onLanguageChanged;

  const LanguageRowWidget({
    super.key,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.iconData,
    required this.text,
    required this.onLanguageChanged,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChangeLanguageScreen()),
          );
        },
        splashColor: Colors.black.withOpacity(0.05),
        highlightColor: Colors.black.withOpacity(0.02),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          width: 358.w,
          height: 75.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Icon(iconData, color: iconColor, size: iconSize.r),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    AppLocalizations.of(context)?.translate(text) ?? text,
                    style: AppTextStyles.s14w400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  BlocSelector<AppManagerCubit, AppManagerState, Locale>(
                    selector: (state) {
                      return state.locale;
                    },
                    builder: (context, state) {
                      final Locale lang =
                          context.read<AppManagerCubit>().state.locale;
                      late final String text;

                      if (lang == const Locale("en")) {
                        text = "English";
                      } else if (lang == const Locale("tr")) {
                        text = "Turkish";
                      } else {
                        text = "Arabic";
                      }

                      return Text(
                        AppLocalizations.of(context)?.translate(text) ?? text,
                        style: AppTextStyles.s16w400.copyWith(
                          fontFamily: AppTextStyles.fontPoppins,
                          color: AppColors.rating,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18.r,
                    color: Color(0xff9CA3AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
