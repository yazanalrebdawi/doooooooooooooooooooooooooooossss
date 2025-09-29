import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/filter_button.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/product_card.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/empty_section.dart';
import 'package:dooss_business_app/features/home/data/models/product_model.dart';

class ProductsSection extends StatelessWidget {
  final List<ProductModel> products;

  const ProductsSection({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
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
                'Car Products',
<<<<<<< HEAD
                style: AppTextStyles.blackS18W700.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
=======
                style: AppTextStyles.blackS18W700,
>>>>>>> zoz
              ),
              GestureDetector(
                onTap: () {
                  context.push(RouteNames.allProductsScreen);
                },
                child: Text(
                  'View All',
<<<<<<< HEAD
                  style: AppTextStyles.primaryS16W600.copyWith(
                    color: isDark ? AppColors.primary : AppColors.primary,
                  ),
=======
                  style: AppTextStyles.primaryS16W600,
>>>>>>> zoz
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Filter Buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              FilterButton(text: 'All', isActive: true),
              SizedBox(width: 8.w),
              FilterButton(text: 'Rims', isActive: false),
              SizedBox(width: 8.w),
              FilterButton(text: 'Screens', isActive: false),
              SizedBox(width: 8.w),
              FilterButton(text: 'Lighting', isActive: false),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Products List
        products.isEmpty 
<<<<<<< HEAD
          ? _buildEmptySection(isDark)
=======
          ? _buildEmptySection()
>>>>>>> zoz
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => ProductCard(product: products[index]),
            ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildEmptySection(bool isDark) {
=======
  Widget _buildEmptySection() {
>>>>>>> zoz
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(
            Icons.inventory_2_outlined,
<<<<<<< HEAD
            color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
=======
            color: AppColors.gray,
>>>>>>> zoz
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No products available',
<<<<<<< HEAD
            style: AppTextStyles.blackS16W600.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
=======
            style: AppTextStyles.blackS16W600,
>>>>>>> zoz
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new products',
<<<<<<< HEAD
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
            ),
=======
            style: AppTextStyles.secondaryS14W400,
>>>>>>> zoz
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
