import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/constants/text_styles.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import '../../../../core/localization/app_localizations.dart';

class DontHaveAnAccount extends StatelessWidget {
  const DontHaveAnAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppManagerCubit, AppManagerState>(
      builder: (context, locale) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)?.translate('dontHaveAccount') ??
                  "Don't have an account?",
              style: AppTextStyles.descriptionS14W400,
            ),
            const SizedBox(width: 3),
            InkWell(
              onTap: () {
                context.go(RouteNames.rigesterScreen);
              },
              child: Text(
                AppLocalizations.of(context)?.translate('register') ??
                    'Sign Up',
                style: AppTextStyles.primaryS14W400,
              ),
            ),
          ],
        );
      },
    );
  }
}
