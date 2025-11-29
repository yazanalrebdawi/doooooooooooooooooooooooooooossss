import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../localization/app_localizations.dart';

/// Prominent disclosure dialog for location permission (foreground only)
/// This meets Google Play's requirement for prominent disclosure before
/// requesting location permission
class ForegroundLocationDisclosureDialog extends StatelessWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const ForegroundLocationDisclosureDialog({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.8.sh),
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      localizations.translate('foregroundLocationDisclosureTitle'),
                      style: AppTextStyles.s20w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              
              // Main disclosure message
              Text(
                localizations.translate('foregroundLocationDisclosureMessage'),
                style: AppTextStyles.s16w400.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 20.h),
              
              // Why we need it section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('foregroundLocationWhyNeeded'),
                      style: AppTextStyles.blackS16W600,
                    ),
                    SizedBox(height: 12.h),
                    _buildBulletPoint(
                      context,
                      localizations.translate('foregroundLocationReason1'),
                    ),
                    SizedBox(height: 8.h),
                    _buildBulletPoint(
                      context,
                      localizations.translate('foregroundLocationReason2'),
                    ),
                    SizedBox(height: 8.h),
                    _buildBulletPoint(
                      context,
                      localizations.translate('foregroundLocationReason3'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // Privacy note
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        localizations.translate('foregroundLocationPrivacyNote'),
                        style: AppTextStyles.secondaryS14W400.copyWith(
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onPermissionDenied?.call();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        localizations.translate('cancel'),
                        style: AppTextStyles.s16w600.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _requestForegroundLocationPermission(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        localizations.translate('continue'),
                        style: AppTextStyles.s16w600.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: AppTextStyles.s16w400.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.s16w400.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Future<void> _requestForegroundLocationPermission(BuildContext context) async {
    try {
      // First, check if location services are enabled
      bool serviceEnabled = false;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled()
            .timeout(const Duration(seconds: 3), onTimeout: () {
          return false;
        });
      } catch (e) {
        print('❌ Error checking location service status: $e');
        serviceEnabled = false;
      }
      
      if (!serviceEnabled) {
        _showEnableLocationServicesDialog(context);
        return;
      }

      // Use permission_handler to request ONLY "while in use" permission
      // This prevents the system from showing "Allow all the time" option
      permission_handler.PermissionStatus permissionStatus = await permission_handler.Permission.locationWhenInUse.status;
      
      if (permissionStatus.isDenied) {
        // Request ONLY "while in use" permission (never shows "always" option)
        permissionStatus = await permission_handler.Permission.locationWhenInUse.request();
      }
      
      // If permission is permanently denied, show settings dialog
      if (permissionStatus.isPermanentlyDenied) {
        _showOpenSettingsDialog(context);
        return;
      }
      
      // Check if permission was granted
      if (permissionStatus.isGranted) {
        // Try to get location to verify permission works
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
    final localizations = AppLocalizations.of(context)!;
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
            Expanded(
              child: Text(
                localizations.translate('locationServicesDisabled'),
                style: AppTextStyles.blackS18W700,
              ),
            ),
          ],
        ),
        content: Text(
          localizations.translate('locationServicesDisabledMessage'),
          style: AppTextStyles.secondaryS14W400,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPermissionDenied?.call();
            },
            child: Text(
              localizations.translate('cancel'),
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.gray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              localizations.translate('openSettings'),
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
    final localizations = AppLocalizations.of(context)!;
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
            Expanded(
              child: Text(
                localizations.translate('locationPermissionDenied'),
                style: AppTextStyles.blackS18W700,
              ),
            ),
          ],
        ),
        content: Text(
          localizations.translate('locationPermissionDeniedMessage'),
          style: AppTextStyles.secondaryS14W400,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPermissionDenied?.call();
            },
            child: Text(
              localizations.translate('cancel'),
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.gray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await permission_handler.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              localizations.translate('openSettings'),
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
    final localizations = AppLocalizations.of(context)!;
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
            Expanded(
              child: Text(
                localizations.translate('locationError'),
                style: AppTextStyles.blackS18W700,
              ),
            ),
          ],
        ),
        content: Text(
          localizations.translate('locationErrorMessage'),
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
              localizations.translate('ok'),
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

