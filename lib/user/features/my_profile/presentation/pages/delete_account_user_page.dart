import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/input_passowrd_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountUserPage extends StatefulWidget {
  const DeleteAccountUserPage({super.key});

  @override
  State<DeleteAccountUserPage> createState() => _DeleteAccountUserPageState();
}

class _DeleteAccountUserPageState extends State<DeleteAccountUserPage> {
  final TextEditingController passwordController = TextEditingController();
  String? selectedReason;

  final List<String> reasons = [
    'deleteReason_betterApp',
    'deleteReason_privacy',
    'deleteReason_notifications',
    'deleteReason_other',
  ];

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyProfileCubit>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 150.h, 20.w, 50.h),
          child: BlocConsumer<MyProfileCubit, MyProfileState>(
            listenWhen: (pre, curr) =>
                pre.statusDeletAccount != curr.statusDeletAccount,
            listener: (context, state) {
              if (state.statusDeletAccount == ResponseStatusEnum.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                              ?.translate('deleteAccountSuccess') ??
                          'Account deleted successfully ✅',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                context.read<AppManagerCubit>().logOut();
                context.go(RouteNames.splashScreen);
              } else if (state.statusDeletAccount ==
                  ResponseStatusEnum.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorDeletAccount ??
                          (AppLocalizations.of(context)
                                  ?.translate('deleteAccountError') ??
                              'Error deleting account ❌'),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            buildWhen: (pre, curr) =>
                pre.statusDeletAccount != curr.statusDeletAccount,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)
                            ?.translate('deleteAccountTitle') ??
                        'Delete Account',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 28.sp,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  InputPassowrdWidget(
                    controller: passwordController,
                    hintText: AppLocalizations.of(context)
                            ?.translate('currentPassword') ??
                        'Current Password',
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 75.h,
                    child: DropdownButtonFormField<String>(
                      value: selectedReason,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                                ?.translate('deleteReason') ??
                            'Reason',
                        hintStyle: AppTextStyles.s16w400
                            .copyWith(color: AppColors.background),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 18.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(62.r),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(62.r),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(62.r),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2.w),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: reasons
                          .map((reason) => DropdownMenuItem<String>(
                                value: reason,
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.translate(reason) ??
                                      reason,
                                  textAlign: TextAlign.center,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                      dropdownColor: Colors.white,
                      style: AppTextStyles.s16w400
                          .copyWith(color: AppColors.BlueDark),
                      iconEnabledColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  state.statusDeletAccount == ResponseStatusEnum.loading
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: () {
                            final password = passwordController.text.trim();
                            final reason = selectedReason?.trim() ?? '';
                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)?.translate(
                                            'enterPasswordWarning') ??
                                        'Please enter your password',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            cubit.deleteAccount(password, reason);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 62.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(62.r),
                            ),
                            child: Text(
                              AppLocalizations.of(context)
                                      ?.translate('deleteAccountButton') ??
                                  'Delete Account',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
