import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import 'package:dooss_business_app/features/home/data/models/product_model.dart';

class AllProductsCard extends StatelessWidget {
  final ProductModel product;

  const AllProductsCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 173.w,
      height: 240.h,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          _buildImage(isDark),
          _buildContent(context, isDark),
        ],
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.r),
        topRight: Radius.circular(12.r),
      ),
      child: Container(
        width: 173.w,
        height: 128.h,
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : AppColors.gray.withOpacity(0.2),
        child: product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    color: isDark ? Colors.white70 : AppColors.gray,
                    size: 48.sp,
                  );
                },
              )
            : Icon(
                Icons.image,
                color: isDark ? Colors.white70 : AppColors.gray,
                size: 48.sp,
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Container(
      width: 173.w,
      height: 112.h, // 240 - 128 = 112
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(context, isDark),
          _buildPrice(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: AppTextStyles.blackS16W600.withThemeColor(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          product.description.isNotEmpty
              ? product.description
              : 'Premium Quality',
          style: AppTextStyles.s14w400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Text(
      '\$${product.price}',
      style: AppTextStyles.primaryS16W700,
    );
  }
}
