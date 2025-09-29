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
    return GestureDetector(
      onTap: () {
        context.push('${RouteNames.productDetailsScreen}/${product.id}');
      },
      child: Container(
        width: AppDimensions.productCardWidth.w,
        height: AppDimensions.productCardHeight.h, // Fixed height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
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
            _buildImage(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.defaultBorderRadius.r),
        topRight: Radius.circular(AppDimensions.defaultBorderRadius.r),
      ),
      child: Container(
        width: double.infinity,
        height: AppDimensions.productCardImageHeight.h,
        color: AppColors.gray.withOpacity(0.2),
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

    Widget _buildContent() {
    return Container(
      width: AppDimensions.productCardWidth.w,
      height: AppDimensions.productCardContentHeight.h,
      padding: EdgeInsets.all(AppDimensions.defaultPadding.r),
      color: AppColors.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildDescription(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceAndLocation(),
              SizedBox(height: AppDimensions.defaultPadding2.h),
              _buildActionButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      product.name,
      style: AppTextStyles.blackS16W600,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description,
      style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${product.price}',
          style: AppTextStyles.blackS18W700,
        ),
        Text(
          product.location.isNotEmpty ? product.location : 'Dubai',
          style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
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
                style: AppTextStyles.s14w500.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }


} 