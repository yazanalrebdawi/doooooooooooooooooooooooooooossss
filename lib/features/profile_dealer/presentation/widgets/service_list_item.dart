import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/service_model.dart';

class ServiceListItem extends StatelessWidget {
  final ServiceModel service;

  const ServiceListItem({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Service Icon
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: _parseColor(service.iconColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _getServiceIcon(service.category),
                  color: AppColors.white,
                  size: 24.sp,
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
                      style: AppTextStyles.s16w600.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.sp,
                          color: AppColors.gray,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          service.location,
                          style: AppTextStyles.s14w400.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Info Icon
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: AppColors.primary,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Status Row
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _getStatusColor(service.status),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                service.status,
                style: AppTextStyles.s14w500.copyWith(
                  color: _getStatusColor(service.status),
                ),
              ),
              if (service.closingTime != null) ...[
                SizedBox(width: 8.w),
                Text(
                  '• Closes at ${service.closingTime}',
                  style: AppTextStyles.s14w400.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          // Description
          Text(
            service.description,
            style: AppTextStyles.s14w400.copyWith(
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 12.h),
          // Bottom Row
          Row(
            children: [
              // Rating
              Row(
                children: [
                  Text(
                    service.rating.toString(),
                    style: AppTextStyles.s14w500.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.star,
                    size: 16.sp,
                    color: Colors.amber,
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              // Category Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _parseColor(service.categoryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  service.category,
                  style: AppTextStyles.s12w400.copyWith(
                    color: _parseColor(service.categoryColor),
                  ),
                ),
              ),
              const Spacer(),
              // Contact Buttons
              Row(
                children: [
                  // Phone Button
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.phone,
                      size: 20.sp,
                      color: AppColors.gray,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // WhatsApp Button
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: _parseColor(service.categoryColor).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.message,
                      size: 20.sp,
                      color: _parseColor(service.categoryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mechanic':
        return Icons.build;
      case 'fuel':
      case 'fuel station':
        return Icons.local_gas_station;
      case 'car wash':
        return Icons.local_car_wash;
      case 'electrical':
        return Icons.electric_bolt;
      default:
        return Icons.build;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open now':
      case 'open 24/7':
        return AppColors.primary;
      case 'closed':
        return AppColors.gray;
      default:
        return AppColors.gray;
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return AppColors.primary;
    }
  }
}
