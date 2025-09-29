import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../widgets/notification_icon.dart';
import '../widgets/profile_avatar_home_screen.dart';

class AppBarHomeScreen extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onProfilePressed;
  final bool isOnline;

  const AppBarHomeScreen({
    super.key,
    required this.userName,
    this.onProfilePressed,
    required this.isOnline,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0.2,
      shadowColor: Colors.black,
      toolbarHeight: kToolbarHeight + 64.h,
      leadingWidth: 68.w,
      leading: ProfileAvatarHomeScreen(isOnline: isOnline, size: 40),
      title: Padding(
        padding: EdgeInsets.only(right: 12, left: 12, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                   TextSpan(
                    text: "Hello, ",
                    style: AppTextStyles.appBarTextStyleUserNameBlackS16W500,
                  ),
                  TextSpan(
                    text: '${userName}!',
                    style: AppTextStyles.appBarTextStyleUserNameBlackS16W500,

                  ),
                ],
              ),
            ),
            Text(
              "Welcome Back😊",
              style: AppTextStyles.secondaryS14W400,
            ),
          ],
        ),
      ),
      actions: [NotificationIcon(count: 3)],
    );
  }
}
