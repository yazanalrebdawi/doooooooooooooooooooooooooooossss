import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utiles/validator.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/custom_app_snack_bar.dart';
import '../widgets/forget_password_header_section.dart';
import '../widgets/phone_number_field.dart';
import '../widgets/forget_password_button_section.dart';
import '../../data/models/create_account_params_model.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final CreateAccountParams _params = CreateAccountParams();

  @override
  void dispose() {
    _params.paramsDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          print('🔍 Forget Password - Auth State: ${state.checkAuthState}');
          print('🔍 Forget Password - Loading: ${state.isLoading}');
          print('🔍 Forget Password - Error: ${state.error}');
          print('🔍 Forget Password - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.success) {
            print('✅ Forget Password Success - Navigating to OTP page');

            sl<ToastNotification>().showSuccessMessage(
              context,
              AppLocalizations.of(context)?.translate('otpSent') ??
                  "Verification code sent!",
            );

            // تأخير قصير ثم الانتقال
            Future.delayed(const Duration(milliseconds: 500), () {
              print('📱 Phone Number: ${_params.fullPhoneNumber}');
              print('🚀 Navigating to: ${RouteNames.verifyForgetPasswordPage}');

              context.go(RouteNames.verifyForgetPasswordPage,
                  extra: _params.fullPhoneNumber);
            });
          }
          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ Forget Password Error: ${state.error}');

            sl<ToastNotification>().showErrorMessage(
              context,
              state.error ??
                  state.error ??
                  AppLocalizations.of(context)?.translate('operationFailed') ??
                  "Operation failed",
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _params.formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header Section
                        const ForgetPasswordHeaderSection(),
                        SizedBox(height: 40.h),

                        // Phone Number Field
                        _buildPhoneNumberField(),
                        SizedBox(height: 40.h),

                        // Button Section
                        _buildButtonSection(context, state),
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

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.translate('phoneNumber') ??
              'Phone Number',
          style:
              AppTextStyles.lableTextStyleBlackS22W500.withThemeColor(context),
        ),
        SizedBox(height: 8.h),
        PhoneNumberField(
          controller: _params.phoneNumber,
          validator: (value) => Validator.notNullValidation(value),
          onPhoneChanged: (phone) {
            print('📞 Forget Password - Full phone number: $phone');
            // تخزين الرقم الكامل في CreateAccountParams
            _params.fullPhoneNumber = phone;
          },
        ),
      ],
    );
  }

  Widget _buildButtonSection(BuildContext context, AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () {
                print('🔘 Forget Password Button Pressed');
                print('📱 Phone Number: ${_params.fullPhoneNumber}');
                print(
                    '📱 Phone Number length: ${_params.fullPhoneNumber.length}');
                print(
                    '📱 Phone Number starts with +: ${_params.fullPhoneNumber.startsWith('+')}');
                print(
                    '📱 Phone Number is empty: ${_params.fullPhoneNumber.isEmpty}');

                if (_params.formState.currentState!.validate()) {
                  print('✅ Form validation passed, calling resetPassword');
                  print(
                      '✅ Form validation passed, phone: "${_params.fullPhoneNumber}"');
                  context
                      .read<AuthCubit>()
                      .resetPassword(_params.fullPhoneNumber);
                } else {
                  print('❌ Form validation failed');
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          elevation: 2,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: state.isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.w,
                  ),
                )
              : Text(
                  AppLocalizations.of(context)?.translate('sendOtp') ??
                      'Send OTP',
                  style: AppTextStyles.buttonTextStyleWhiteS22W700,
                ),
        ),
      ),
    );
  }
}
