import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowTipsPasswordWidget extends StatelessWidget {
  const RowTipsPasswordWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5.w,
      children: [
        Icon(Icons.check, color: AppColors.primary),
        Text(
          AppLocalizations.of(context)?.translate(title) ?? title,
          style: AppTextStyles.s14w400.copyWith(color: Color(0xff4B5563)),
        ),
      ],
    );
  }
}
