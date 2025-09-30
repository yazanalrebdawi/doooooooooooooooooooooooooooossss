import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';

class AddCarStep4 extends StatelessWidget {
  const AddCarStep4({super.key, required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)?.translate('reviewSubmit') ??
                'Review & Submit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            AppLocalizations.of(context)?.translate('pleaseReviewCarDetails') ??
                'Please review your car details before submitting.',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 18.h),

          // Car summary container
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                AppLocalizations.of(context)?.translate('carSummaryGoesHere') ??
                    'Car summary goes here...',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)?.translate('submit') ?? 'Submit',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
