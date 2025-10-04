import 'dart:developer';

import 'package:dooss_business_app/dealer/Core/network/dealers_App_dio.dart';
import 'package:dooss_business_app/dealer/Core/network/service_locator.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/home_Page1.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/navigotorPage.dart';
import 'package:dooss_business_app/dealer/features/auth/manager/auth_dealer_cubit.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/Auth_state_dealers.dart';
import 'package:dooss_business_app/dealer/features/auth/presentation/manager/auth_Cubit_dealers.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/token_service.dart';
import 'package:dooss_business_app/user/features/auth/data/models/user_model.dart';
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
  final TextEditingController? code;
  const LoginScreenButtonsSection({super.key, required this.params, this.code});

  @override
  Widget build(BuildContext context) {
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
                return BlocListener<AuthCubitDealers, AuthStateDealers>(
                  listener: (context, state) {
                    if (state.dataUser != null) {
                      context.read<AppManagerCubit>().saveUserData(UserModel(
                            id: state.dataUser!.user.id,
                            name: state.dataUser!.user.name, latitude: '',
                            createdAt: DateTime.now(), longitude: '',
                            phone: state.dataUser!.user.phone,
                            role:
                                'dealer', // Assuming dealers have the role 'dealer'
                            verified: state.dataUser!.user.verified,
                          ));
                      TokenService.saveToken(state.dataUser!.access);
                      DealersAppDio().addToken(state.dataUser!.access);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return NavigatorPage();
                        },
                      ));
                    }
                  },
                  child: AuthButton(
                    onTap: isLoading
                        ? null
                        : () {
                            if (params.formState.currentState!.validate()) {
                              final signinParams = SigninParams();
                              signinParams.email.text = params.userName.text;
                              signinParams.password.text = params.password.text;
                              if (isDealer) {
                                //todo -------------------------------------
                                // context
                                //     .read<AuthDealerCubit>()
                                //     .signIn("", " ", "");
                                context.read<AuthCubitDealers>().SignIn(
                                    name: params.userName.text,
                                    password: params.password.text,
                                    code: code?.text ?? '');
                                print("the code dddddddddd is ");
                              } else {}
                            }
                          },
                    buttonText:
                        AppLocalizations.of(context)?.translate('login') ??
                            'Login',
                    isLoading: isLoading,
                  ),
                );
              },
            );
          },
        ),

        SizedBox(height: 20.h),

        // ###################### OR Divider ######################
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                AppLocalizations.of(context)?.translate('OR') ?? 'OR',
                style: AppTextStyles.descriptionS18W400.copyWith(fontSize: 14),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
          ],
        ),
      ],
    );
  }
}
