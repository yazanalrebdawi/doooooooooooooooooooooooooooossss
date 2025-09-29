import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/button_update_password_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_label_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_passowrd_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/new_password_field_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/row_tips_password_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/security_notice_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confiermNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarProfileWidget(title: 'Change Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.h),
          child: Form(
            key: formState,
            child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecurityNoticeWidget(),
                SizedBox(height: 10.h),
                NewPasswordFieldWidget(controller: newPasswordController),
                InputLabelWidget(label: "Confirm New Password"),
                InputPassowrdWidget(
                  controller: confiermNewPasswordController,
                  hintText: "Confirm new password",
                ),
                ButtonUpdatePasswordWidget(
                  newPasswordController: newPasswordController,
                  confirmPasswordController: confiermNewPasswordController,
                  formState: formState,
                ),
                SizedBox(height: 10.h),
                Column(
                  children: [
                    Row(
                      spacing: 5.w,
                      children: [
                        Icon(Icons.lightbulb, color: Color(0xffEAB308)),
                        Text(
                          AppLocalizations.of(
                                context,
                              )?.translate("Password Tips") ??
                              "Password Tips",
                          style: AppTextStyles.s16w500.copyWith(
                            color: Color(0xff111827),
                          ),
                        ),
                      ],
                    ),
                    RowTipsPasswordWidget(title: "At least 8 characters"),
                    RowTipsPasswordWidget(
                      title: "Mix uppercase, lowercase, numbers and symbols",
                    ),
                    RowTipsPasswordWidget(
                      title: "Avoid personal information like names or dates",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
