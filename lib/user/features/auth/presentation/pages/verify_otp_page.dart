import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/locator_service.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/custom_app_snack_bar.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNumber;
  final bool isResetPassword;

  const VerifyOtpPage({
    super.key,
    required this.phoneNumber,
    this.isResetPassword = false,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appLocator<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (prev, curr) =>
            prev.checkAuthState != curr.checkAuthState ||
            prev.error != curr.error ||
            prev.success != curr.success,
        listener: (context, state) {
          print('🔍 Verify OTP - Auth State: ${state.checkAuthState}');
          print('🔍 Verify OTP - Loading: ${state.isLoading}');
          print('🔍 Verify OTP - Error: ${state.error}');
          print('🔍 Verify OTP - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.success) {
            print('✅ OTP Verification Success');
            final successMessage =
                AppLocalizations.of(context)?.translate('otpVerified') ??
                    "OTP verified successfully!";

            // Show foreground notification with translations
            LocalNotificationService.instance.showNotification(
              id: 3,
              title: AppLocalizations.of(context)
                      ?.translate('notificationOtpVerifiedTitle') ??
                  'OTP Verified',
              body: AppLocalizations.of(context)
                      ?.translate('notificationOtpVerifiedBody') ??
                  successMessage,
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  successMessage,
                  context,
                ),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                if (widget.isResetPassword) {
                  print(
                    '🔄 Reset Password Flow - Navigating to Create New Password',
                  );
                  context.go(
                    RouteNames.createNewPasswordPage,
                    extra: widget.phoneNumber,
                  );
                } else {
                  print('🔄 Register Flow - Navigating to Home');
                  context.go(RouteNames.homeScreen);
                }
              });
            }
          }

          if (state.checkAuthState == CheckAuthState.resendOtpSuccess) {
            print('✅ Resend OTP Success');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  state.success ??
                      AppLocalizations.of(context)?.translate('otpResent') ??
                      "OTP resent successfully!",
                  context,
                ),
              );
            }
          }

          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ OTP Operation Error: ${state.error}');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  state.error ??
                      AppLocalizations.of(
                        context,
                      )?.translate('operationFailed') ??
                      "Operation failed",
                  context,
                ),
              );
            }
          }
        },
        buildWhen: (prev, curr) =>
            prev.isLoading != curr.isLoading ||
            prev.checkAuthState != curr.checkAuthState ||
            prev.error != curr.error ||
            prev.success != curr.success,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      _buildHeaderSection(),
                      SizedBox(height: 40.h),
                      _buildOtpInputSection(),
                      SizedBox(height: 40.h),
                      _buildVerifyButton(context, state),
                      SizedBox(height: 30.h),
                      _buildResendSection(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Icon(
            Icons.phone_android,
            size: 40.w,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          AppLocalizations.of(context)?.translate('verifyOtp') ?? 'Verify OTP',
          style: AppTextStyles.s24w600.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 12.h),
        Text(
          AppLocalizations.of(context)?.translate('otpSentTo') ??
              'We have sent a verification code to',
          style: AppTextStyles.s16w400.copyWith(color: AppColors.gray),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          widget.phoneNumber,
          style: AppTextStyles.s18w700.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildOtpInputSection() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)?.translate('enterOtp') ??
              'Enter the 6-digit code',
          style: AppTextStyles.s16w400.copyWith(color: AppColors.gray),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) => _buildOtpField(index)),
        ),
      ],
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 45.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _otpFocusNodes[index].hasFocus
              ? AppColors.primary
              : AppColors.gray,
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: AppTextStyles.s20w500.copyWith(color: AppColors.primary),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5)
            _otpFocusNodes[index + 1].requestFocus();
          else if (value.isEmpty && index > 0)
            _otpFocusNodes[index - 1].requestFocus();
        },
        onFieldSubmitted: (value) {
          if (index < 5) _otpFocusNodes[index + 1].requestFocus();
        },
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () {
                print('🔘 Verify OTP Button Pressed');
                print('📱 Phone Number: ${widget.phoneNumber}');
                print('🔢 OTP Code: $_otpCode');

                if (_otpCode.length == 6) {
                  final params = VerifycodeParams(
                    phoneNumber: widget.phoneNumber,
                    otp: _otpCode,
                    isResetPassword: widget.isResetPassword,
                  );
                  context.read<AuthCubit>().verifyOtp(params);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customAppSnackBar(
                      AppLocalizations.of(
                            context,
                          )?.translate('enterCompleteOtp') ??
                          "Please enter the complete 6-digit code",
                      context,
                    ),
                  );
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
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  AppLocalizations.of(context)?.translate('verify') ?? 'Verify',
                  style: AppTextStyles.buttonTextStyleWhiteS22W700,
                ),
        ),
      ),
    );
  }

  Widget _buildResendSection(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              AppLocalizations.of(context)?.translate('didntReceiveCode') ??
                  "Didn't receive the code?",
              style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      print(
                        '🔄 Resend OTP requested for: ${widget.phoneNumber}',
                      );
                      context.read<AuthCubit>().resendOtp(widget.phoneNumber);
                    },
              child: state.isLoading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)?.translate('resendOtp') ??
                          'Resend OTP',
                      style: AppTextStyles.s16w600.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class VerifycodeParams {
  final String phoneNumber;
  final String otp;
  final bool isResetPassword;

  VerifycodeParams({
    required this.phoneNumber,
    required this.otp,
    this.isResetPassword = false,
  });
}
