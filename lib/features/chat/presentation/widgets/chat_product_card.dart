import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../features/home/presentaion/manager/product_cubit.dart';
import '../../../../features/home/presentaion/manager/product_state.dart';

class ChatProductCard extends StatelessWidget {
  final int productId;

  const ChatProductCard({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
              final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => di.sl<ProductCubit>()..loadProductDetails(productId),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, productState) {
          final product = productState.selectedProduct;

=======
    return BlocProvider(
      create: (context) => di.appLocator<ProductCubit>()..loadProductDetails(productId),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, productState) {
          final product = productState.selectedProduct;
          
>>>>>>> zoz
          if (product == null) {
            return Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.gray.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Loading product details...',
                      style: AppTextStyles.s14w500.copyWith(
<<<<<<< HEAD
                          color:isDark ?Colors.white : AppColors.gray,
=======
                        color: AppColors.gray,
>>>>>>> zoz
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: product.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.car_repair,
                                color: AppColors.primary,
                                size: 24.sp,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.car_repair,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                ),
                SizedBox(width: 12.w),
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
<<<<<<< HEAD
                        style: AppTextStyles.s14w500.withThemeColor(context),
=======
                        style: AppTextStyles.s14w500.copyWith(
                          color: AppColors.black,
                        ),
>>>>>>> zoz
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Price: \$${product.finalPrice.toStringAsFixed(2)}',
                        style: AppTextStyles.s16w600.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Location: ${product.locationText.isNotEmpty ? product.locationText : 'Unknown'}',
                        style: AppTextStyles.s12w400.copyWith(
<<<<<<< HEAD
                          color:isDark ?Colors.white : AppColors.gray,
=======
                          color: AppColors.gray,
>>>>>>> zoz
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to product details
                        context.push('/product-details/${product.id}');
                      },
                      child: Container(
<<<<<<< HEAD
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
=======
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
>>>>>>> zoz
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          'View Details',
                          style: AppTextStyles.s12w400.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    IconButton(
                      onPressed: () {
<<<<<<< HEAD
=======
                        
>>>>>>> zoz
                        print('Dismiss product card');
                      },
                      icon: Icon(
                        Icons.close,
<<<<<<< HEAD
                          color:isDark ?Colors.white : AppColors.gray,
=======
                        color: AppColors.gray,
>>>>>>> zoz
                        size: 16.sp,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
