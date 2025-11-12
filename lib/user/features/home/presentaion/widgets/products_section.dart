import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/filter_button.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/product_card.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/product_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/product_state.dart';
import 'package:dooss_business_app/user/features/home/data/models/product_model.dart';

class ProductsSection extends StatefulWidget {
  final List<ProductModel> products;

  const ProductsSection({
    super.key,
    required this.products,
  });

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) =>
          previous.filteredProducts != current.filteredProducts ||
          previous.categories != current.categories ||
          previous.selectedCategory != current.selectedCategory,
      builder: (context, state) {
        // Get categories from state, or use default if empty
        final categories = state.categories.isNotEmpty
            ? state.categories
            : ['Rims', 'Screens', 'Lighting'];

        // Sync selected filter with state
        if (state.selectedCategory != _selectedFilter &&
            state.selectedCategory != 'All') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedFilter = state.selectedCategory;
              });
            }
          });
        }

        // Use filtered products from state if filter is active, otherwise use widget.products
        final displayProducts = _selectedFilter == 'All'
            ? widget.products
            : (state.filteredProducts.isNotEmpty
                ? state.filteredProducts
                    .take(10)
                    .toList() // Limit to 10 for home section
                : widget.products
                    .where((product) =>
                        product.category.toLowerCase() ==
                        _selectedFilter.toLowerCase())
                    .toList());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate('carProducts') ??
                        'Car Products',
                    style: AppTextStyles.blackS18W700.copyWith(
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(RouteNames.allProductsScreen);
                    },
                    child: Text(
                      AppLocalizations.of(context)?.translate('viewAll') ??
                          'View All',
                      style: AppTextStyles.primaryS16W600.copyWith(
                        color: isDark ? AppColors.primary : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Filter Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  FilterButton(
                    text: 'All',
                    isActive: _selectedFilter == 'All',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'All';
                      });
                      context.read<ProductCubit>().filterByCategory('All');
                    },
                  ),
                  ...categories.map((category) => Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: FilterButton(
                          text: category,
                          isActive: _selectedFilter == category,
                          onTap: () {
                            setState(() {
                              _selectedFilter = category;
                            });
                            context
                                .read<ProductCubit>()
                                .filterByCategory(category);
                          },
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Products List
            displayProducts.isEmpty
                ? _buildEmptySection(context, isDark)
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayProducts.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) =>
                        ProductCard(product: displayProducts[index]),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildEmptySection(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(
            Icons.inventory_2_outlined,
            color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)?.translate('noProductsAvailable') ??
                'No products available',
            style: AppTextStyles.blackS16W600.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)
                    ?.translate('checkBackLaterForNewProducts') ??
                'Check back later for new products',
            style: AppTextStyles.secondaryS14W400.copyWith(
              color: isDark ? AppColors.gray.withOpacity(0.7) : AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
