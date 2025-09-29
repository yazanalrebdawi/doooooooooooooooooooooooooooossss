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

  const LoginScreenButtonsSection({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        // Sign In Button
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            final isLoading = state.isLoading;
            return AuthButton(
              onTap: isLoading
                  ? null
                  : () {
                      if (params.formState.currentState!.validate()) {
                        final signinParams = SigninParams();
                        signinParams.email.text =
                            params.userName.text; // استخدام firstName كـ email
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
                style: AppTextStyles.descriptionS18W400
                    .copyWith(fontSize: 14)
                    .withThemeColor(context),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
          ],
        ),
      ],
    );
  }
}
