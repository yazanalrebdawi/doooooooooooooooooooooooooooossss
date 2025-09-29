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
    this.isResetPassword = false, // افتراضياً false للـ register
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

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          print('🔍 Verify OTP - Auth State: ${state.checkAuthState}');
          print('🔍 Verify OTP - Loading: ${state.isLoading}');
          print('🔍 Verify OTP - Error: ${state.error}');
          print('🔍 Verify OTP - Success: ${state.success}');

          // التعامل مع نجاح التحقق من OTP
          if (state.checkAuthState == CheckAuthState.success) {
            print('✅ OTP Verification Success');

            sl<ToastNotification>().showSuccessMessage(
              context,
              AppLocalizations.of(context)?.translate('otpVerified') ??
                  "OTP verified successfully!",
            );

            // تأخير قصير ثم الانتقال حسب نوع الـ flow
            Future.delayed(const Duration(milliseconds: 500), () {
              if (widget.isResetPassword) {
                // إذا كان reset password، انتقل إلى صفحة إنشاء كلمة المرور الجديدة
                print(
                    '🔄 Reset Password Flow - Navigating to Create New Password');
                context.go(RouteNames.createNewPasswordPage,
                    extra: widget.phoneNumber);
              } else {
                // إذا كان register، انتقل إلى Home
                print('🔄 Register Flow - Navigating to Home');
                context.go(RouteNames.homeScreen);
              }
            });
          }

          // التعامل مع نجاح إعادة إرسال OTP
          if (state.checkAuthState == CheckAuthState.resendOtpSuccess) {
            print('✅ Resend OTP Success');

            sl<ToastNotification>().showSuccessMessage(
              context,
              state.success ??
                  AppLocalizations.of(context)?.translate('otpResent') ??
                  "OTP resent successfully!",
            );
          }

          // التعامل مع الأخطاء
          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ OTP Operation Error: ${state.error}');

            sl<ToastNotification>().showErrorMessage(
              context,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      // Header Section
                      _buildHeaderSection(context),
                      SizedBox(height: 40.h),
                      // OTP Input Section
                      _buildOtpInputSection(),
                      SizedBox(height: 40.h),
                      // Verify Button
                      _buildVerifyButton(context, state),
                      SizedBox(height: 30.h),
                      // Resend OTP Section
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

  Widget _buildHeaderSection(BuildContext ctx) {
    return Column(
      children: [
        // Icon
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
        // Title
        Text(
          AppLocalizations.of(context)?.translate('verifyOtp') ?? 'Verify OTP',
          style: AppTextStyles.s24w600.copyWith(color: AppColors.primary),
        ),
        SizedBox(height: 12.h),
        // Subtitle
        Text(
          AppLocalizations.of(context)?.translate('otpSentTo') ??
              'We have sent a verification code to',
          style: AppTextStyles.s16w400.copyWith(color: AppColors.gray),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        // Phone Number
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
        // OTP Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return _buildOtpField(index);
          }),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _otpFocusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _otpFocusNodes[index - 1].requestFocus();
          }
        },
        onFieldSubmitted: (value) {
          if (index < 5) {
            _otpFocusNodes[index + 1].requestFocus();
          }
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
                  print('✅ OTP length is correct, calling verifyOtp');
                  final params = VerifycodeParams(
                    phoneNumber: widget.phoneNumber,
                    otp: _otpCode,
                    isResetPassword:
                        widget.isResetPassword, // إرسال نوع الـ flow
                  );
                  context.read<AuthCubit>().verifyOtp(params);
                } else {
                  print('❌ OTP length is incorrect: ${_otpCode.length}');

                  sl<ToastNotification>().showErrorMessage(
                    context,
                    AppLocalizations.of(context)
                            ?.translate('enterCompleteOtp') ??
                        "Please enter the complete 6-digit code",
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
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.w,
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
                          '🔄 Resend OTP requested for: ${widget.phoneNumber}');
                      context.read<AuthCubit>().resendOtp(widget.phoneNumber);
                    },
              child: state.isLoading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.w,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)?.translate('resendOtp') ??
                          'Resend OTP',
                      style: AppTextStyles.s16w600
                          .copyWith(color: AppColors.primary),
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
    this.isResetPassword = false, // افتراضياً false للـ register
  });
}
