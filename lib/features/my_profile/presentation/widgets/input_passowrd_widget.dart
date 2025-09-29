import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/style/text_form_field_style.dart';
import 'package:dooss_business_app/core/utiles/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputPassowrdWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double? width;

  const InputPassowrdWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (width ?? 375).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 75.h,
            child: TextFormField(
              controller: controller,
              obscureText: true,
              obscuringCharacter: '*',
              textInputAction: TextInputAction.next,
              decoration: TextFormFieldStyle.baseForm(
                AppLocalizations.of(context)?.translate(hintText) ?? hintText,
                context,
                AppTextStyles.s16w400.copyWith(color: AppColors.rating),
              ),
              validator: (value) => Validator.validatePassword(value, context),
            ),
          ),
        ],
      ),
    );
  }
}
