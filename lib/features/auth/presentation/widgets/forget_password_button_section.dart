import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import 'auth_button.dart';

class ForgetPasswordButtonSection extends StatelessWidget {
  final VoidCallback onContinuePressed;
  final bool isLoading;

  const ForgetPasswordButtonSection({
    super.key,
    required this.onContinuePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthButton(
          onTap: isLoading ? null : onContinuePressed,
          buttonText: AppLocalizations.of(context)?.translate('Continue') ?? 'Continue',
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
} 