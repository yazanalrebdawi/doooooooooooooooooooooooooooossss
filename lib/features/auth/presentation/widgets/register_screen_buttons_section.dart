import 'package:dooss_business_app/features/auth/presentation/widgets/already_have_an_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/create_account_params_model.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'auth_button.dart';

class RegisterScreenButtonsSection extends StatelessWidget {
  final CreateAccountParams params;

  const RegisterScreenButtonsSection({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18.h),
        // Sign Up Button
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            
            print('🔍 RegisterScreenButtonsSection - isLoading: ${state.isLoading}');
            print('🔍 RegisterScreenButtonsSection - checkAuthState: ${state.checkAuthState}');
            
            return AuthButton(
              onTap:  () {
                print('🔘 Register Button Pressed');
                if (params.formState.currentState!.validate()) {
                  print('✅ Form validation passed, calling register');
                  context.read<AuthCubit>().register(params);
                } else {
                  print('❌ Form validation failed');
                }
              },
              buttonText: AppLocalizations.of(context)?.translate('signUp') ?? 'Sign Up',
              isLoading: state.isLoading,
            );
          },
        ),
        SizedBox(height: 40.h),
        // Or Continue With
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                AppLocalizations.of(context)?.translate('OR') ?? 'OR',
                style: AppTextStyles.descriptionS18W400.copyWith(fontSize: 14).withThemeColor(context),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
          ],
        ),
        SizedBox(height: 40.h),
        AlreadyHaveAccount()
      ],
    );
  }
} 