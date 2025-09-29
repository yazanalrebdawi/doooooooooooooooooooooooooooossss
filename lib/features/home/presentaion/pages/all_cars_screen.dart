import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/car_cubit.dart';
import '../manager/car_state.dart';
import '../widgets/see_all_cars_card.dart';
import '../widgets/brand_selector.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/all_cars_header_widget.dart';
import '../manager/car_cubit.dart';
import '../manager/car_state.dart';
import '../widgets/see_all_cars_card.dart';
import '../widgets/brand_selector.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/all_cars_header_widget.dart';

class AllCarsScreen extends StatelessWidget {
  const AllCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => di.sl<CarCubit>()..loadAllCars(),
      child: Scaffold(
=======
    return BlocProvider(
      create: (_) => di.appLocator<CarCubit>()..loadAllCars(),
      child: Scaffold(
        backgroundColor: AppColors.white,
>>>>>>> zoz
        appBar: const SearchAppBar(
          title: 'All Cars',
        ),
        body: BlocBuilder<CarCubit, CarState>(
<<<<<<< HEAD
          buildWhen: (previous, current) =>
=======
          buildWhen: (previous, current) => 
>>>>>>> zoz
              previous.cars != current.cars ||
              previous.allCars != current.allCars ||
              previous.selectedBrand != current.selectedBrand ||
              previous.currentPage != current.currentPage ||
              previous.hasMoreCars != current.hasMoreCars ||
              previous.isLoadingMore != current.isLoadingMore ||
              previous.isLoading != current.isLoading ||
              previous.error != current.error ||
<<<<<<< HEAD
              previous.hasMoreCars != current.hasMoreCars,
=======
              previous.hasMoreCars != current.hasMoreCars ,
>>>>>>> zoz
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
<<<<<<< HEAD
                      color: isDark ? Colors.white : AppColors.gray,
=======
                      color: AppColors.gray,
>>>>>>> zoz
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading cars',
<<<<<<< HEAD
                      style: AppTextStyles.s16w500.copyWith(
                          color: isDark ? Colors.white : AppColors.gray),
=======
                      style: AppTextStyles.s16w500.copyWith(color: AppColors.gray),
>>>>>>> zoz
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.error!,
<<<<<<< HEAD
                      style: AppTextStyles.s14w400.copyWith(
                          color: isDark ? Colors.white : AppColors.gray),
=======
                      style: AppTextStyles.s14w400.copyWith(color: AppColors.gray),
>>>>>>> zoz
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  const AllCarsHeaderWidget(),
<<<<<<< HEAD

=======
                  
>>>>>>> zoz
                  // Brand Selector
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: BrandSelector(
                      selectedBrand: state.selectedBrand,
                      onBrandSelected: (brand) {
                        context.read<CarCubit>().filterByBrand(brand);
                      },
                    ),
                  ),
<<<<<<< HEAD

                  SizedBox(height: 16.h),

=======
                  
                  SizedBox(height: 16.h),
                  
>>>>>>> zoz
                  // Cars List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.cars.length + (state.hasMoreCars ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Load More Item
                      if (index == state.cars.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Center(
                            child: state.isLoadingMore
<<<<<<< HEAD
                                ? CircularProgressIndicator(
                                    color: AppColors.primary)
=======
                                ? CircularProgressIndicator(color: AppColors.primary)
>>>>>>> zoz
                                : ElevatedButton(
                                    onPressed: () {
                                      context.read<CarCubit>().loadMoreCars();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                    ),
                                    child: Text('Load More Cars'),
                                  ),
                          ),
                        );
                      }
<<<<<<< HEAD

                      // Car Item
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
=======
                      
                      // Car Item
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
>>>>>>> zoz
                        child: SeeAllCarsCard(
                          car: state.cars[index],
                          onTap: () {
                            // Navigate to car details
<<<<<<< HEAD
                            context
                                .push('/car-details/${state.cars[index].id}');
=======
                            context.push('/car-details/${state.cars[index].id}');
>>>>>>> zoz
                          },
                        ),
                      );
                    },
                  ),
<<<<<<< HEAD

=======
                  
>>>>>>> zoz
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
