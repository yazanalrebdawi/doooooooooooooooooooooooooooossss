import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/product_model.dart';

class ProductSpecificationsSection extends StatelessWidget {
  final ProductModel product;

  const ProductSpecificationsSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      color: isDark ? AppColors.darkCard : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: AppTextStyles.s18w700.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          if (product.material.isNotEmpty)
            _buildSpecificationItem('Material', product.material, isDark),
          if (product.color.isNotEmpty)
            _buildSpecificationItem('Color', product.color, isDark),
          if (product.warranty.isNotEmpty)
            _buildSpecificationItem('Warranty', product.warranty, isDark),
          if (product.installationInfo.isNotEmpty)
            _buildSpecificationItem(
                'Installation', product.installationInfo, isDark),
          if (product.condition.isNotEmpty)
            _buildSpecificationItem('Condition', product.condition, isDark),
        ],
      ),
    );
  }

  Widget _buildSpecificationItem(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: AppTextStyles.s14w500.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.s14w400.copyWith(
                color:
                    isDark ? AppColors.gray.withOpacity(0.8) : AppColors.gray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
