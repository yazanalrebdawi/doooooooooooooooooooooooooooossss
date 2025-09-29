import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      color: isDark ? AppColors.darkCard : Colors.transparent,
=======
    return Container(
      padding: EdgeInsets.all(16.w),
>>>>>>> zoz
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product.name,
<<<<<<< HEAD
            style: AppTextStyles.s20w500.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
=======
            style: AppTextStyles.s20w500,
>>>>>>> zoz
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          
          // Price and New Tag
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
<<<<<<< HEAD
                style: AppTextStyles.s22w500.copyWith(
                  color: AppColors.primary,
                ),
=======
                style: AppTextStyles.s22w500.copyWith(color: AppColors.primary),
>>>>>>> zoz
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'New',
                  style: AppTextStyles.s12w400.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Availability and Category
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '5 units available',
<<<<<<< HEAD
                      style: AppTextStyles.s14w400.copyWith(
                        color: isDark ? AppColors.gray.withOpacity(0.8) : AppColors.gray,
                      ),
=======
                      style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Spare Parts',
<<<<<<< HEAD
                      style: AppTextStyles.s14w400.copyWith(
                        color: isDark ? AppColors.gray.withOpacity(0.8) : AppColors.gray,
                      ),
=======
                      style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
