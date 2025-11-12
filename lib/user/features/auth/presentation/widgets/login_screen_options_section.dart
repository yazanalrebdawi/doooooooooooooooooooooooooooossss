import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class LoginScreen2OptionsSection extends StatelessWidget {
  const LoginScreen2OptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ###################### Forgot Password Button ######################
        TextButton(
          onPressed: () {
            context.go(RouteNames.forgetPasswordPage);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
          ),
          child: Text(
            AppLocalizations.of(context)?.translate('ForgotPassword') ??
                'Forgot Password?',
            style: AppTextStyles.descriptionS18W400.copyWith(
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
