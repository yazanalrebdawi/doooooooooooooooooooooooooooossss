import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/service_model.dart';
import '../../../../core/localization/app_localizations.dart';

class NearbyServiceCardWidget extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onShowOnMap;
  final VoidCallback onMoreDetails;

  const NearbyServiceCardWidget({
    super.key,
    required this.service,
    required this.onShowOnMap,
    required this.onMoreDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isMechanic = service.type.toLowerCase().contains('mechanic') ||
        service.name.toLowerCase().contains('garage') ||
        service.name.toLowerCase().contains('repair');

    return Container(
      height: 140.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: icon, info, status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Icon
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: isMechanic ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  isMechanic ? Icons.build : Icons.local_gas_station,
                  color: AppColors.white,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 12.w),

              // Service Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: AppTextStyles.blackS16W600.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${_calculateDistance()} ${AppLocalizations.of(context)!.translate('kmAway')}',
                      style: AppTextStyles.secondaryS14W400.copyWith(
                        color: AppColors.gray,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      service.type,
                      style: AppTextStyles.secondaryS12W400.copyWith(
                        color: AppColors.gray,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Open/Closed Status
              Column(
                children: [
                  Text(
                    service.openNow
                        ? AppLocalizations.of(context)!.translate('open')
                        : AppLocalizations.of(context)!.translate('closed'),
                    style: AppTextStyles.secondaryS12W400.copyWith(
                      color: service.openNow ? Colors.green : Colors.red,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: service.openNow ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Spacer(),

          // Bottom row: action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120.w,
                height: 35.h,
                child: ElevatedButton(
                  onPressed: onShowOnMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('showOnMap'),
                    style: AppTextStyles.secondaryS12W400.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 120.w,
                height: 35.h,
                child: OutlinedButton(
                  onPressed: onMoreDetails,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    side: BorderSide(
                      color: AppColors.gray.withOpacity(0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('moreDetails'),
                    style: AppTextStyles.secondaryS12W400.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateDistance() {
    // Mock distance for now
    final distances = ['1.2', '2.1', '3.5', '4.2', '0.8', '1.9'];
    final randomIndex = service.id % distances.length;
    return distances[randomIndex];
  }
}
