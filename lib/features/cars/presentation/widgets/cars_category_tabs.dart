import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../manager/cubits/cars_cubit.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';

class CarsCategoryTabs extends StatelessWidget {
  const CarsCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsState>(
      builder: (context, state) {
        return SizedBox(
          height: 24.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final category = state.categories[index];
              final isSelected = category == state.selectedCategory;
              return GestureDetector(
                onTap: () => context.read<CarsCubit>().selectCategory(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.black,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.translate(category.replaceAll(' ', '').toLowerCase()) ?? category,
                    style: AppTextStyles.appBarTextStyleBlackS12W400.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 