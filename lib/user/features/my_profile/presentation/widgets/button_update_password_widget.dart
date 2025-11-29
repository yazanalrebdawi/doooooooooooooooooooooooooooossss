import 'dart:developer';
// COMMENTED OUT - Notification Service
// import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/user/core/widgets/base/app_loading.dart';
import 'package:dooss_business_app/user/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/user/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonUpdatePasswordWidget extends StatefulWidget {
  const ButtonUpdatePasswordWidget({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.formState,
  });

  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formState;

  @override
  State<ButtonUpdatePasswordWidget> createState() =>
      _ButtonUpdatePasswordWidgetState();
}

class _ButtonUpdatePasswordWidgetState
    extends State<ButtonUpdatePasswordWidget> {
  bool isValid = false;

  void _updateValidity() {
    final valid = widget.formState.currentState?.validate() ?? false;
    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.oldPasswordController.addListener(_updateValidity);
    widget.newPasswordController.addListener(_updateValidity);
    widget.confirmPasswordController.addListener(_updateValidity);
  }

  @override
  void dispose() {
    widget.oldPasswordController.removeListener(_updateValidity);
    widget.newPasswordController.removeListener(_updateValidity);
    widget.confirmPasswordController.removeListener(_updateValidity);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isValid
        ? BlocProvider.value(
            value: BlocProvider.of<MyProfileCubit>(context),
            child: Builder(
              builder: (context) {
                return BlocConsumer<MyProfileCubit, MyProfileState>(
                  listenWhen: (previous, current) =>
                      previous.statusChangePassword !=
                      current.statusChangePassword,
                  listener: (context, state) {
                    if (state.statusChangePassword ==
                            ResponseStatusEnum.failure &&
                        state.errorChangePassword != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customAppSnackBar(
                          AppLocalizations.of(context)?.translate(
                                state.errorChangePassword ?? "Error",
                              ) ??
                              "Error",
                          context,
                        ),
                      );
                    } else if (state.statusChangePassword ==
                        ResponseStatusEnum.success) {
                      // COMMENTED OUT - Notification Service
                      // // Show foreground notification with translations
                      // LocalNotificationService.instance.showNotification(
                      //   id: 13,
                      //   title: AppLocalizations.of(context)?.translate(
                      //           'notificationPasswordChangedProfileTitle') ??
                      //       'Password Changed',
                      //   body: AppLocalizations.of(context)?.translate(
                      //           'notificationPasswordChangedProfileBody') ??
                      //       'Your password has been changed successfully.',
                      // );

                      ScaffoldMessenger.of(context).showSnackBar(
                        customAppSnackBar(
                          AppLocalizations.of(
                                context,
                              )?.translate("password_changed_success") ??
                              "Password changed successfully",
                          context,
                        ),
                      );
                      // context.pop();
                      Navigator.pop(context);
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.statusChangePassword !=
                      current.statusChangePassword,
                  builder: (context, state) {
                    if (state.statusChangePassword ==
                        ResponseStatusEnum.loading) {
                      return Center(child: AppLoading.circular());
                    }
                    return CustomButtonWidget(
                      width: 358,
                      height: 48,
                      text: "Update Password",
                      onPressed: () async {
                        final UserModel? user =
                            await appLocator<SecureStorageService>()
                                .getUserModel();
                        if (user == null) {
                          return;
                        }
                        log("user.phone 😑😑😑😑😑😑 : ${user.phone}");
                        if (widget.oldPasswordController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            customAppSnackBar(
                              AppLocalizations.of(context)
                                      ?.translate("Please enter your old password") ??
                                  "Please enter your old password",
                              context,
                            ),
                          );
                        } else if (widget.newPasswordController.text.trim() ==
                            widget.confirmPasswordController.text.trim()) {
                          // Call changePassword with oldPassword, newPassword, and phone (3 parameters)
                          context.read<MyProfileCubit>().changePassword(
                                widget.oldPasswordController.text.trim(), // oldPassword
                                widget.newPasswordController.text.trim(), // newPassword
                                user.phone, // phone
                              );
                        } else {
                          widget.confirmPasswordController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            customAppSnackBar(
                              AppLocalizations.of(
                                    context,
                                  )?.translate("Retype your new password!") ??
                                  "Retype your new password!",
                              context,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          )
        : SizedBox(
            width: 358.w,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffD1D5DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(color: Color(0xffE5E7EB), width: 1.w),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: AppColors.buttonText),
                  Text(
                    AppLocalizations.of(context)
                            ?.translate("Update Password") ??
                        "Update Password",
                    style: AppTextStyles.s16w500.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: AppColors.buttonText,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
