import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:dooss_business_app/user/features/home/data/models/car_model.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        shadowColor:
            isDark ? Colors.black.withOpacity(0.4) : AppColors.cardShadow,
        elevation: 2,
        color: isDark ? const Color(0xFF2A2A2A) : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
        ),
        child: Column(
          children: [
            _buildImage(),
            _buildContent(context, isDark),
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
            ? CachedNetworkImage(
                imageUrl: car.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  AppAssets.bmwM3,
                  fit: BoxFit.cover,
                ),
                memCacheWidth: 400, // Limit image resolution for memory
                memCacheHeight: 400,
              )
            : Image.asset(
                AppAssets.bmwM3,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Container(
      width: AppDimensions.availableCardWidth.w,
      height: AppDimensions.availableCardContentHeight.h,
      padding: EdgeInsets.all(AppDimensions.defaultPadding.r),
      color: isDark ? const Color(0xFF2A2A2A) : AppColors.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context, isDark),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildPrice(),
              SizedBox(height: AppDimensions.smallPadding.h),
              _buildRating(context, isDark),
            ],
          ),
          _buildDetails(context, isDark),
          SizedBox(height: AppDimensions.smallPadding.h),
          _buildViewDetailsButton(context),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isDark) {
    return Text(
      '${car.brand} ${car.name}',
      style: AppTextStyles.blackS14W500.withThemeColor(context),
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

  Widget _buildRating(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: AppColors.ratingStarColor,
          size: AppDimensions.smallIconSize.r,
        ),
        SizedBox(width: AppDimensions.tinyPadding.w),
        Text(
          '4.5', // Default rating
          style: AppTextStyles.ratingS12W400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, bool isDark) {
    return Row(
      children: [
        Text(
          '${car.mileage} • ${car.transmission}',
          style: AppTextStyles.ratingS12W400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(
        child: Text(
          AppLocalizations.of(context)?.translate('viewDetails') ??
              'View Details',
          style: AppTextStyles.s12w400.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
