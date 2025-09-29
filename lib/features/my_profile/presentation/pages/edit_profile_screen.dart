import 'dart:developer';
import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/core/widgets/base/app_loading.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/button_save_edit_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/form_edit_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/header_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<MyProfileCubit>().getInfoUser();
    final user = context.read<MyProfileCubit>().state.user;
    if (user != null) {
      context.read<AppManagerCubit>().saveUserData(user);
      appLocator<SecureStorageService>().updateUserModel(newUser: user);
      log(
        context.read<AppManagerCubit>().state.user?.name ??
            "nooooooooooooooooooooo",
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarProfileWidget(title: 'Edit Profile'),
      backgroundColor: AppColors.background,
      body: BlocConsumer<MyProfileCubit, MyProfileState>(
        listener: (context, state) async {
          if (state.statusInfoUser == ResponseStatusEnum.success) {
            final UserModel? cach = context.read<MyProfileCubit>().state.user;
            if (cach != null) {
              nameController.text = cach.name;
              phoneController.text = cach.phone;
              context.read<AppManagerCubit>().saveImage(state.user?.avatar);
            }
          }
        },
        buildWhen:
            (previous, current) =>
                previous.statusInfoUser != current.statusInfoUser,
        builder: (context, state) {
          if (state.statusInfoUser == ResponseStatusEnum.loading) {
            return Center(child: AppLoading.circular(size: 80));
          }
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<MyProfileCubit>().getInfoUser();
              final user = context.read<MyProfileCubit>().state.user;
              if (user != null) {
                context.read<AppManagerCubit>().saveUserData(user);
                log(
                  context.read<AppManagerCubit>().state.user?.name ??
                      "nooooooooooooooooooooo",
                );
              }
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  spacing: 30.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderEditScreen(),
                    FormEditProfileWidget(
                      nameController: nameController,
                      phoneController: phoneController,
                      cityController: cityController,
                    ),
                    SizedBox(height: 80.h),
                    ButtonSaveEditWidget(
                      formKey: _formKey,
                      nameController: nameController,
                      phoneController: phoneController,
                      cityController: cityController,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.dispose();
  }
}
