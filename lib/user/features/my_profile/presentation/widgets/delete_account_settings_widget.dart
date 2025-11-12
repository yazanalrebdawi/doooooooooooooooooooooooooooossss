import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/user/features/my_profile/presentation/widgets/settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountSettingsWidget extends StatelessWidget {
  const DeleteAccountSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsRowWidget(
        iconBackgroundColor: Color(0xffFEE2E2),
        iconColor: Color(0xffDC2626),
        iconData: Icons.delete_forever,
        isWidgetLogOut: true,
        text: 'deleteAccountTitle',
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.r,
          color: Color(0xff9CA3AF),
        ),
        onTap: () {
          context.push(
            RouteNames.deleteAccountUser,
            extra: {
              'blocProvide': BlocProvider.of<MyProfileCubit>(context),
            },
          );
        });
  }
}
