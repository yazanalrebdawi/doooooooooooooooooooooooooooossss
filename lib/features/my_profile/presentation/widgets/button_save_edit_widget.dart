import 'dart:io';
import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/core/widgets/base/app_loading.dart';
import 'package:dooss_business_app/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/features/my_profile/presentation/pages/otp_verification_screen.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonSaveEditWidget extends StatefulWidget {
  const ButtonSaveEditWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.cityController,
    this.profileImageFile,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController cityController;
  final File? profileImageFile;
  @override
  State<ButtonSaveEditWidget> createState() => _ButtonSaveEditWidgetState();
}

class _ButtonSaveEditWidgetState extends State<ButtonSaveEditWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileCubit, MyProfileState>(
      listenWhen:
          (previous, current) =>
              previous.editUser != current.editUser ||
              previous.statusEdit != current.statusEdit ||
              previous.statusConfirmPhone != current.statusConfirmPhone,
      listener: (context, state) async {
        if (state.statusEdit == ResponseStatusEnum.success) {
          final snackBarMessage =
              AppLocalizations.of(
                context,
              )?.translate('Your changes have been saved successfully.') ??
              "Your changes have been saved successfully.";
          // أظهر الرسالة
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(customAppSnackBar(snackBarMessage, context));

          final myProfileCubit = context.read<MyProfileCubit>();
          final appManagerCubit = context.read<AppManagerCubit>();

          await myProfileCubit.getInfoUser();
          final updatedUser = myProfileCubit.state.user;
          final userBeforeEdit = state.editUser;

          if (updatedUser != null) {
            appManagerCubit.saveUserData(updatedUser);
            appLocator<SecureStorageService>().updateUserModel(
              newUser: updatedUser,
            );
          }

          final phoneChanged = userBeforeEdit?.phone != updatedUser?.phone;

          if (phoneChanged && updatedUser?.phone != null) {
            Future.delayed(const Duration(milliseconds: 300), () {
              // context.push(
              //   RouteNames.otpVerificationPhoneScreen,
              //   extra: updatedUser!.phone,
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider.value(
                      value: BlocProvider.of<MyProfileCubit>(context),
                      child: OtpVerificationScreen(
                        phoneNumber: updatedUser!.phone,
                      ),
                    );
                  },
                ),
              );
            });
          }
        }
      },

      buildWhen:
          (previous, current) => previous.statusEdit != current.statusEdit,
      builder: (context, state) {
        if (state.statusEdit == ResponseStatusEnum.loading) {
          return Center(child: AppLoading.circular());
        }

        return Column(
          spacing: 5.h,
          children: [
            Divider(color: AppColors.field, thickness: 2, height: 8.h),
            CustomButtonWidget(
              width: 336,
              height: 50,
              text: "Save Changes",
              onPressed: () async {
                log("Save Changes");
                final myProfileCubit = context.read<MyProfileCubit>();

                final updatedUser = myProfileCubit.state.user;
                if (!widget.formKey.currentState!.validate()) {
                  log("❌ Validation Failed");
                  return;
                }
                final user = context.read<AppManagerCubit>().state.user;
                final newName = widget.nameController.text.trim();
                final newPhone = widget.phoneController.text.trim();

                final bool nameChanged = user?.name != newName;
                final bool phoneChanged = user?.phone != newPhone;
                if (phoneChanged) {
                  // context.push(
                  //   RouteNames.otpVerificationPhoneScreen,
                  //   extra: updatedUser?.phone ?? '',
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return BlocProvider.value(
                          value: BlocProvider.of<MyProfileCubit>(context),
                          child: OtpVerificationScreen(
                            phoneNumber: updatedUser?.phone ?? '',
                          ),
                        );
                      },
                    ),
                  );
                }

                if (!nameChanged && !phoneChanged) {
                  log("⚠️ لا يوجد تغييرات");
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(customAppSnackBar("لا يوجد تغييرات", context));
                  return;
                }

                // إرسال البيانات عبر Cubit
                await context.read<MyProfileCubit>().updateProfile(
                  name: nameChanged ? newName : null,
                  phone: phoneChanged ? newPhone : null,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
