import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/info_to_user_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/selected_language_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarProfileWidget(title: "Change Language"),
      body: SingleChildScrollView(
        child: Column(
          spacing: 23.h,
          children: [
            Center(child: SelectedLanguageWidget()),
            InfoToUserWidget(),
            Column(
              spacing: 5.h,
              children: [
                Divider(color: AppColors.field, thickness: 1, height: 9.h),
                CustomButtonWidget(
                  width: 336,
                  height: 50,
                  text: "Apply Language",
                  onPressed: () {
                    final applanguage =
                        context.read<AppManagerCubit>().state.lastApply;
                    if (applanguage != null) {
                      context.read<AppManagerCubit>().changeLocale(applanguage);
                    }
                    log("Apply Language");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
