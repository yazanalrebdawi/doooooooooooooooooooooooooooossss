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
                'Car Products',
                style: AppTextStyles.blackS18W700.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(RouteNames.allProductsScreen);
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.primaryS16W600.copyWith(
                    color: isDark ? AppColors.primary : AppColors.primary,
                  ),
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
          ? _buildEmptySection(isDark)
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

  Widget _buildEmptySection(bool isDark) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(
            Icons.inventory_2_outlined,
            color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No products available',
            style: AppTextStyles.blackS16W600.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new products',
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
