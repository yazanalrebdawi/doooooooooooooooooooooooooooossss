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
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
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
<<<<<<< HEAD

=======
          
>>>>>>> zoz
          return GestureDetector(
            onTap: () => onBrandSelected(brand['name']!),
            child: Container(
              width: 64.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
<<<<<<< HEAD
                  // Brand logo container
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? Colors.white24
                                : AppColors.borderBrand),
                        width: 1,
                      ),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
=======
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
>>>>>>> zoz
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
<<<<<<< HEAD
                  // Brand name
                  Text(
                    brand['name']!,
                    style: AppTextStyles.s12w400.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : AppColors.gray),
=======
                  Text(
                    brand['name']!,
                    style: AppTextStyles.s12w400.copyWith(
                      color: AppColors.gray,
>>>>>>> zoz
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
