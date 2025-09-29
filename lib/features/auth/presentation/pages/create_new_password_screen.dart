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
import '../../data/models/create_account_params_model.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String phoneNumber;
  // إزالة otpCode لأن الـ OTP تم التحقق منه في الخطوة السابقة

  const CreateNewPasswordPage({super.key, required this.phoneNumber});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordNode.dispose();
    _confirmPasswordNode.dispose();
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
          print('🔍 Create New Password - Auth State: ${state.checkAuthState}');
          print('🔍 Create New Password - Loading: ${state.isLoading}');
          print('🔍 Create New Password - Error: ${state.error}');
          print('🔍 Create New Password - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.success) {
            print('✅ Create New Password Success - Navigating to login');
            ScaffoldMessenger.of(context).showSnackBar(
              customAppSnackBar(
                AppLocalizations.of(context)?.translate('passwordChanged') ??
                    "Password changed successfully!",
                context,
              ),
            );

            Future.delayed(const Duration(milliseconds: 500), () {
              print('🚀 Navigating to: ${RouteNames.loginScreen}');
              context.go(RouteNames.loginScreen);
            });
          }
          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ Create New Password Error: ${state.error}');
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
          return Scaffold(
            backgroundColor: AppColors.background,
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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),

                        // Header Section
                        _buildHeaderSection(),
                        SizedBox(height: 40.h),

                        // Password Fields
                        _buildPasswordFields(),
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

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Icon(Icons.lock_reset, size: 80.w, color: AppColors.primary),
        SizedBox(height: 24.h),
        Text(
          AppLocalizations.of(context)?.translate('createNewPassword') ??
              'Create New Password',
          style: AppTextStyles.s25w700.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          AppLocalizations.of(context)?.translate('enterNewPassword') ??
              'Please enter your new password',
          style: AppTextStyles.s16w400.copyWith(color: AppColors.gray),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // New Password Field
        Text(
          AppLocalizations.of(context)?.translate('newPassword') ??
              'New Password',
          style: AppTextStyles.lableTextStyleBlackS22W500,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _newPasswordController,
          focusNode: _newPasswordNode,
          obscureText: _obscureNewPassword,
          decoration: InputDecoration(
            hintText:
                AppLocalizations.of(context)?.translate('enterNewPassword') ??
                'Enter new password',
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
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.gray,
              ),
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(
                    context,
                  )?.translate('passwordRequired') ??
                  'Password is required';
            }
            if (value.length < 8) {
              return AppLocalizations.of(
                    context,
                  )?.translate('passwordTooShort') ??
                  'Password must be at least 8 characters';
            }
            return null;
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_confirmPasswordNode);
          },
        ),
        SizedBox(height: 24.h),

        // Confirm Password Field
        Text(
          AppLocalizations.of(context)?.translate('confirmPassword') ??
              'Confirm Password',
          style: AppTextStyles.lableTextStyleBlackS22W500,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordNode,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText:
                AppLocalizations.of(context)?.translate('confirmNewPassword') ??
                'Confirm new password',
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
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.gray,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(
                    context,
                  )?.translate('confirmPasswordRequired') ??
                  'Please confirm your password';
            }
            if (value != _newPasswordController.text) {
              return AppLocalizations.of(
                    context,
                  )?.translate('passwordsDoNotMatch') ??
                  'Passwords do not match';
            }
            return null;
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
        onPressed:
            state.isLoading
                ? null
                : () {
                  print('🔘 Create New Password Button Pressed');
                  print('📱 Phone Number: ${widget.phoneNumber}');
                  print('🔑 New Password: ${_newPasswordController.text}');

                  if (_formKey.currentState!.validate()) {
                    print(
                      '✅ Form validation passed, calling createNewPassword',
                    );
                    final params = ResetPasswordParams(
                      phoneNumber: widget.phoneNumber,
                      newPassword: _newPasswordController.text,
                    );
                    context.read<AuthCubit>().createNewPassword(params);
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
                    AppLocalizations.of(context)?.translate('changePassword') ??
                        'Change Password',
                    style: AppTextStyles.buttonTextStyleWhiteS22W700,
                  ),
        ),
      ),
    );
  }
}
