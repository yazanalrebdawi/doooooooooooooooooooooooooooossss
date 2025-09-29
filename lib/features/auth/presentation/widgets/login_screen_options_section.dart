import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class LoginScreen2OptionsSection extends StatelessWidget {
  const LoginScreen2OptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.isRememberMe ?? false,
              onChanged: (v) {
                context.read<AuthCubit>().toggleRememberMe();
              },
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              AppLocalizations.of(context)?.translate('rememberMe') ??
                  'Remember Me',
              style: AppTextStyles.descriptionS18W400
                  .copyWith(fontSize: 14)
                  .withThemeColor(context),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                context.go(RouteNames.forgetPasswordPage);
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, minimumSize: Size(0, 0)),
              child: Text(
                AppLocalizations.of(context)?.translate('ForgotPassword') ??
                    'Forgot Password?',
                style: AppTextStyles.descriptionS18W400
                    .copyWith(fontSize: 14, color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
