import 'dart:async';
//todo بدي اعملا سكرول
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/features/auth/presentation/widgets/custom_app_snack_bar.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/core/constants/colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  Timer? _timer;
  int _start = 60;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _sendOtp();
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => canResend = true);
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  void _sendOtp() {
    context.read<MyProfileCubit>().requestOtp(phone: widget.phoneNumber);
  }

  String get _otpCode =>
      _controllers.map((controller) => controller.text).join();

  void _confirmOtp() {
    if (_otpCode.length == 6) {
      context.read<MyProfileCubit>().confirmPhone(
        phone: widget.phoneNumber,
        code: _otpCode,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customAppSnackBar(
          AppLocalizations.of(
                context,
              )?.translate("Please enter the 6-digit code") ??
              "Please enter the 6-digit code",
          context,
        ),
      );
    }
  }

  void _cancelOtp() {
    context.read<MyProfileCubit>().cancelPhoneUpdate();
    Navigator.pop(context);
    // context.pop();
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 45.w,
          height: 50.w,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: AppTextStyles.s16w600.copyWith(
              fontFamily: AppTextStyles.fontPoppins,
              color: AppColors.black,
            ),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor:
                  _controllers[index].text.isNotEmpty
                      ? const Color.fromARGB(255, 214, 211, 211)
                      : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty) {
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              }
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileCubit, MyProfileState>(
      listener: (context, state) {
        appLocator<SecureStorageService>().updateNameAndPhone1(
          newPhone: widget.phoneNumber,
        );

        context.read<AppManagerCubit>().updatePhone(widget.phoneNumber);

        if (state.statusConfirmPhone == ResponseStatusEnum.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            customAppSnackBar(
              AppLocalizations.of(
                    context,
                  )?.translate("Phone number confirmed successfully") ??
                  "Phone number confirmed successfully",
              context,
            ),
          );
          context.read<MyProfileCubit>().getInfoUser();
          Navigator.pop(context);
          // context.pop();
        } else if (state.statusConfirmPhone == ResponseStatusEnum.failure &&
            state.errorConfirmPhone != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            customAppSnackBar(state.errorConfirmPhone.toString(), context),
          );
        }

        if (state.statusCancelPhone == ResponseStatusEnum.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            customAppSnackBar(
              AppLocalizations.of(context)?.translate("Operation canceled") ??
                  "Operation canceled",

              context,
            ),
          );
          Navigator.pop(context, false);
          // context.pop(false);
        } else if (state.statusCancelPhone == ResponseStatusEnum.failure &&
            state.errorCancelPhone != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorCancelPhone ?? "")));
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            context.read<MyProfileCubit>().cancelPhoneUpdate();
            context.read<MyProfileCubit>().getInfoUser();

            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.field,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)?.translate("OTP Verification") ??
                    "OTP Verification",

                style: AppTextStyles.s20w700.copyWith(
                  fontFamily: AppTextStyles.fontPoppins,
                  color: AppColors.black,
                ),
              ),
              backgroundColor: AppColors.primary,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 40.h),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.translate(
                                        "Enter the verification code sent to",
                                      ) ??
                                      "Enter the verification code sent to",

                                  style: AppTextStyles.s20w700.copyWith(
                                    fontFamily: AppTextStyles.fontPoppins,
                                    color: AppColors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.phoneNumber,
                                  style: AppTextStyles.s20w700.copyWith(
                                    fontFamily: AppTextStyles.fontPoppins,
                                    color: AppColors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            _buildOtpFields(),
                            SizedBox(height: 20.h),
                            state.statusConfirmPhone ==
                                    ResponseStatusEnum.loading
                                ? const CircularProgressIndicator()
                                : CustomButtonWidget(
                                  width: 300,
                                  height: 64,
                                  text: "Confirm OTP",
                                  onPressed: _confirmOtp,
                                ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  canResend
                                      ? AppLocalizations.of(
                                            context,
                                          )?.translate("You can resend now") ??
                                          "You can resend now"
                                      : "Resend in $_start s",
                                  style: AppTextStyles.s16w400.copyWith(
                                    fontFamily: AppTextStyles.fontPoppins,
                                    color:
                                        canResend
                                            ? AppColors.black
                                            : Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      canResend
                                          ? () {
                                            _sendOtp();
                                            _startTimer();
                                            for (var c in _controllers) {
                                              c.clear();
                                            }
                                            _focusNodes[0].requestFocus();
                                          }
                                          : null,
                                  child: Text(
                                    AppLocalizations.of(
                                          context,
                                        )?.translate("Resend") ??
                                        "Resend",
                                    style: AppTextStyles.s20w700.copyWith(
                                      fontFamily: AppTextStyles.fontPoppins,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              onPressed: _cancelOtp,
                              child: Text(
                                AppLocalizations.of(
                                      context,
                                    )?.translate("Cancel") ??
                                    "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
