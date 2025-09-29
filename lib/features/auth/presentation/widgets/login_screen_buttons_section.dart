import 'dart:developer';

import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/create_account_params_model.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'auth_button.dart';

class LoginScreenButtonsSection extends StatelessWidget {
  final CreateAccountParams params;

  const LoginScreenButtonsSection({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        // Sign In Button
        BlocConsumer<AuthCubit, AuthState>(
          listenWhen:
              (previous, current) =>
                  previous.checkAuthState != current.checkAuthState ||
                  previous.error != current.error ||
                  previous.success != current.success,
          listener: (context, state) {
            if (state.user != null) {
              context.read<AppManagerCubit>().saveUserData(state.user!.user);
              appLocator<SecureStorageService>().updateUserModel(
                newUser: state.user!.user,
              );

              log("ssssssssssssssssssssssssss ${state.user!.user.id}");
            }
          },
          buildWhen:
              (previous, current) =>
                  previous.isLoading != current.isLoading ||
                  previous.checkAuthState != current.checkAuthState ||
                  previous.error != current.error ||
                  previous.success != current.success,
          builder: (context, state) {
            final isLoading = state.isLoading;
            return AuthButton(
              onTap:
                  isLoading
                      ? null
                      : () {
                        if (params.formState.currentState!.validate()) {
                          final signinParams = SigninParams();
                          signinParams.email.text =
                              params
                                  .userName
                                  .text; // استخدام firstName كـ email
                          signinParams.password.text = params.password.text;
                          context.read<AuthCubit>().signIn(signinParams);
                        }
                      },
              buttonText:
                  AppLocalizations.of(context)?.translate('login') ?? 'Login',
              isLoading: isLoading,
            );
          },
        ),
        SizedBox(height: 20.h),
        // Or Continue With
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                AppLocalizations.of(context)?.translate('OR') ?? 'OR',
                style: AppTextStyles.descriptionS18W400.copyWith(fontSize: 14),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
          ],
        ),
      ],
    );
  }
}
