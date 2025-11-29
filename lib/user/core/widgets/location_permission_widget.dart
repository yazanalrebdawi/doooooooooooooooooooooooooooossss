import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../localization/app_localizations.dart';
import 'location_disclosure_screen.dart';

class LocationPermissionWidget extends StatelessWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const LocationPermissionWidget({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Location Icon
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 40.sp,
            ),
          ),

          SizedBox(height: 24.h),

          // Title
          Text(
            localizations.translate('locationPermissionRequired'),
            style: AppTextStyles.blackS16W600,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12.h),

          // Description
          Text(
            localizations.translate('locationPermissionMessage'),
            style: AppTextStyles.secondaryS14W400,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32.h),

          // Buttons
          Row(
            children: [
              // Deny Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    onPermissionDenied?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.gray,
                    side: BorderSide(color: AppColors.gray),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    localizations.translate('dontAllow'),
                    style: AppTextStyles.secondaryS14W400,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Allow Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Show prominent full-screen disclosure (Google Play requirement)
                    showLocationDisclosureScreen(
                      context,
                      onPermissionGranted: onPermissionGranted,
                      onPermissionDenied: onPermissionDenied,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    localizations.translate('allow'),
                    style: AppTextStyles.buttonS14W500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
