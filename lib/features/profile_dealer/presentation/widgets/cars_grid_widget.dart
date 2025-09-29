import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import '../../../home/data/models/car_model.dart';
import 'car_grid_item.dart';
import '../../../../core/constants/text_styles.dart';
=======
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../home/data/models/car_model.dart';
import 'car_grid_item.dart';
>>>>>>> zoz

class CarsGridWidget extends StatelessWidget {
  final List<CarModel> cars;

  const CarsGridWidget({
    super.key,
    required this.cars,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey.withOpacity(0.2);
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? Colors.grey[400] : Colors.grey;

=======
>>>>>>> zoz
    return Column(
      children: [
        // Filter Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
<<<<<<< HEAD
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: borderColor,
=======
            border: Border(
              bottom: BorderSide(
                color: AppColors.gray.withOpacity(0.2),
>>>>>>> zoz
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
<<<<<<< HEAD
                  color: isDark ? Colors.grey[800] : Colors.grey.withOpacity(0.1),
=======
                  color: AppColors.gray.withOpacity(0.1),
>>>>>>> zoz
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Categories',
                      style: AppTextStyles.s14w400.copyWith(
<<<<<<< HEAD
                        color: textColor,
=======
                        color: AppColors.black,
>>>>>>> zoz
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
<<<<<<< HEAD
                      color: iconColor,
=======
                      color: AppColors.gray,
>>>>>>> zoz
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Filter Icon
              Icon(
                Icons.filter_list,
                size: 24.sp,
<<<<<<< HEAD
                color: iconColor,
=======
                color: AppColors.gray,
>>>>>>> zoz
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
