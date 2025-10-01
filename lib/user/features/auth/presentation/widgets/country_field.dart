import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/style/app_theme.dart';

class CountryField extends StatelessWidget {
  final String? selectedCountry;
  final VoidCallback? onTap;

  const CountryField({
    super.key,
    this.selectedCountry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            SizedBox(width: 16.w),
            // US Flag icon
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
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                selectedCountry ?? AppLocalizations.of(context)?.translate('Country') ?? 'Country',
                style: AppTextStyles.hintS16W400.copyWith(
                  color: selectedCountry != null ? Colors.black : Colors.grey[500],
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20.sp,
            ),
            SizedBox(width: 16.w),
          ],
        ),
      ),
    );
  }
} 