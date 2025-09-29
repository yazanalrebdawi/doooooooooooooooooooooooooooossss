import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utiles/validator.dart';

class UnifiedPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? initialCountryCode;

  const UnifiedPhoneField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.initialCountryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.gray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Country Flag and Code
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                // Flag
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 8.w),
                // Country Code
                Text(
                  '+963',
                  style: AppTextStyles.s16w400,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          // Phone Number Input
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator ?? (value) => Validator.notNullValidation(value),
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.s16w400,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.translate('phoneNumber') ?? 'Phone Number',
                hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 