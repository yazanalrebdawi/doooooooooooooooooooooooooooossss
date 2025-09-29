import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class LoginScreenHeaderSection extends StatelessWidget {
  const LoginScreenHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)?.translate('welcomeBackFull') ?? 'Welcome Back\nReady to hit the road.',
            style: AppTextStyles.headLineBlackS30W600,
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
} 