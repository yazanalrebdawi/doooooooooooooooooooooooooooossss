import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    String translate(String key) =>
        AppLocalizations.of(context)?.translate(key) ?? key;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('privacyPolicy'),
          style: AppTextStyles.blackS24W600.copyWith(color: AppColors.field),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.field),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SingleChildScrollView(
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
              _buildSection(translate('cameraAndPhotoAccess'),
                  translate('cameraAndPhotoAccessText')),
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
              SizedBox(height: 30.h),
            ],
          ),
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
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            text,
            style: TextStyle(fontSize: 14.sp, height: 1.5),
          ),
        ],
      ),
    );
  }
}
