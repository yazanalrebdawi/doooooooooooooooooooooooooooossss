import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomAppBarProfileWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;

  const CustomAppBarProfileWidget({
    super.key,
    required this.title,
    this.showBack = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,

      title: Text(
        AppLocalizations.of(context)?.translate(title) ?? title,
        style: AppTextStyles.blackS18W500.copyWith(
          fontFamily: AppTextStyles.fontPoppins,
        ),
      ),
      centerTitle: true,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.3),
      leading:
          showBack
              ? IconButton(
                onPressed: () {
                  // context.pop();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: AppColors.black),
              )
              : null,
      actions: trailing != null ? [trailing!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
