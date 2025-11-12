import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/car_model.dart';
import 'car_spec_item_widget.dart';

class CarCardWidget extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const CarCardWidget({
    super.key,
    required this.car,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.1),
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
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _placeholderImage(isDark);
                    },
                  )
                : _placeholderImage(isDark),
          ),
          // Car Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Name and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        car.name,
                        style: AppTextStyles.blackS16W600.copyWith(
                          color: isDark ? Colors.white : AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${car.price.toStringAsFixed(0)}',
                      style: AppTextStyles.primaryS16W600,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Car Specs
                Row(
                  children: [
                    CarSpecItemWidget(
                      text: '${car.year}',
                      icon: Icons.calendar_today,
                    ),
                    SizedBox(width: 16.w),
                    CarSpecItemWidget(
                      text: car.mileage,
                      icon: Icons.speed,
                    ),
                    SizedBox(width: 16.w),
                    CarSpecItemWidget(
                      text: car.fuelType,
                      icon: Icons.local_gas_station,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Location and Details Button
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: isDark ? Colors.white70 : AppColors.gray,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        car.location,
                        style: AppTextStyles.secondaryS14W400.copyWith(
                          color: isDark ? Colors.white70 : AppColors.gray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Details Button
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.translate('details') ??
                            'Details',
                        style: AppTextStyles.s14w500
                            .copyWith(color: AppColors.white),
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

  Widget _placeholderImage(bool isDark) {
    return Container(
      width: double.infinity,
      height: 192.h,
      color: isDark ? Colors.white12 : AppColors.gray.withOpacity(0.2),
      child: Icon(
        Icons.directions_car,
        color: isDark ? Colors.white54 : AppColors.gray,
        size: 48.sp,
      ),
    );
  }
}
