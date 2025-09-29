import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class BrandSelector extends StatelessWidget {
  final String selectedBrand;
  final Function(String) onBrandSelected;

  const BrandSelector({
    super.key,
    required this.selectedBrand,
    required this.onBrandSelected,
  });

  @override
  Widget build(BuildContext context) {
    final brands = [
      {'name': 'Toyota', 'logo': 'assets/images/toyota_logo.png'},
      {'name': 'BMW', 'logo': 'assets/images/bmw_logo.png'},
      {'name': 'Nissan', 'logo': 'assets/images/nissan_logo.png'},
      {'name': 'VOLVO', 'logo': 'assets/images/volvo_logo.png'},
      {'name': 'Volkswagen', 'logo': 'assets/images/volkswagen_logo.png'},
    ];

    return SizedBox(
      height: 131.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isSelected = selectedBrand == brand['name'];
          
          return GestureDetector(
            onTap: () => onBrandSelected(brand['name']!),
            child: Container(
              width: 64.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
                                     Container(
                     width: 64.w,
                     height: 64.h,
                     decoration: BoxDecoration(
                       color: AppColors.white,
                       borderRadius: BorderRadius.circular(12.r),
                       border: Border.all(
                         color: isSelected ? AppColors.primary : AppColors.borderBrand,
                         width: 1,
                       ),
                     ),
                    child: Center(
                      child: Image.asset(
                        brand['logo']!,
                        width: 48.w,
                        height: 48.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    brand['name']!,
                    style: AppTextStyles.s12w400.copyWith(
                      color: AppColors.gray,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
