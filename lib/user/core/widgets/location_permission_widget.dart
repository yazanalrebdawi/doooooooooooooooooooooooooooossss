import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/location_service.dart';

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
            'Location Permission Required',
            style: AppTextStyles.blackS16W600,
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 12.h),
          
          // Description
          Text(
            'We need access to your location to show you nearby services like petrol stations and mechanics.',
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
                     'Not Now',
                     style: AppTextStyles.secondaryS14W400,
                   ),
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Allow Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    bool hasPermission = await LocationService.requestLocationPermission();
                    if (hasPermission) {
                      onPermissionGranted?.call();
                    } else {
                      onPermissionDenied?.call();
                    }
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
                    'Allow',
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
