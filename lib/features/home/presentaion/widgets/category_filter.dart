import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    final categories = [
      'All',
      'Spare Parts',
      'Electronics',
      'Tools',
      'Car Care',
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
<<<<<<< HEAD

=======
          
>>>>>>> zoz
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: isSelected
                    ? AppColors.primary
                    : isDark
                        ? Colors.white12
                        : AppColors.gray.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : isDark
                          ? Colors.white24
                          : AppColors.gray.withOpacity(0.3),
=======
                color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
>>>>>>> zoz
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.s14w500.copyWith(
<<<<<<< HEAD
                    color: isSelected
                        ? AppColors.white
                        : isDark
                            ? Colors.white
                            : AppColors.black,
=======
                    color: isSelected ? AppColors.white : AppColors.black,
>>>>>>> zoz
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
