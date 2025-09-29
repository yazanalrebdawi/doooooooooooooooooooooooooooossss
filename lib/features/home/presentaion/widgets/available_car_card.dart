import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/dimensions.dart';
import 'package:dooss_business_app/features/home/data/models/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/text_styles.dart';

class AvailableCarCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const AvailableCarCard({
    Key? key,
    required this.car,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        shadowColor: AppColors.cardShadow,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
        ),
        child: Column(
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
      child: SizedBox(
        width: AppDimensions.availableCardWidth.w,
        height: AppDimensions.availableCardImageHeight.h,
        child: car.imageUrl.isNotEmpty
            ? Image.network(
                car.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image(
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.bmwM3),
                  );
                },
              )
            : Image(
          fit: BoxFit.cover,
          image: AssetImage(AppAssets.bmwM3),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: AppDimensions.availableCardWidth.w,
      height: AppDimensions.availableCardContentHeight.h,
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
              _buildPrice(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildRating(),
            ],
          ),
          _buildDetails(),
          SizedBox(height: AppDimensions.smallPadding.h),
          _buildViewDetailsButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      '${car.brand} ${car.name}',
      style: AppTextStyles.blackS14W500,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPrice() {
    return Text(
      '\$${car.price}',
      style: AppTextStyles.primaryS14W700,
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: AppColors.ratingStarColor,
          size: AppDimensions.smallIconSize.r
        ),
        SizedBox(width: AppDimensions.tinyPadding.w),
        Text(
          '4.5', // Default rating
          style: AppTextStyles.ratingS12W400,
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Row(
      children: [
        Text(
          '${car.mileage} • ${car.transmission}',
          style: AppTextStyles.ratingS12W400,
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton() {
    return Container(
      width: double.infinity,
      height: 32.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Text(
          'View Details',
          style: AppTextStyles.s12w400.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
} 