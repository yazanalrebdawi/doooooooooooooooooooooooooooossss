import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/service_model.dart';
import 'service_placeholder_image_widget.dart';
import 'service_status_indicator_widget.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onViewDetails;
  final VoidCallback? onMaps;
  final VoidCallback? onCall;

  const ServiceCardWidget({
    super.key,
    required this.service,
    this.onViewDetails,
    this.onMaps,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
=======
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
>>>>>>> zoz
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          ClipRRect(
<<<<<<< HEAD
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
=======
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
>>>>>>> zoz
            child: service.image != null && service.image!.isNotEmpty
                ? Image.network(
                    service.image!,
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.cover,
<<<<<<< HEAD
                    errorBuilder: (context, error, stackTrace) =>
                        const ServicePlaceholderImageWidget(),
                  )
                : const ServicePlaceholderImageWidget(),
          ),

=======
                    errorBuilder: (context, error, stackTrace) {
                      return const ServicePlaceholderImageWidget();
                    },
                  )
                : const ServicePlaceholderImageWidget(),
          ),
          
>>>>>>> zoz
          // Service Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                // Name & Status
=======
                // Service Name and Status
>>>>>>> zoz
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: AppTextStyles.blackS16W600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ServiceStatusIndicatorWidget(isOpen: service.openNow),
                  ],
                ),
<<<<<<< HEAD

                SizedBox(height: 8.h),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.gray, size: 16.sp),
=======
                
                SizedBox(height: 8.h),
                
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.gray,
                      size: 16.sp,
                    ),
>>>>>>> zoz
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        '${service.city} - ${service.address}',
                        style: AppTextStyles.secondaryS14W400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD

                SizedBox(height: 4.h),

                // Operating Hours
                Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.gray, size: 16.sp),
=======
                
                SizedBox(height: 4.h),
                
                // Operating Hours
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.gray,
                      size: 16.sp,
                    ),
>>>>>>> zoz
                    SizedBox(width: 4.w),
                    Text(
                      service.openingText,
                      style: AppTextStyles.secondaryS14W400,
                    ),
                  ],
                ),
<<<<<<< HEAD

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    // View Details
=======
                
                SizedBox(height: 16.h),
                
                // Action Buttons
                Row(
                  children: [
                    // View Details Button
>>>>>>> zoz
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onViewDetails,
                        icon: Icon(Icons.visibility, size: 16.sp),
                        label: Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
<<<<<<< HEAD

                    SizedBox(width: 8.w),

                    // Maps
=======
                    
                    SizedBox(width: 8.w),
                    
                    // Maps Button
>>>>>>> zoz
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onMaps,
                        icon: Icon(Icons.map, size: 16.sp),
                        label: Text('Maps'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
<<<<<<< HEAD

                    SizedBox(width: 8.w),

=======
                    
                    SizedBox(width: 8.w),
                    
>>>>>>> zoz
                    // Call Button
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.gray.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: onCall,
<<<<<<< HEAD
                        icon: Icon(Icons.phone,
                            color: AppColors.gray, size: 20.sp),
=======
                        icon: Icon(
                          Icons.phone,
                          color: AppColors.gray,
                          size: 20.sp,
                        ),
>>>>>>> zoz
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
=======


>>>>>>> zoz
}
