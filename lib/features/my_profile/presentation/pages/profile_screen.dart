import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/account_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/activity_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/log_out_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/preferences_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/profile_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              MyProfileCubit(repository: appLocator<MyProfileRepository>())
                ..getInfoUser()
                ..getFavorites(),
      child: BlocListener<MyProfileCubit, MyProfileState>(
        listenWhen:
            (prev, curr) =>
                prev.statusInfoUser != curr.statusInfoUser &&
                curr.statusInfoUser == ResponseStatusEnum.success,
        listener: (context, state) {
          if (state.user != null) {
            context.read<AppManagerCubit>().saveUserData(state.user!);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBarProfileWidget(
            title: 'My Profile',
            showBack: false,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Builder(
                builder: (context) {
                  return Column(
                    spacing: 7.h,
                    children: [
                      const ProfileSettingsWidget(),
                      const AccountSettingsWidget(),
                      const PreferencesSettingsWidget(),
                      const ActivitySettingsWidget(),
                      const LogOutSettingsWidget(),
                      SizedBox(height: 10.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
