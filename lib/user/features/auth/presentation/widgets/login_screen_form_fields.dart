import 'package:dooss_business_app/dealer/Core/App_manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utiles/validator.dart';
import '../../../../core/style/app_theme.dart';
import '../../data/models/create_account_params_model.dart';

class LoginScreenFormFields extends StatefulWidget {
  final CreateAccountParams params;
  final TextEditingController codeController;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;

  const LoginScreenFormFields({
    super.key,
    required this.params,
    required this.codeController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  @override
  State<LoginScreenFormFields> createState() => _LoginScreen2FormFieldsState();
}

class _LoginScreen2FormFieldsState extends State<LoginScreenFormFields> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(children: [
      // Username Field
      TextFormField(
        controller: widget.params.userName,
        focusNode: widget.params.userNameNode,
        keyboardType: TextInputType.text,
        style: AppTextStyles.s16w400.withThemeColor(context),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
          hintText:
              AppLocalizations.of(context)?.translate('username') ?? 'Username',
          hintStyle:
              AppTextStyles.hintTextStyleWhiteS20W400.withThemeColor(context),
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
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : AppColors.white,
        ),
        validator: (value) => Validator.notNullValidation(value),
        onChanged: (value) {
          widget.onEmailChanged(value);
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(widget.params.passwordNode);
        },
      ),
      SizedBox(height: 16.h),

      // Password Field
      TextFormField(
        controller: widget.params.password,
        focusNode: widget.params.passwordNode,
        obscureText: !_isPasswordVisible,
        style: AppTextStyles.s16w400.withThemeColor(context),
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
              AppLocalizations.of(context)?.translate('password') ?? 'Password',
          hintStyle:
              AppTextStyles.hintTextStyleWhiteS20W400.withThemeColor(context),
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
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : AppColors.white,
        ),
        validator: (value) => Validator.notNullValidation(value),
        onChanged: (value) {
          widget.onPasswordChanged(value);
        },
      ),
      SizedBox(height: 12.h),
      SizedBox(height: 12.h),

      BlocSelector<AppManagerCubit, AppManagerState, bool>(
        selector: (state) => state.isDealer,
        builder: (context, isDealer) {
          if (!isDealer) return const SizedBox.shrink();

          return Column(
            children: [
              TextFormField(
                controller: widget.codeController,
                style: AppTextStyles.s16w400.withThemeColor(context),
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.verified_outlined, color: AppColors.primary),
                  hintText: AppLocalizations.of(context)
                          ?.translate('Confirmation code') ??
                      'Confirmation Code',
                  hintStyle: AppTextStyles.hintTextStyleWhiteS20W400
                      .withThemeColor(context),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.gray, width: 1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.gray, width: 1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.white,
                ),
                validator: (value) => Validator.notNullValidation(value),
              ),
              SizedBox(height: 12.h),
            ],
          );
        },
      )
    ]);
  }
}
