import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppManagerCubit, AppManagerState>(
      builder: (context, locale) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.translate('alreadyHaveAccount') ??
                  'Already have an account?',
              style: AppTextStyles.descriptionS14W400,
            ),
            const SizedBox(width: 3),
            InkWell(
              onTap: () {
                context.go(RouteNames.loginScreen);
              },
              child: Text(
                AppLocalizations.of(context)?.translate('signIn') ?? 'Sign In',
                style: AppTextStyles.primaryS14W400,
              ),
            ),
          ],
        );
      },
    );
  }
}
