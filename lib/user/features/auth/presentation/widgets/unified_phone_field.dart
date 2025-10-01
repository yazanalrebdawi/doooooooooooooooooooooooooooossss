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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.darkCard : AppColors.white;
    final borderColor = isDark ? AppColors.darkCard : AppColors.gray;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final hintColor = isDark ? AppColors.gray : AppColors.gray;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: borderColor,
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
                // Flag placeholder
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
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
                  style: AppTextStyles.s16w400.copyWith(color: textColor),
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
              style: AppTextStyles.s16w400.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.translate('phoneNumber') ?? 'Phone Number',
                hintStyle: AppTextStyles.s16w400.copyWith(color: hintColor),
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
