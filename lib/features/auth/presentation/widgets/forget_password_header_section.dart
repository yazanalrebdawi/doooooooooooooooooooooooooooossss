import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class ForgetPasswordHeaderSection extends StatelessWidget {
  const ForgetPasswordHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Text(
          AppLocalizations.of(context)?.translate('Verify your phone number') ?? 'Verify your phone number',
          style: AppTextStyles.blackS24W600.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          AppLocalizations.of(context)?.translate('We have sent you an SMS with a code to number') ?? 'We have sent you an SMS with a code to number',
          style: AppTextStyles.descriptionS14W400.copyWith(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
} 