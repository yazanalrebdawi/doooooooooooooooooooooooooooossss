import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/product_model.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<ProductModel> relatedProducts;

  const RelatedProductsSection({
    super.key,
    required this.relatedProducts,
  });

  @override
  Widget build(BuildContext context) {
    if (relatedProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Products',
            style: AppTextStyles.s18w700,
          ),
          SizedBox(height: 16.h),
          
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return Container(
                  width: 150.w,
                  margin: EdgeInsets.only(right: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          width: 150.w,
                          height: 120.h,
                          color: AppColors.gray.withOpacity(0.1),
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image,
                                      color: AppColors.gray,
                                      size: 32.sp,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.image,
                                  color: AppColors.gray,
                                  size: 32.sp,
                                ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      
                      // Product Name
                      Text(
                        product.name,
                        style: AppTextStyles.s14w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      
                      // Product Price
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.s14w500.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
