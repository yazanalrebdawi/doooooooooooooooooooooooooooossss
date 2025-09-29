import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../home/data/models/car_model.dart';
import 'car_grid_item.dart';

class CarsGridWidget extends StatelessWidget {
  final List<CarModel> cars;

  const CarsGridWidget({
    super.key,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.gray.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // All Categories Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.gray.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Categories',
                      style: AppTextStyles.s14w400.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
                      color: AppColors.gray,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Filter Icon
              Icon(
                Icons.filter_list,
                size: 24.sp,
                color: AppColors.gray,
              ),
            ],
          ),
        ),
        // Cars Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.8,
            ),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              return CarGridItem(car: cars[index]);
            },
          ),
        ),
      ],
    );
  }
}
