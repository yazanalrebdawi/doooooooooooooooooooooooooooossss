import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/product_cubit.dart';
import '../manager/product_state.dart';
import '../widgets/all_products_card.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/category_filter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/route_names.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => di.sl<ProductCubit>()..loadAllProducts(),
      child: Scaffold(
        appBar: const SearchAppBar(
          title: 'All Products',
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
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
                      color:isDark ? Colors.white : AppColors.gray,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading products',
                      style: AppTextStyles.s16w500.copyWith(                      color:isDark ? Colors.white : AppColors.gray,
),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.error!,
                      style: AppTextStyles.s14w400.copyWith(                      color:isDark ? Colors.white : AppColors.gray,
),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Count
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(
                    '${state.totalProductsCount} products',
                    style: AppTextStyles.s16w500.copyWith(                      color:isDark ? Colors.white : AppColors.gray,
),
                  ),
                ),
                
                // Category Filter
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: CategoryFilter(
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (category) {
                      context.read<ProductCubit>().filterByCategory(category);
                    },
                  ),
                ),
                
                                 // Products Grid
                 Expanded(
                   child: Column(
                     children: [
                       Expanded(
                         child: GridView.builder(
                           padding: EdgeInsets.all(16.w),
                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,
                             childAspectRatio: 173 / 240, // من الصورة
                             crossAxisSpacing: 12.w,
                             mainAxisSpacing: 12.h,
                           ),
                           itemCount: state.displayedProducts.length,
                           itemBuilder: (context, index) {
                             return GestureDetector(
                               onTap: () {
                                 // Navigate to product details
                                 final product = state.displayedProducts[index];
                                 print('Product tapped: ${product.name} with ID: ${product.id}');
                                 context.push('${RouteNames.productDetailsScreen}/${product.id}');
                               },
                               child: AllProductsCard(
                                 product: state.displayedProducts[index],
                               ),
                             );
                           },
                         ),
                       ),
                       // Load More Button
                       if (state.hasMoreProducts)
                         Padding(
                           padding: EdgeInsets.all(16.w),
                           child: SizedBox(
                             width: double.infinity,
                             height: 48.h,
                             child: ElevatedButton(
                               onPressed: state.isLoadingMore
                                   ? null
                                   : () {
                                       context.read<ProductCubit>().loadMoreProducts();
                                     },
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColors.primary,
                                 foregroundColor: AppColors.white,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(8.r),
                                 ),
                               ),
                               child: state.isLoadingMore
                                   ? SizedBox(
                                       width: 20.w,
                                       height: 20.h,
                                       child: CircularProgressIndicator(
                                         strokeWidth: 2,
                                         valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                       ),
                                     )
                                   : Text(
                                       'Load More Products',
                                       style: AppTextStyles.s16w600.copyWith(color: AppColors.white),
                                     ),
                             ),
                           ),
                         ),
                     ],
                   ),
                 ),
              ],
            );
          },
        ),
      ),
    );
  }
}
