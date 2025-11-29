import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import 'package:dooss_business_app/user/features/home/data/models/product_model.dart';

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
        color: isDark ? const Color(0xFF2A2A2A) : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(isDark),
          _buildContent(isDark),
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
            ? CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image,
                  color: isDark ? Colors.white70 : AppColors.gray,
                  size: 48.sp,
                ),
                memCacheWidth: 350, // Limit image resolution for memory
                memCacheHeight: 350,
              )
            : Icon(
                Icons.image,
                color: isDark ? Colors.white70 : AppColors.gray,
                size: 48.sp,
              ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Container(
      width: 173.w,
      height: 112.h, // 240 - 128 = 112
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle(isDark),
          _buildPrice(),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: AppTextStyles.blackS16W600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          product.description.isNotEmpty ? product.description : 'Premium Quality',
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
