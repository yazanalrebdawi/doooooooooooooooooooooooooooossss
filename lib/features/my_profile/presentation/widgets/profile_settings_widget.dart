import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/pages/edit_profile_screen.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/show_photo_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSettingsWidget extends StatefulWidget {
  const ProfileSettingsWidget({super.key});

  @override
  State<ProfileSettingsWidget> createState() => _ProfileSettingsWidgetState();
}

class _ProfileSettingsWidgetState extends State<ProfileSettingsWidget> {
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await appLocator<SecureStorageService>().getUserModel();
    if (user != null && mounted) {
      context.read<AppManagerCubit>().saveUserData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      width: 358.w,
      height: 272.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8.r,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(2, 0),
            blurRadius: 4.r,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(-2, 0),
            blurRadius: 4.r,
          ),
        ],
      ),
      child: Column(
        spacing: 10.h,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowPhotoUserWidget(isShowedit: false),
          BlocBuilder<AppManagerCubit, AppManagerState>(
            buildWhen: (previous, current) {
              return previous.user != current.user;
            },
            builder: (context, state) {
              final user = state.user;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user?.name ?? "",
                    style: AppTextStyles.blackS20W500.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                    ),
                  ),
                  Text(
                    user?.phone ?? "",
                    style: AppTextStyles.hintS16W400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: const Color(0xff6B7280),
                    ),
                  ),
                ],
              );
            },
          ),
          CustomButtonWidget(
            width: 200,
            height: 50,
            text: "Edit Profile",
            onPressed: () {
              final appmanagerUser = context.read<AppManagerCubit>().state.user;
              if (appmanagerUser != null) {
                log("🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠🫠");
                log(appmanagerUser.name);
                log(appmanagerUser.phone);
                log(appmanagerUser.role);
                log(appmanagerUser.avatar!.path);
                log(appmanagerUser.createdAt.toString());
                log(appmanagerUser.id.toString());
                log(appmanagerUser.verified.toString());
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: BlocProvider.of<MyProfileCubit>(context),
                        child: EditProfileScreen(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
