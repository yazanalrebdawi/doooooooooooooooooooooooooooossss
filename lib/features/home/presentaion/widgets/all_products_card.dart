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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Container(
      width: 173.w,
      height: 240.h,
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.1),
=======
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
>>>>>>> zoz
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
          _buildContent(context, isDark),
=======
          _buildImage(),
          _buildContent(),
>>>>>>> zoz
        ],
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
        topLeft: Radius.circular(12.r),
        topRight: Radius.circular(12.r),
      ),
<<<<<<< HEAD
      child: Container(
        width: 173.w,
        height: 128.h,
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : AppColors.gray.withOpacity(0.2),
=======
             child: Container(
         width: 173.w,
         height: 128.h,
        color: AppColors.gray.withOpacity(0.2),
>>>>>>> zoz
        child: product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
<<<<<<< HEAD
                    color: isDark ? Colors.white70 : AppColors.gray,
=======
                    color: AppColors.gray,
>>>>>>> zoz
                    size: 48.sp,
                  );
                },
              )
            : Icon(
                Icons.image,
<<<<<<< HEAD
                color: isDark ? Colors.white70 : AppColors.gray,
=======
                color: AppColors.gray,
>>>>>>> zoz
                size: 48.sp,
              ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildContent(BuildContext context, bool isDark) {
    return Container(
      width: 173.w,
      height: 112.h, // 240 - 128 = 112
=======
  Widget _buildContent() {
         return Container(
       width: 173.w,
       height: 112.h, // 240 - 128 = 112
>>>>>>> zoz
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
<<<<<<< HEAD
          _buildTitle(context, isDark),
=======
          _buildTitle(),
>>>>>>> zoz
          _buildPrice(),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTitle(BuildContext context, bool isDark) {
=======
  Widget _buildTitle() {
>>>>>>> zoz
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
<<<<<<< HEAD
          style: AppTextStyles.blackS16W600.withThemeColor(context),
=======
          style: AppTextStyles.blackS16W600,
>>>>>>> zoz
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
<<<<<<< HEAD
          product.description.isNotEmpty
              ? product.description
              : 'Premium Quality',
          style: AppTextStyles.s14w400.copyWith(
            color: isDark ? Colors.white70 : AppColors.gray,
          ),
=======
          product.description.isNotEmpty ? product.description : 'Premium Quality',
          style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
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
