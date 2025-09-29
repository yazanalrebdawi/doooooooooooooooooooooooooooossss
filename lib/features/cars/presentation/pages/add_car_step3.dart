import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';

class AddCarStep3 extends StatelessWidget {
  const AddCarStep3({super.key, required this.onNext});

  final VoidCallback onNext;

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
            AppLocalizations.of(context)?.translate('carImages') ?? 'Car Images',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp).withThemeColor(context),
          ),
          SizedBox(height: 32.h),
          Text(AppLocalizations.of(context)?.translate('uploadCarImages') ?? 'Upload Car Images', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500).withThemeColor(context)),
          SizedBox(height: 8.h),
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(Icons.add_a_photo, size: 40.sp, color: isDark?Colors.white : Colors.grey[400]),
            ),
          ),
          SizedBox(height: 18.h),
          Text(AppLocalizations.of(context)?.translate('additionalNotes') ?? 'Additional Notes', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500).withThemeColor(context)),
          SizedBox(height: 8.h),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.translate('anyAdditionalNotes') ?? 'Any additional notes...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
} 