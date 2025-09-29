<<<<<<< HEAD
import 'package:dooss_business_app/core/constants/text_styles.dart';
=======
>>>>>>> zoz
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';

class AddCarStep1 extends StatelessWidget {
  const AddCarStep1({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)?.translate('addCar') ?? 'Add Car',
<<<<<<< HEAD
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp).withThemeColor(context),
          ),
          SizedBox(height: 32.h),
          Text(AppLocalizations.of(context)?.translate('yourName') ?? 'Your Name', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500).withThemeColor(context)),
=======
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
          ),
          SizedBox(height: 32.h),
          Text(AppLocalizations.of(context)?.translate('yourName') ?? 'Your Name', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
>>>>>>> zoz
          SizedBox(height: 8.h),
          TextFormField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.translate('yourName') ?? 'Your Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            ),
          ),
          SizedBox(height: 18.h),
<<<<<<< HEAD
          Text(AppLocalizations.of(context)?.translate('yourAddressLine') ?? 'Your Address Line', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500).withThemeColor(context)),
=======
          Text(AppLocalizations.of(context)?.translate('yourAddressLine') ?? 'Your Address Line', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
>>>>>>> zoz
          SizedBox(height: 8.h),
          TextFormField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.translate('yourAddressLine') ?? 'Your Address Line',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            ),
          ),
          SizedBox(height: 18.h),
<<<<<<< HEAD
          Text(AppLocalizations.of(context)?.translate('yourPostcode') ?? 'Your Postcode', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500).withThemeColor(context)),
=======
          Text(AppLocalizations.of(context)?.translate('yourPostcode') ?? 'Your Postcode', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
>>>>>>> zoz
          SizedBox(height: 8.h),
          TextFormField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.translate('yourPostcode') ?? 'Your Postcode',
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