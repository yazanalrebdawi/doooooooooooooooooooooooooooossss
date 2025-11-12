import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/pages/change_password_screen.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/card_settings_widget.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountSettingsWidget extends StatelessWidget {
  const AccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return CardSettingsWidget(
      height: 114,
      text: "Account Settings",
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsRowWidget(
            iconBackgroundColor: isDark ? Color(0xff991B1B) : Color(0xffFEE2E2),
            iconColor: isDark ? Color(0xffFCA5A5) : Color(0xffDC2626),
            iconData: Icons.lock,
            text: "Change Password",
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: isDark ? Colors.grey[400] : Color(0xff9CA3AF),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<MyProfileCubit>(context),
                    child: ChangePasswordScreen(),
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
