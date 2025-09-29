import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/simple_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DarkThemeWidget extends StatefulWidget {
  final bool isSelected;
  final VoidCallback? onTap;

  const DarkThemeWidget({super.key, this.isSelected = false, this.onTap});

  @override
  State<DarkThemeWidget> createState() => _DarkThemeWidgetState();
}

class _DarkThemeWidgetState extends State<DarkThemeWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 184.h,
        width: 358.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.isSelected ? Colors.green : Colors.grey,
            width: 2.w,
          ),
        ),
        child: Column(
          spacing: 5.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.translate("Dark Mode") ??
                      "Dark Mode",
                  style: AppTextStyles.s16w500.copyWith(
                    color: Color(0xff111827),
                  ),
                ),
                Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color:
                        widget.isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          widget.isSelected
                              ? AppColors.primary
                              : AppColors.gray,
                      width: 2.w,
                    ),
                  ),
                  child:
                      widget.isSelected
                          ? Icon(
                            Icons.check,
                            color: AppColors.buttonText,
                            size: 16.sp,
                          )
                          : null,
                ),
              ],
            ),
            SizedBox(height: 5.h),
            SimpleCardWidget(
              backgroundColor: Color(0xff111827),
              longLineColor: Color(0xff4B5563),
              moreIconColor: Color(0xff4B5563),
              shortLineColor: Color(0xff374151),
              squareBorderColor: Color(0xff111827),
            ),
            Text(
              AppLocalizations.of(
                    context,
                  )?.translate("Easier on the eyes in low light conditions") ??
                  "Easier on the eyes in low light conditions",
              style: AppTextStyles.s14w400.copyWith(color: Color(0xff4B5563)),
            ),
          ],
        ),
      ),
    );
  }
}
