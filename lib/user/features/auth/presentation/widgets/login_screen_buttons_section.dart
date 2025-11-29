import 'dart:developer';
// COMMENTED OUT - Notification Service
// import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/navigotorPage.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_Cubit_dealers.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/network/app_dio.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:dooss_business_app/user/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/user/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/create_account_params_model.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import 'auth_button.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_state_dealers.dart';

class LoginScreenButtonsSection extends StatelessWidget {
  final CreateAccountParams params;
  final TextEditingController? code;
  final bool termsAccepted;

  const LoginScreenButtonsSection({
    super.key,
    required this.params,
    this.code,
    this.termsAccepted = false,
  });

  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorageService(storage: FlutterSecureStorage());

    return Column(
      children: [
        SizedBox(height: 16.h),

        // ###################### Sign In Button ######################
        BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.checkAuthState != current.checkAuthState ||
              previous.error != current.error ||
              previous.success != current.success,
          listener: (context, state) {
            if (state.user != null) {
              context.read<AppManagerCubit>().saveUserData(state.user!.user);
              appLocator<SecureStorageService>().updateUserModel(
                newUser: state.user!.user,
              );
              log("User ID: ${state.user!.user.id}");
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                customAppSnackBar(
                  AppLocalizations.of(
                        context,
                      )?.translate(state.error ?? "") ??
                      "error",
                  context,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading ||
              previous.checkAuthState != current.checkAuthState ||
              previous.error != current.error ||
              previous.success != current.success,
          builder: (context, state) {
            final isLoading = state.isLoading;

            return BlocSelector<AppManagerCubit, AppManagerState, bool>(
              selector: (managerState) => managerState.isDealer,
              builder: (context, isDealer) {
                log("🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️🤷‍♂️");

                return BlocConsumer<AuthCubitDealers, AuthStateDealers>(
                  listenWhen: (previous, current) =>
                      previous.errorMessage != current.errorMessage ||
                      previous.dataUser != current.dataUser ||
                      previous.isLoading != current.isLoading,
                  listener: (context, dealerState) async {
                    // Handle error case - show error message and stop loading
                    if (dealerState.errorMessage != null &&
                        !dealerState.isLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customAppSnackBar(
                          dealerState.errorMessage ??
                              AppLocalizations.of(context)
                                  ?.translate('operationFailed') ??
                              'Operation failed',
                          context,
                        ),
                      );
                    }

                    // Handle success case
                    if (dealerState.dataUser != null) {
                      // COMMENTED OUT - Notification Service
                      // // Show foreground notification with translations
                      // LocalNotificationService.instance.showNotification(
                      //   id: 7,
                      //   title: AppLocalizations.of(context)?.translate(
                      //           'notificationDealerLoginSuccessTitle') ??
                      //       'Dealer Login Successful',
                      //   body: AppLocalizations.of(context)?.translate(
                      //           'notificationDealerLoginSuccessBody') ??
                      //       'Welcome back! You have successfully logged in.',
                      // );

                      context.read<AppManagerCubit>().saveUserData(
                            UserModel(
                              id: dealerState.dataUser!.user.id,
                              name: dealerState.dataUser!.user.name,
                              latitude: '',
                              createdAt: DateTime.now(),
                              longitude: '',
                              phone: dealerState.dataUser!.user.phone,
                              role: 'dealer',
                              verified: dealerState.dataUser!.user.verified,
                            ),
                          );

                      TokenService.saveToken(dealerState.dataUser!.access);
                      appLocator<AppDio>().addTokenToHeader(
                        dealerState.dataUser!.access,
                      );
                      await secureStorage.setIsDealer(true);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigatorPage(),
                        ),
                      );
                    }
                  },
                  builder: (context, dealerState) {
                    final dealerLoading = dealerState.isLoading;

                    return AuthButton(
                      onTap: dealerLoading || isLoading
                          ? null
                          : () async {
                              // Require terms acceptance for both user and dealer login
                              if (!termsAccepted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  customAppSnackBar(
                                    AppLocalizations.of(context)
                                            ?.translate('pleaseAcceptTermsAndConditions') ??
                                        'Please accept the terms and conditions to continue',
                                    context,
                                  ),
                                );
                                return;
                              }
                              
                              if (params.formState.currentState!.validate()) {
                                final signinParams = SigninParams();
                                signinParams.email.text = params.userName.text;
                                signinParams.password.text =
                                    params.password.text;

                                if (isDealer) {
                                  context.read<AuthCubitDealers>().signIn(
                                        name: params.userName.text,
                                        password: params.password.text,
                                        code: code?.text ?? '',
                                      );
                                  final secureStorage =
                                      appLocator<SecureStorageService>();
                                  final app = context
                                      .read<AppManagerCubit>()
                                      .state
                                      .dealer;
                                  if (app != null) {
                                    await secureStorage.saveDealerAuthData(app);
                                    await appLocator<SharedPreferencesService>()
                                        .saveDealerAuthData(app);
                                    await secureStorage.setIsDealer(true);
                                    await TokenService.saveToken(app.access);
                                  }
                                  print("the code dddddddddd is ");
                                } else {
                                  log("user");
                                  context
                                      .read<AuthCubit>()
                                      .signIn(signinParams);
                                }
                              }
                            },
                      buttonText:
                          AppLocalizations.of(context)?.translate('login') ??
                              'Login',
                      isLoading: isDealer ? dealerLoading : isLoading,
                    );
                  },
                );
              },
            );
          },
        ),

        SizedBox(height: 20.h),

        // ###################### OR Divider ######################
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                AppLocalizations.of(context)?.translate('OR') ?? 'OR',
                style: AppTextStyles.descriptionS18W400.copyWith(fontSize: 14),
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
