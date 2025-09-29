<<<<<<< HEAD
=======
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
>>>>>>> zoz
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/constants/text_styles.dart';
<<<<<<< HEAD
import '../../../../core/localization/language_cubit.dart';
=======
>>>>>>> zoz
import '../../../../core/localization/app_localizations.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocBuilder<LanguageCubit, Locale>(
=======
    return BlocBuilder<AppManagerCubit, AppManagerState>(
>>>>>>> zoz
      builder: (context, locale) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.translate('alreadyHaveAccount') ??
                  'Already have an account?',
<<<<<<< HEAD
              style: AppTextStyles.descriptionS14W400.withThemeColor(context),
=======
              style: AppTextStyles.descriptionS14W400,
>>>>>>> zoz
            ),
            const SizedBox(width: 3),
            InkWell(
              onTap: () {
                context.go(RouteNames.loginScreen);
              },
              child: Text(
                AppLocalizations.of(context)?.translate('signIn') ?? 'Sign In',
<<<<<<< HEAD
                style: AppTextStyles.primaryS14W400.withThemeColor(context),
=======
                style: AppTextStyles.primaryS14W400,
>>>>>>> zoz
              ),
            ),
          ],
        );
      },
    );
  }
}
