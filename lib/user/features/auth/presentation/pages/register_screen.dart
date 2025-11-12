// COMMENTED OUT - Notification Service
// import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/locator_service.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/custom_app_snack_bar.dart';
import '../widgets/register_screen_header_section.dart';
import '../widgets/register_screen_form_fields.dart';
import '../widgets/register_screen_buttons_section.dart';
import '../../data/models/create_account_params_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final CreateAccountParams _params = CreateAccountParams();

  @override
  void dispose() {
    _params.paramsDispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appLocator<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          print('🔍 Register Screen - Auth State: ${state.checkAuthState}');
          print('🔍 Register Screen - Loading: ${state.isLoading}');
          print('🔍 Register Screen - Error: ${state.error}');
          print('🔍 Register Screen - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.success) {
            print('✅ Register Success - Navigating to OTP page');
            final successMessage =
                AppLocalizations.of(context)?.translate('accountCreated') ??
                    "Account created successfully!";

            // COMMENTED OUT - Notification Service
            // // Show foreground notification with translations
            // LocalNotificationService.instance.showNotification(
            //   id: 2,
            //   title: AppLocalizations.of(context)
            //           ?.translate('notificationAccountCreatedTitle') ??
            //       'Account Created',
            //   body: AppLocalizations.of(context)
            //           ?.translate('notificationAccountCreatedBody') ??
            //       successMessage,
            // );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  successMessage,
                  context,
                ),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                print('📱 Phone Number: ${_params.fullPhoneNumber}');
                print('🚀 Navigating to: ${RouteNames.verifyRegisterOtpPage}');
                context.go(
                  RouteNames.verifyRegisterOtpPage,
                  extra: _params.fullPhoneNumber,
                );
              });
            }
          }

          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ Register Error: ${state.error}');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  state.error ??
                      AppLocalizations.of(context)
                          ?.translate('operationFailed') ??
                      "Operation failed",
                  context,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _params.formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const RegisterScreenHeaderSection(),
                        RegisterScreenFormFields(
                          params: _params,
                          onFullNameChanged: (username) {},
                          onPhoneChanged: (phone) {
                            print(
                                '📞 Register Screen - Full phone number: $phone');
                            _params.fullPhoneNumber = phone;
                          },
                          onPasswordChanged: (password) {},
                          onConfirmPasswordChanged: (confirmPassword) {},
                        ),
                        SizedBox(height: 18.h),
                        RegisterScreenButtonsSection(params: _params),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
