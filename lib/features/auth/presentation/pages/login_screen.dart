import 'dart:developer';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/locator_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/custom_app_snack_bar.dart';
import '../widgets/dont_have_an_account.dart';
import '../widgets/login_screen_header_section.dart';
import '../widgets/login_screen_form_fields.dart';
import '../widgets/login_screen_options_section.dart';
import '../widgets/login_screen_buttons_section.dart';
import '../../data/models/create_account_params_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CreateAccountParams _params = CreateAccountParams();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    log('🔍 LoginScreen - Checking authentication...');
    final isAuthenticated = await AuthService.isAuthenticated();
    log('🔍 LoginScreen - Is authenticated: $isAuthenticated');

    if (isAuthenticated && mounted) {
      log('🚀 LoginScreen - User is authenticated, navigating to Home');
      context.go(RouteNames.homeScreen);
    } else {
      log(
        '🔍 LoginScreen - User is not authenticated, staying on login screen',
      );
    }
  }

  @override
  void dispose() {
    _params.paramsDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => appLocator<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          log('🔍 Login Screen - Auth State: ${state.checkAuthState}');
          log('🔍 Login Screen - Loading: ${state.isLoading}');
          log('🔍 Login Screen - Error: ${state.error}');
          log('🔍 Login Screen - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.signinSuccess) {
            log('✅ Login Success - Navigating to Home');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  AppLocalizations.of(context)?.translate('signInSuccess') ??
                      "Sign in Success",
                  context,
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  context.go(RouteNames.homeScreen);
                }
              });
            }
          }
          if (state.checkAuthState == CheckAuthState.error) {
            log('❌ Login Error: ${state.error}');
            if (context.mounted) {
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
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,

          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _params.formState,
                  child: Column(
                    children: [
                      SizedBox(height: 106.h),
                      const LoginScreenHeaderSection(),
                      LoginScreenFormFields(
                        params: _params,
                        onEmailChanged: (email) {},
                        onPasswordChanged: (password) {},
                      ),
                      const LoginScreen2OptionsSection(),
                      LoginScreenButtonsSection(params: _params),
                      SizedBox(height: 38.h),
                      const DontHaveAnAccount(),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
