import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/routes/route_names.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    // Responsive card width
    // On small screens (vertical list), use full width minus padding
    // On larger screens (horizontal scroll), use fixed width
    final cardWidth = isSmallScreen
        ? screenWidth - 32.w  // Full width minus padding for vertical list
        : screenWidth < 600
            ? 280.w  // Fixed width for medium screens (horizontal)
            : 330.w; // Fixed width for large screens (horizontal)
    
    // Calculate responsive card height - adjust aspect ratio for better fit
    // Use slightly taller aspect ratio to accommodate content
    final cardHeight = cardWidth * 1.12; // Increased from 1.085 to 1.12

    return Container(
      width: cardWidth,
      constraints: BoxConstraints(
        minHeight: cardHeight,
        maxHeight: double.infinity, // Allow card to grow if needed
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.black : Colors.white,
        borderRadius:
            BorderRadius.circular(AppDimensions.defaultBorderRadius.r),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              context.push('${RouteNames.productDetailsScreen}/${product.id}');
            },
            child: _buildImage(context, isDark),
          ),
          Flexible(child: _buildContent(context, isDark)),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    // Calculate responsive card width (same as in build method)
    final cardWidth = isSmallScreen
        ? screenWidth - 32.w
        : screenWidth < 600
            ? 280.w
            : 330.w;
    
    // Calculate responsive image height (approximately 55% of card height for more content space)
    final cardHeight = cardWidth * 1.12;
    final imageHeight = cardHeight * 0.55; // Image takes ~55% of card height (reduced from 60%)
    
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.defaultBorderRadius.r),
        topRight: Radius.circular(AppDimensions.defaultBorderRadius.r),
      ),
      child: Container(
        width: double.infinity,
        height: imageHeight,
        color: isDark
            ? AppColors.gray.withOpacity(0.3)
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
                  color: AppColors.gray,
                  size: 48.sp,
                ),
                memCacheWidth: 400, // Limit image resolution for memory
                memCacheHeight: 400,
              )
            : Icon(
                Icons.image,
                color: AppColors.gray,
                size: 48.sp,
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    
    // Calculate responsive card width (same as in build method)
    final cardWidth = isSmallScreen
        ? screenWidth - 32.w
        : screenWidth < 600
            ? 280.w
            : 330.w;
    
    // Responsive padding - reduce on smaller screens
    final padding = isSmallScreen ? 12.0.r : AppDimensions.defaultPadding.r;
    final spacing = isSmallScreen ? 6.0.h : AppDimensions.smallPadding.h;
    final spacing2 = isSmallScreen ? 8.0.h : AppDimensions.defaultPadding2.h;
    
    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(padding),
      color: isDark ? AppColors.black : AppColors.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(isDark, isSmallScreen),
                SizedBox(height: spacing),
                _buildDescription(isDark, isSmallScreen),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPriceAndLocation(isDark, isSmallScreen),
              SizedBox(height: spacing2),
              _buildActionButtons(context, isDark, isSmallScreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isDark, bool isSmallScreen) {
    return Text(
      product.name,
      style: (isSmallScreen 
          ? AppTextStyles.blackS14W600 
          : AppTextStyles.blackS16W600).copyWith(
        color: isDark ? AppColors.white : AppColors.black,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(bool isDark, bool isSmallScreen) {
    return Text(
      product.description,
      style: (isSmallScreen
          ? AppTextStyles.s12w400
          : AppTextStyles.s14w400).copyWith(
        color: AppColors.gray,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndLocation(bool isDark, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '\$${product.price}',
            style: (isSmallScreen
                ? AppTextStyles.blackS16W600
                : AppTextStyles.blackS18W700).copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            product.location.isNotEmpty ? product.location : 'Dubai',
            style: (isSmallScreen
                ? AppTextStyles.s12w400
                : AppTextStyles.s14w400).copyWith(color: AppColors.gray),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark, bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        context.push('${RouteNames.productDetailsScreen}/${product.id}');
      },
      child: Container(
        width: double.infinity,
        height: isSmallScreen ? 36.h : 38.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)?.translate('viewDetails') ??
                'View Details',
            style: (isSmallScreen
                ? AppTextStyles.s12w600
                : AppTextStyles.s14w500).copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
