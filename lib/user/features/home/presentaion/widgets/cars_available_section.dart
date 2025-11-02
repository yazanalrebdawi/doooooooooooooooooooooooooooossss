import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/features/home/data/models/car_model.dart';
import 'package:go_router/go_router.dart';
import 'empty_cars_section_widget.dart';
import 'car_card_widget.dart';

class CarsAvailableSection extends StatelessWidget {
  final List<CarModel> cars;
  final VoidCallback? onViewAllPressed;
  final VoidCallback? onCarPressed;

  const CarsAvailableSection({
    super.key,
    required this.cars,
    this.onViewAllPressed,
    this.onCarPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cars Available Now',
                style: AppTextStyles.blackS18W700.copyWith(
                  color: isDark ? Colors.white : AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: onViewAllPressed,
                child: Text(
                  'View All',
                  style: AppTextStyles.primaryS16W600.copyWith(
                    color: isDark
                        ? AppColors.primary.withOpacity(0.8)
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Cars List
        cars.isEmpty
            ? const EmptyCarsSectionWidget()
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cars.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return CarCardWidget(
                    car: cars[index],
                    onTap: () {
                      log('✅ Image URL for: ${cars[index].imageUrl}');

                      context.push('/car-details/${cars[index].id}');
                    },
                  );
                }),
      ],
    );
  }
}
