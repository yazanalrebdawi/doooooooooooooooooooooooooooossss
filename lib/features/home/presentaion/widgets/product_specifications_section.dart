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
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specifications',
            style: AppTextStyles.s18w700,
          ),
          SizedBox(height: 16.h),
          
          _buildSpecificationItem('Material', 'ABS Plastic'),
          _buildSpecificationItem('Color', 'Red/Clear'),
          _buildSpecificationItem('Size', '45 × 20 × 15 cm'),
          _buildSpecificationItem('Weight', '1.2 kg'),
        ],
      ),
    );
  }

  Widget _buildSpecificationItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: AppTextStyles.s14w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
            ),
          ),
        ],
      ),
    );
  }
}
