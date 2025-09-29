import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/routes/route_names.dart';
import 'package:dooss_business_app/features/home/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return GestureDetector(
      onTap: () {
        context.push('${RouteNames.productDetailsScreen}/${product.id}');
      },
      child: Container(
        width: AppDimensions.productCardWidth.w,
        height: AppDimensions.productCardHeight.h, // Fixed height
        decoration: BoxDecoration(
<<<<<<< HEAD
          color: isDark ? AppColors.black : AppColors.white,
          borderRadius:
              BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
=======
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
>>>>>>> zoz
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            _buildImage(isDark),
            _buildContent(isDark),
=======
            _buildImage(),
            _buildContent(),
>>>>>>> zoz
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildImage(bool isDark) {
=======
  Widget _buildImage() {
>>>>>>> zoz
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.defaultBorderRadius.r),
        topRight: Radius.circular(AppDimensions.defaultBorderRadius.r),
      ),
      child: Container(
        width: double.infinity,
        height: AppDimensions.productCardImageHeight.h,
<<<<<<< HEAD
        color: isDark
            ? AppColors.gray.withOpacity(0.3)
            : AppColors.gray.withOpacity(0.2),
=======
        color: AppColors.gray.withOpacity(0.2),
>>>>>>> zoz
        child: product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    color: AppColors.gray,
                    size: 48.sp,
                  );
                },
              )
            : Icon(
                Icons.image,
                color: AppColors.gray,
                size: 48.sp,
              ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildContent(bool isDark) {
=======
    Widget _buildContent() {
>>>>>>> zoz
    return Container(
      width: AppDimensions.productCardWidth.w,
      height: AppDimensions.productCardContentHeight.h,
      padding: EdgeInsets.all(AppDimensions.defaultPadding.r),
<<<<<<< HEAD
      color: isDark ? AppColors.black : AppColors.white,
=======
      color: AppColors.cardBackground,
>>>>>>> zoz
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              _buildTitle(isDark),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildDescription(isDark),
=======
              _buildTitle(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildDescription(),
>>>>>>> zoz
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              _buildPriceAndLocation(isDark),
              SizedBox(height: AppDimensions.defaultPadding2.h),
              _buildActionButtons(isDark),
=======
              _buildPriceAndLocation(),
              SizedBox(height: AppDimensions.defaultPadding2.h),
              _buildActionButtons(),
>>>>>>> zoz
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTitle(bool isDark) {
    return Text(
      product.name,
      style: AppTextStyles.blackS16W600.copyWith(
        color: isDark ? AppColors.white : AppColors.black,
      ),
=======
  Widget _buildTitle() {
    return Text(
      product.name,
      style: AppTextStyles.blackS16W600,
>>>>>>> zoz
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

<<<<<<< HEAD
  Widget _buildDescription(bool isDark) {
    return Text(
      product.description,
      style: AppTextStyles.s14w400.copyWith(
        color: AppColors.gray,
      ),
=======
  Widget _buildDescription() {
    return Text(
      product.description,
      style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

<<<<<<< HEAD
  Widget _buildPriceAndLocation(bool isDark) {
=======
  Widget _buildPriceAndLocation() {
>>>>>>> zoz
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${product.price}',
<<<<<<< HEAD
          style: AppTextStyles.blackS18W700.copyWith(
            color: isDark ? AppColors.white : AppColors.black,
          ),
=======
          style: AppTextStyles.blackS18W700,
>>>>>>> zoz
        ),
        Text(
          product.location.isNotEmpty ? product.location : 'Dubai',
          style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
        ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildActionButtons(bool isDark) {
=======
  Widget _buildActionButtons() {
>>>>>>> zoz
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 38.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'View Details',
                style: AppTextStyles.s14w500.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            height: 38.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Contact Seller',
<<<<<<< HEAD
                style: AppTextStyles.s14w500.copyWith(
                  color: isDark ? AppColors.black : AppColors.white,
                ),
=======
                style: AppTextStyles.s14w500.copyWith(color: Colors.white),
>>>>>>> zoz
              ),
            ),
          ),
        ),
      ],
    );
  }
<<<<<<< HEAD
}
=======


} 
>>>>>>> zoz
