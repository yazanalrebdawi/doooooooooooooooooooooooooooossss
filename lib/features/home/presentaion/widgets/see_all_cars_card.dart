import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/car_model.dart';

class SeeAllCarsCard extends StatelessWidget {  
  final CarModel car;
  final VoidCallback? onTap;

  const SeeAllCarsCard({
    super.key,
    required this.car,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: car.imageUrl.isNotEmpty
                  ? Image.network(
                      car.imageUrl,
                      width: double.infinity,
                      height: 192.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 192.h,
                          color: AppColors.gray.withOpacity(0.2),
                          child: Icon(
                            Icons.directions_car,
                            size: 40.sp,
                            color: AppColors.gray,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 192.h,
                      color: AppColors.gray.withOpacity(0.2),
                      child: Icon(
                        Icons.directions_car,
                        size: 40.sp,
                        color: AppColors.gray,
                      ),
                    ),
            ),
            
            // Car Details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Name
                  Text(
                    car.name,
                    style: AppTextStyles.blackS16W600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Price
                  Text(
                    '\$${car.price.toStringAsFixed(0)}',
                    style: AppTextStyles.primaryS16W700,
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Mileage and Location
                  Row(
                    children: [
                      // Mileage
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 14.sp,
                              color: AppColors.gray,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                '${car.mileage} km',
                                style: AppTextStyles.secondaryS14W400,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: 16.w),
                      
                      // Location
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14.sp,
                              color: AppColors.gray,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                car.location,
                                style: AppTextStyles.secondaryS14W400,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // View Details Button
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          'View Details',
                          style: AppTextStyles.buttonS14W500,
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
}
