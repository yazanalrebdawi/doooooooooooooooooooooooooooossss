import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/notification_methods_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/notification_types_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/row_with_switch_widget.dart';
import 'package:flutter/material.dart';

class SettingsNotificationsScreen extends StatelessWidget {
  const SettingsNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarProfileWidget(title: "Notification Settings"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ContainerBaseWidget(
              height: 78,
              width: 358,
              child: RowWithSwitchWidget(
                iconBackgroundColor: const Color(0xffebf5ed),
                iconColor: AppColors.primary,
                iconData: Icons.notifications,
                topRightText: "General Notifications",
                bottomRightText: "Enable all notifications",
              ),
            ),
          ),
          NotificationTypesWidget(),
          NotificationMethodsWidget(),
        ],
      ),
    );
  }
}
