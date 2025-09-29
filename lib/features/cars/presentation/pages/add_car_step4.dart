import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';

class AddCarStep4 extends StatelessWidget {
  const AddCarStep4({super.key, required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)?.translate('reviewSubmit') ?? 'Review & Submit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
          ),
          SizedBox(height: 32.h),
          Text(AppLocalizations.of(context)?.translate('pleaseReviewCarDetails') ?? 'Please review your car details before submitting.', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 18.h),
          // هنا يمكن عرض ملخص البيانات المدخلة
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(AppLocalizations.of(context)?.translate('carSummaryGoesHere') ?? 'Car summary goes here...'),
            ),
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }
} 