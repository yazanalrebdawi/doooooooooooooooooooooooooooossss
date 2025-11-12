import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/show_photo_user_widget.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(top: 20.h),
      width: 358.w,
      height: 272.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.background,
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
          BlocBuilder<MyProfileCubit, MyProfileState>(
            buildWhen: (previous, current) {
              return previous.user != current.user;
            },
            builder: (context, state) {
              // Prioritize user from MyProfileCubit (most up-to-date from API)
              final user = state.user;
              // Fallback to AppManagerCubit if MyProfileCubit doesn't have user yet
              final appManagerCubit = context.read<AppManagerCubit>();
              final fallbackUser = user ?? appManagerCubit.state.user;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fallbackUser?.name ?? "",
                    style: AppTextStyles.blackS20W500.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  Text(
                    fallbackUser?.phone ?? "",
                    style: AppTextStyles.hintS16W400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: isDark ? AppColors.gray : const Color(0xff6B7280),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
