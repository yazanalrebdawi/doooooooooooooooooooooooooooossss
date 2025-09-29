import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/locator_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../widgets/custom_app_snack_bar.dart';
import '../widgets/dont_have_an_account.dart';
import '../widgets/login_screen_logo_section.dart';
import '../widgets/login_screen_header_section.dart';
import '../widgets/login_screen_form_fields.dart';
import '../widgets/login_screen_options_section.dart';
import '../widgets/login_screen_buttons_section.dart';
import '../../data/models/create_account_params_model.dart';
import 'verify_otp_page.dart';

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
    print('🔍 LoginScreen - Checking authentication...');
    final isAuthenticated = await AuthService.isAuthenticated();
    print('🔍 LoginScreen - Is authenticated: $isAuthenticated');

    if (isAuthenticated && mounted) {
      print('🚀 LoginScreen - User is authenticated, navigating to Home');
      context.go(RouteNames.homeScreen);
    } else {
      print(
          '🔍 LoginScreen - User is not authenticated, staying on login screen');
    }
  }

  @override
  void dispose() {
    _params.paramsDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          print('🔍 Login Screen - Auth State: ${state.checkAuthState}');
          print('🔍 Login Screen - Loading: ${state.isLoading}');
          print('🔍 Login Screen - Error: ${state.error}');
          print('🔍 Login Screen - Success: ${state.success}');

          if (state.checkAuthState == CheckAuthState.signinSuccess) {
            print('✅ Login Success - Navigating to Home');
            if (context.mounted) {
              sl<ToastNotification>().showSuccessMessage(
                context,
                AppLocalizations.of(context)?.translate('signInSuccess') ??
                    "Sign in Success",
              );
              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  context.go(RouteNames.homeScreen);
                }
              });
            }
          }
          if (state.checkAuthState == CheckAuthState.error) {
            print('❌ Login Error: ${state.error}');
            sl<ToastNotification>().showErrorMessage(
              context,
              state.error ??
                  AppLocalizations.of(context)?.translate('operationFailed') ??
                  "Operation failed",
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _params.formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 106.h),

                      /// 🔹 Logo / Header Section
                      const LoginScreenHeaderSection(),

                      /// 🔹 Form Fields (text input will use InputDecorationTheme)
                      LoginScreenFormFields(
                        params: _params,
                        onEmailChanged: (email) {},
                        onPasswordChanged: (password) {},
                      ),

                      /// 🔹 Options (Forgot Password, Remember Me, etc.)
                      const LoginScreen2OptionsSection(),

                      /// 🔹 Buttons (Login / Social Login)
                      LoginScreenButtonsSection(params: _params),

                      SizedBox(height: 38.h),

                      /// 🔹 "Don't have an account?"
                      Center(
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.translate('dontHaveAccount') ??
                              "Don't have an account?",
                          style: textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      const DontHaveAnAccount(),
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
