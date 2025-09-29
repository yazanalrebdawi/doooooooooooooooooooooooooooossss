import 'dart:developer';

import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/core/widgets/base/app_loading.dart';
import 'package:dooss_business_app/features/auth/data/source/remote/auth_remote_data_source_imp.dart';
import 'package:dooss_business_app/features/auth/presentation/manager/auth_log_out_cubit.dart';
import 'package:dooss_business_app/features/auth/presentation/manager/auth_log_out_stete.dart';
import 'package:dooss_business_app/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:go_router/go_router.dart';

class LogOutSettingsWidget extends StatelessWidget {
  const LogOutSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsRowWidget(
      iconBackgroundColor: Color(0xffFEE2E2),
      iconColor: Color(0xffDC2626),
      iconData: Icons.logout,
      isWidgetLogOut: true,
      text: "Log Out",
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: Color(0xff9CA3AF),
      ),
      onTap:
          () => showDialog(
            context: context,
            builder: (_) {
              log(context.read<MyProfileCubit>().state.numberOfList.toString());
              return DialogLogOutWidget();
            },
          ),
    );
  }
}

class DialogLogOutWidget extends StatelessWidget {
  const DialogLogOutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AuthLogOutCubit(
            remote: appLocator<AuthRemoteDataSourceImp>(),
            secureStorage: appLocator<SecureStorageService>(),
            sharedPreference: appLocator<SharedPreferencesService>(),
          ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: BlocConsumer<AuthLogOutCubit, AuthLogOutStete>(
          listenWhen:
              (previous, current) =>
                  previous.logOutStatus != current.logOutStatus,
          listener: (context, state) async {
            if (state.logOutStatus == ResponseStatusEnum.success ||
                state.logOutStatus == ResponseStatusEnum.failure) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  context.go(RouteNames.loginScreen);
                }
              });
              

              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  AppLocalizations.of(
                        context,
                      )?.translate('LogOut in Success') ??
                      "LogOut in Success",
                  context,
                ),
              );
              await context.read<AppManagerCubit>().logOut();
            }
            if (state.logOutStatus == ResponseStatusEnum.failure &&
                state.errorLogOut != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  AppLocalizations.of(
                        context,
                      )?.translate(state.errorLogOut ?? "") ??
                      state.errorLogOut ??
                      "",
                  context,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.logOutStatus == ResponseStatusEnum.loading) {
              return SizedBox(
                height: 150.h,
                child: Center(child: AppLoading.circular(size: 60)),
              );
            }

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 220.h,
                minHeight: 180.h,
                maxWidth: 300.w,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.translate('Log Out') ??
                          'Log Out',
                      style: AppTextStyles.s16w600,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      AppLocalizations.of(
                            context,
                          )?.translate('Are you sure you want to log out ?') ??
                          'Are you sure you want to log out?',
                      style: AppTextStyles.s14w400,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            AppLocalizations.of(context)?.translate('Cancel') ??
                                'Cancel',
                            style: AppTextStyles.s16w400.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthLogOutCubit>().logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(
                                  context,
                                )?.translate('Log Out') ??
                                'Log Out',
                            style: AppTextStyles.s16w600.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
