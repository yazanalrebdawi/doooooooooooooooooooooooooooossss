import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../localization/app_localizations.dart';
import '../routes/route_names.dart';
import '../services/location_service.dart';

/// Full-screen prominent disclosure for location permission
/// This meets Google Play's requirement for prominent disclosure before
/// requesting location permission (ACCESS_FINE_LOCATION / ACCESS_COARSE_LOCATION)
class LocationDisclosureScreen extends StatelessWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const LocationDisclosureScreen({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 48.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    localizations.translate('locationPermissionRequired'),
                    style: AppTextStyles.whiteS22W700,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main disclosure message
                    Text(
                      localizations.translate('locationDisclosureMainMessage'),
                      style: AppTextStyles.s16w400.copyWith(
                        color:
                            isDark ? Colors.white70 : AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // What data we collect section
                    _buildSection(
                      context,
                      icon: Icons.data_usage,
                      title: localizations.translate('whatDataWeCollect'),
                      content:
                          localizations.translate('whatDataWeCollectContent'),
                      isDark: isDark,
                    ),
                    SizedBox(height: 16.h),

                    // Why we need it section
                    _buildSection(
                      context,
                      icon: Icons.help_outline,
                      title: localizations.translate('whyWeNeedLocation'),
                      content: null,
                      isDark: isDark,
                      bullets: [
                        localizations.translate('locationReason1'),
                        localizations.translate('locationReason2'),
                        localizations.translate('locationReason3'),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // How we use it section
                    _buildSection(
                      context,
                      icon: Icons.security,
                      title: localizations.translate('howWeUseLocation'),
                      content:
                          localizations.translate('howWeUseLocationContent'),
                      isDark: isDark,
                    ),
                    SizedBox(height: 24.h),

                    // Privacy note
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.privacy_tip,
                                color: Colors.blue,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                localizations.translate('privacyCommitment'),
                                style: AppTextStyles.blackS16W600.copyWith(
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            localizations.translate('privacyCommitmentContent'),
                            style: AppTextStyles.secondaryS14W400.copyWith(
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Privacy Policy Link
                          GestureDetector(
                            onTap: () {
                              context.push(RouteNames.privacyPolicy);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.open_in_new,
                                  color: Colors.blue,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  localizations.translate('viewPrivacyPolicy'),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Allow button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _requestLocationPermission(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        localizations.translate('allowLocationAccess'),
                        style: AppTextStyles.whiteS16W600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Deny button
                  SizedBox(
                    width: double.infinity,
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
                        localizations.translate('dontAllow'),
                        style: AppTextStyles.s16w600.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? content,
    List<String>? bullets,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.blackS16W600.copyWith(
                    color: isDark ? Colors.white : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (content != null)
            Text(
              content,
              style: AppTextStyles.s14w400.copyWith(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          if (bullets != null)
            ...bullets.map((bullet) => Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          style: AppTextStyles.s14w400.copyWith(
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    try {
      // First, check if location services are enabled
      bool serviceEnabled = await LocationService.location.serviceEnabled();

      if (!serviceEnabled) {
        // Request to enable location service
        serviceEnabled = await LocationService.location.requestService();
        if (!serviceEnabled) {
          if (context.mounted) {
            _showEnableLocationServicesDialog(context);
          }
          return;
        }
      }

      // Use permission_handler to request ONLY "while in use" permission
      // This prevents the system from showing "Allow all the time" option
      ph.PermissionStatus permissionStatus = await ph.Permission.locationWhenInUse.status;

      // If permission is permanently denied, show settings dialog
      if (permissionStatus.isPermanentlyDenied) {
        if (context.mounted) {
          _showOpenSettingsDialog(context);
        }
        return;
      }

      // If permission is denied, request it (foreground only)
      if (permissionStatus.isDenied) {
        permissionStatus = await ph.Permission.locationWhenInUse.request();
      }

      // If we have permission, proceed
      if (permissionStatus.isGranted) {
        // Try to get location to verify permission works
        try {
          LocationData locationData =
              await LocationService.location.getLocation();
          print(
              '✅ Location permission granted: lat=${locationData.latitude}, lon=${locationData.longitude}');
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          onPermissionGranted?.call();
        } catch (e) {
          print('❌ Error getting location: $e');
          if (context.mounted) {
            _showLocationErrorDialog(context);
          }
        }
      } else {
        // Permission denied
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        onPermissionDenied?.call();
      }
    } catch (e) {
      print('❌ Error requesting location permission: $e');
      if (context.mounted) {
        _showLocationErrorDialog(context);
      }
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
              await LocationService.location.requestService();
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
              await ph.openAppSettings();
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

/// Helper function to show the full-screen location disclosure
void showLocationDisclosureScreen(
  BuildContext context, {
  VoidCallback? onPermissionGranted,
  VoidCallback? onPermissionDenied,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => LocationDisclosureScreen(
        onPermissionGranted: onPermissionGranted,
        onPermissionDenied: onPermissionDenied,
      ),
    ),
  );
}
