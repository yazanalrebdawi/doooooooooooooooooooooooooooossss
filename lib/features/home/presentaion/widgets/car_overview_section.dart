import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class CarOverviewSection extends StatelessWidget {
  final String carName;
  final double price;
  final bool isNew;
  final String location;
  final String mileage;

  const CarOverviewSection({
    super.key,
    required this.carName,
    required this.price,
    required this.isNew,
    required this.location,
    required this.mileage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Name
          Text(
            carName,
            style: AppTextStyles.s18w700.copyWith(
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Price
          Text(
            '${price.toStringAsFixed(0)} USD',
            style: AppTextStyles.s22w700.copyWith(
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Key Attributes
          Row(
            children: [
              // New Badge
              if (isNew) ...[
                _buildAttributeItem(
                  icon: Icons.star,
                  text: 'New',
                  iconColor: AppColors.primary,
                ),
                SizedBox(width: 16.w),
              ],
              
              // Location
              _buildAttributeItem(
                icon: Icons.location_on,
                text: location,
                iconColor: AppColors.gray,
              ),
              SizedBox(width: 16.w),
              
              // Mileage
              _buildAttributeItem(
                icon: Icons.directions_car,
                text: mileage,
                iconColor: AppColors.gray,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeItem({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: iconColor,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTextStyles.s12w400.copyWith(
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }
}
