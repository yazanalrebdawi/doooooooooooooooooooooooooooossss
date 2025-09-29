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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
<<<<<<< HEAD
        shadowColor: isDark
            ? Colors.black.withOpacity(0.4)
            : AppColors.cardShadow,
        elevation: 2,
        color: isDark ? const Color(0xFF2A2A2A) : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
=======
        shadowColor: AppColors.cardShadow,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
>>>>>>> zoz
        ),
        child: Column(
          children: [
            _buildImage(),
<<<<<<< HEAD
            _buildContent(context, isDark),
=======
            _buildContent(),
>>>>>>> zoz
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
<<<<<<< HEAD
                fit: BoxFit.cover,
                image: AssetImage(AppAssets.bmwM3),
              ),
=======
          fit: BoxFit.cover,
          image: AssetImage(AppAssets.bmwM3),
        ),
>>>>>>> zoz
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildContent(BuildContext context, bool isDark) {
=======
  Widget _buildContent() {
>>>>>>> zoz
    return Container(
      width: AppDimensions.availableCardWidth.w,
      height: AppDimensions.availableCardContentHeight.h,
      padding: EdgeInsets.all(AppDimensions.defaultPadding.r),
<<<<<<< HEAD
      color: isDark ? const Color(0xFF2A2A2A) : AppColors.cardBackground,
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
              _buildTitle(context, isDark),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildPrice(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildRating(context, isDark),
            ],
          ),
          _buildDetails(context, isDark),
=======
              _buildTitle(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildPrice(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildRating(),
            ],
          ),
          _buildDetails(),
>>>>>>> zoz
          SizedBox(height: AppDimensions.smallPadding.h),
          _buildViewDetailsButton(),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTitle(BuildContext context, bool isDark) {
    return Text(
      '${car.brand} ${car.name}',
      style: AppTextStyles.blackS14W500.withThemeColor(context),
=======
  Widget _buildTitle() {
    return Text(
      '${car.brand} ${car.name}',
      style: AppTextStyles.blackS14W500,
>>>>>>> zoz
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

<<<<<<< HEAD
  Widget _buildRating(BuildContext context, bool isDark) {
=======
  Widget _buildRating() {
>>>>>>> zoz
    return Row(
      children: [
        Icon(
          Icons.star,
          color: AppColors.ratingStarColor,
<<<<<<< HEAD
          size: AppDimensions.smallIconSize.r,
=======
          size: AppDimensions.smallIconSize.r
>>>>>>> zoz
        ),
        SizedBox(width: AppDimensions.tinyPadding.w),
        Text(
          '4.5', // Default rating
<<<<<<< HEAD
          style: AppTextStyles.ratingS12W400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
=======
          style: AppTextStyles.ratingS12W400,
>>>>>>> zoz
        ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildDetails(BuildContext context, bool isDark) {
=======
  Widget _buildDetails() {
>>>>>>> zoz
    return Row(
      children: [
        Text(
          '${car.mileage} • ${car.transmission}',
<<<<<<< HEAD
          style: AppTextStyles.ratingS12W400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
=======
          style: AppTextStyles.ratingS12W400,
>>>>>>> zoz
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
<<<<<<< HEAD
}
=======
} 
>>>>>>> zoz
