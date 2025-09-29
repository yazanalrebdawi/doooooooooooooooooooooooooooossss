import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../home/data/models/car_model.dart';
import '../../../../core/constants/text_styles.dart';

class CarGridItem extends StatelessWidget {
  final CarModel car;

  const CarGridItem({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Dynamic colors
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final cardShadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05);
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final priceColor = Colors.blueAccent; // keep primary or theme color

    return GestureDetector(
      onTap: () {
        context.push('/car-details/${car.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: cardShadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  color: isDark ? Colors.grey[800] : Colors.grey.withOpacity(0.1),
                ),
                child: car.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                        child: Image.network(
                          car.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.directions_car,
                              size: 48.sp,
                              color: secondaryTextColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.directions_car,
                        size: 48.sp,
                        color: secondaryTextColor,
                      ),
              ),
            ),
            // Car Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car Name
                    Text(
                      car.name,
                      style: AppTextStyles.s14w500.copyWith(
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    // Price and Availability Row
                    Row(
                      children: [
                        Text(
                          'AED ${car.price.toStringAsFixed(0)}',
                          style: AppTextStyles.s16w600.copyWith(
                            color: priceColor,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16.sp,
                              color: priceColor,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Available',
                              style: AppTextStyles.s12w400.copyWith(
                                color: priceColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Rating
                    Row(
                      children: [
                        Text(
                          '4.5',
                          style: AppTextStyles.s12w400.copyWith(
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < 4) {
                              return Icon(
                                Icons.star,
                                size: 12.sp,
                                color: Colors.amber,
                              );
                            } else {
                              return Icon(
                                Icons.star_half,
                                size: 12.sp,
                                color: Colors.amber,
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
