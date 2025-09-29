import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utiles/validator.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/services/locator_service.dart';
import '../../data/models/create_account_params_model.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'custom_app_snack_bar.dart';

class LogInBodySection extends StatefulWidget {
  const LogInBodySection({super.key});

  @override
  State<LogInBodySection> createState() => _LogInBodySectionState();
}

class _LogInBodySectionState extends State<LogInBodySection> {
  final SigninParams _params = SigninParams();
  bool _isPasswordVisible = false;

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
        listenWhen:
            (previous, current) =>
                previous.checkAuthState != current.checkAuthState ||
                previous.error != current.error ||
                previous.success != current.success,
        listener: (context, state) {
          print('🔍 Login - Auth State: ${state.checkAuthState}');
          print('🔍 Login - Loading: ${state.isLoading}');
          print('🔍 Login - Error: ${state.error}');
          print('🔍 Login - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.signinSuccess) {
            print('✅ Login Success - Navigating to Home');
            ScaffoldMessenger.of(context).showSnackBar(
              customAppSnackBar(
                AppLocalizations.of(context)?.translate('loginSuccess') ??
                    "Login successful!",
                context,
              ),
            );

            // تأخير قصير ثم الانتقال إلى Home
            Future.delayed(const Duration(milliseconds: 500), () {
              context.go(RouteNames.homeScreen);
            });
          }
          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ Login Error: ${state.error}');
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
        },
        buildWhen:
            (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.checkAuthState != current.checkAuthState ||
                previous.error != current.error ||
                previous.success != current.success,
        builder: (context, state) {
          return Form(
            key: _params.formState,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  _buildEmailField(),
                  SizedBox(height: 20.h),
                  // Password Field
                  _buildPasswordField(),
                  SizedBox(height: 20.h),
                  // Login Button
                  _buildLoginButton(context, state),
                  SizedBox(height: 15.h),
                  // Remember Me & Forgot Password
                  _buildBottomSection(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.translate('email') ?? 'Email',
          style: AppTextStyles.lableTextStyleBlackS22W500,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _params.email,
          focusNode: _params.emailNode,
          keyboardType: TextInputType.emailAddress,
          style: AppTextStyles.s16w400,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            hintText:
                AppLocalizations.of(context)?.translate('enterEmail') ??
                "Enter your email",
            hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          validator: (value) => Validator.emailValidation(value),
          onChanged: (value) {},
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_params.passwordNode);
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.translate('password') ?? 'Password',
          style: AppTextStyles.lableTextStyleBlackS22W500,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _params.password,
          focusNode: _params.passwordNode,
          obscureText: !_isPasswordVisible,
          style: AppTextStyles.s16w400,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            hintText:
                AppLocalizations.of(context)?.translate('enterPassword') ??
                "Enter your password",
            hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          validator: (value) => Validator.notNullValidation(value),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed:
            state.isLoading
                ? null
                : () {
                  print('🔘 Login Button Pressed');
                  print('📧 Email: ${_params.email.text}');
                  print('🔑 Password: ${_params.password.text}');

                  if (_params.formState.currentState!.validate()) {
                    print('✅ Form validation passed, calling signIn');
                    context.read<AuthCubit>().signIn(_params);
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
          child:
              state.isLoading
                  ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.w,
                    ),
                  )
                  : Text(
                    AppLocalizations.of(context)?.translate('login') ??
                        'Sign In',
                    style: AppTextStyles.buttonTextStyleWhiteS22W700,
                  ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, AuthState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: state.isRememberMe ?? false,
              onChanged: (value) {
                context.read<AuthCubit>().toggleRememberMe();
              },
              activeColor: AppColors.primary,
            ),
            Text(
              AppLocalizations.of(context)?.translate('rememberMe') ??
                  'Remember me',
              style: AppTextStyles.descriptionS18W400,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.go(RouteNames.forgetPasswordPage);
          },
          child: Text(
            AppLocalizations.of(context)?.translate('forgetPassword') ??
                'Forgot password?',
            style: AppTextStyles.descriptionS18W400,
          ),
        ),
      ],
    );
  }
}
