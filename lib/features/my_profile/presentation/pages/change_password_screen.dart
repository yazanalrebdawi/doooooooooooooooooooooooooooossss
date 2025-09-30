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
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // DARK MODE FLAG
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBarProfileWidget(title: 'Change Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.h),
          child: Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecurityNoticeWidget(),
                SizedBox(height: 10.h),
                
                // New Password Field
                NewPasswordFieldWidget(
                  controller: newPasswordController,
    
                ),
                SizedBox(height: 10.h),

                // Confirm New Password Label
                InputLabelWidget(
                  label: "Confirm New Password",
               
                ),
                SizedBox(height: 5.h),

                // Confirm Password Field
                InputPassowrdWidget(
                  controller: confirmNewPasswordController,
                  hintText: "Confirm new password",
        
                ),
                SizedBox(height: 15.h),

                // Update Button
                ButtonUpdatePasswordWidget(
                  newPasswordController: newPasswordController,
                  confirmPasswordController: confirmNewPasswordController,
                  formState: formState,
                  
                ),
                SizedBox(height: 20.h),

                // Password Tips
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Color(0xffEAB308)),
                    SizedBox(width: 5.w),
                    Text(
                      AppLocalizations.of(context)?.translate("Password Tips") ??
                          "Password Tips",
                      style: AppTextStyles.s16w500.copyWith(
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Tips List
                RowTipsPasswordWidget(
                  title: "At least 8 characters",
                  
                ),
                RowTipsPasswordWidget(
                  title: "Mix uppercase, lowercase, numbers and symbols",
                  
                ),
                RowTipsPasswordWidget(
                  title: "Avoid personal information like names or dates",
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
