import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class ServiceFilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ServiceFilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Mechanics', 'Petrol Stations', 'Open Now'];

    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return FilterChip(
            label: Text(
              filter,
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: isSelected ? AppColors.white : AppColors.gray,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onFilterChanged(filter),
            backgroundColor: AppColors.gray.withOpacity(0.1),
            selectedColor: AppColors.primary,
            checkmarkColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
          );
        },
      ),
    );
  }
}
