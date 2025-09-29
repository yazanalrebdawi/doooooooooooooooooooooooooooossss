import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class NearbyServicesFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const NearbyServicesFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [AppLocalizations.of(context)!.translate('all'), AppLocalizations.of(context)!.translate('mechanics'), AppLocalizations.of(context)!.translate('petrol'), AppLocalizations.of(context)!.translate('openNow')];
    
         return Container(
       height: 45.h,
       margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
       child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: Container(
                                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                 decoration: BoxDecoration(
                   color: isSelected ? AppColors.primary : AppColors.white,
                   borderRadius: BorderRadius.circular(20.r),
                   border: Border.all(
                     color: isSelected ? AppColors.primary : AppColors.gray.withOpacity(0.3),
                     width: 1,
                   ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Text(
                  filter,
                  style: AppTextStyles.secondaryS14W400.copyWith(
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14.sp,
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
