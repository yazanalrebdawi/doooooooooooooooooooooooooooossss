import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../localization/app_localizations.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const LocationPermissionDialog({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primary,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            AppLocalizations.of(context)!.translate('locationPermissionRequired'),
            style: AppTextStyles.blackS18W700,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('locationPermissionMessage'),
            style: AppTextStyles.secondaryS14W400,
          ),
          SizedBox(height: 16.h),
          Text(
            '• سيتم استخدام موقعك فقط لعرض الخدمات القريبة\n• لن يتم مشاركة موقعك مع أي طرف ثالث\n• يمكنك إلغاء الإذن في أي وقت',
            style: AppTextStyles.secondaryS12W400.copyWith(
              color: AppColors.gray,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPermissionDenied?.call();
          },
          child: Text(
            'إلغاء',
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: AppColors.gray,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _requestLocationPermission(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.translate('allow'),
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (!serviceEnabled) {
        _showEnableLocationServicesDialog(context);
        return;
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        _showOpenSettingsDialog(context);
        return;
      }
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          print('✅ Location permission granted: lat=${position.latitude}, lon=${position.longitude}');
          onPermissionGranted?.call();
        } catch (e) {
          print('❌ Error getting location: $e');
          _showLocationErrorDialog(context);
        }
      }
    } catch (e) {
      print('❌ Error requesting location permission: $e');
      _showLocationErrorDialog(context);
    }
  }

  void _showEnableLocationServicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.orange,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'خدمة الموقع معطلة',
              style: AppTextStyles.blackS18W700,
            ),
          ],
        ),
        content: Text(
          'يرجى تشغيل خدمة الموقع في إعدادات الجهاز لعرض الخدمات القريبة منك',
          style: AppTextStyles.secondaryS14W400,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPermissionDenied?.call();
            },
            child: Text(
              'إلغاء',
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.gray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
              await Future.delayed(const Duration(seconds: 2));
              await _requestLocationPermission(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'فتح الإعدادات',
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOpenSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.settings,
              color: Colors.red,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'إذن الموقع مرفوض',
              style: AppTextStyles.blackS18W700,
            ),
          ],
        ),
        content: Text(
          'يرجى السماح بالوصول إلى الموقع في إعدادات التطبيق لعرض الخدمات القريبة منك',
          style: AppTextStyles.secondaryS14W400,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPermissionDenied?.call();
            },
            child: Text(
              'إلغاء',
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.gray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
              await Future.delayed(const Duration(seconds: 2));
              await _requestLocationPermission(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'فتح الإعدادات',
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'خطأ في تحديد الموقع',
              style: AppTextStyles.blackS18W700,
            ),
          ],
        ),
        content: Text(
          'حدث خطأ أثناء تحديد موقعك. سيتم استخدام موقع افتراضي لعرض الخدمات.',
          style: AppTextStyles.secondaryS14W400,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPermissionDenied?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'حسناً',
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
