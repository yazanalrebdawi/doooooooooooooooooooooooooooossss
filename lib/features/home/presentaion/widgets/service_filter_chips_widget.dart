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
    
    return Container(
      height: 50.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: FilterChip(
              label: Text(
                filter,
                style: AppTextStyles.secondaryS14W400.copyWith(
                  color: isSelected ? AppColors.white : AppColors.gray,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onFilterChanged(filter);
              },
              backgroundColor: AppColors.gray.withOpacity(0.1),
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
