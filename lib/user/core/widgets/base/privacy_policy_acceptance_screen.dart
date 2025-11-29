import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyAcceptanceScreen extends StatefulWidget {
  const PrivacyPolicyAcceptanceScreen({super.key});

  @override
  State<PrivacyPolicyAcceptanceScreen> createState() =>
      _PrivacyPolicyAcceptanceScreenState();
}

class _PrivacyPolicyAcceptanceScreenState
    extends State<PrivacyPolicyAcceptanceScreen> {
  bool _isAccepted = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleAccept() async {
    if (!_isAccepted) {
      // Show a message that user must accept
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.translate('pleaseAcceptPrivacyPolicy') ??
                'Please accept the privacy policy to continue',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save acceptance
    final sharedPrefs = appLocator<SharedPreferencesService>();
    await sharedPrefs.savePrivacyPolicyAccepted(true);

    // Navigate to splash screen (which will then navigate to appropriate screen)
    if (mounted) {
      context.go(RouteNames.splashScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    String translate(String key) =>
        AppLocalizations.of(context)?.translate(key) ?? key;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.green[700],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      translate('privacyPolicy'),
                      style: AppTextStyles.blackS24W600.copyWith(
                        color: AppColors.field,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Language Button
                  IconButton(
                    onPressed: () {
                      context.push(RouteNames.changeLanguageScreen);
                    },
                    icon: Icon(
                      Icons.language,
                      color: AppColors.field,
                      size: 28.sp,
                    ),
                    tooltip: translate('changeLanguage'),
                  ),
                ],
              ),
            ),

            // Privacy Policy Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate('privacyPolicySubtitle'),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildSection(
                        translate('introduction'), translate('introductionText')),
                    _buildSection(translate('informationWeCollect'),
                        translate('informationWeCollectText')),
                    _buildSection(translate('howWeUseInformation'),
                        translate('howWeUseInformationText')),
                    _buildSection(translate('locationInformation'),
                        translate('locationInformationText')),
                    _buildSection(translate('informationSharing'),
                        translate('informationSharingText')),
                    _buildSection(translate('cookies'), translate('cookiesText')),
                    _buildSection(
                        translate('dataSecurity'), translate('dataSecurityText')),
                    _buildSection(
                        translate('dataRetention'), translate('dataRetentionText')),
                    _buildSection(translate('linksToOtherSites'),
                        translate('linksToOtherSitesText')),
                    _buildSection(translate('changesToPolicy'),
                        translate('changesToPolicyText')),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Checkbox and Accept Button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _isAccepted,
                        onChanged: (value) {
                          setState(() {
                            _isAccepted = value ?? false;
                          });
                        },
                        activeColor: Colors.green[700],
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAccepted = !_isAccepted;
                            });
                          },
                          child: Text(
                            translate('iAcceptPrivacyPolicy'),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Accept Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        translate('acceptAndContinue'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
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

  Widget _buildSection(String title, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

