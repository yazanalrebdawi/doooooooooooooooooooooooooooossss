import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/style/text_form_field_style.dart';
import 'package:dooss_business_app/core/utiles/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputNumberWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final double? width;

  const InputNumberWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (width ?? 336).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 65.h,
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus();
              },
              decoration: TextFormFieldStyle.baseForm(
                hintText,
                context,
                AppTextStyles.s14w400.copyWith(color: AppColors.black),
              ).copyWith(prefixIcon: icon != null ? Icon(icon) : null),
              validator: (value) => Validator.phoneValidation(value),
            ),
          ),
        ],
      ),
    );
  }
}
