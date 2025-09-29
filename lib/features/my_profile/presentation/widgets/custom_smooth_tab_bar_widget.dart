import 'dart:developer';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/home/presentaion/pages/car_details_screen.dart';
import 'package:dooss_business_app/features/home/presentaion/pages/product_details_screen.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/favorite_item_skeleton_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/favorite_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:go_router/go_router.dart';

class CustomSmoothTabBarWidget extends StatefulWidget {
  const CustomSmoothTabBarWidget({super.key});

  @override
  State<CustomSmoothTabBarWidget> createState() =>
      _CustomSmoothTabBarWidgetState();
}

class _CustomSmoothTabBarWidgetState extends State<CustomSmoothTabBarWidget> {
  final List<String> tabs = ["All Items", "Cars", "Accessories", "Recent"];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MyProfileCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 6.h),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final bool isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.field,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.translate(tabs[index]) ??
                        tabs[index],

                    style: AppTextStyles.s14w500.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color:
                          isSelected ? Colors.white : const Color(0xff374151),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 8.h),
        Divider(color: AppColors.borderBrand, thickness: 1, height: 0.h),
        BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) {
            List<FavoriteModel> favoritesToShow = [];

            switch (selectedIndex) {
              case 0:
                favoritesToShow = state.listFavorites ?? [];
                break;
              case 1:
                favoritesToShow =
                    context.read<MyProfileCubit>().filterCarsFavorites();
                break;
              case 2:
                favoritesToShow =
                    context.read<MyProfileCubit>().filterAccessoriesFavorites();
                break;
              case 3:
                favoritesToShow =
                    context.read<MyProfileCubit>().filterRecentFavorites();
                break;
            }

            if (state.statusGetListFavorites == ResponseStatusEnum.loading) {
              return Expanded(
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (_, __) => const FavoriteItemSkeletonWidget(),
                ),
              );
            }

            if (state.statusGetListFavorites == ResponseStatusEnum.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: Colors.red),
                    SizedBox(height: 16.h),
                    Text(
                      state.errorGetListFavorites ?? 'Something went wrong',
                      style: AppTextStyles.s16w500.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (favoritesToShow.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 80.h),
                    Icon(
                      Icons.bookmark_border,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(
                            context,
                          )?.translate("No items in this tab yet") ??
                          "No items in this tab yet",
                      style: AppTextStyles.s16w500.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 100.h),
                    CustomButtonWidget(
                      width: 300,
                      height: 40,
                      text: "Refresh",
                      onPressed: () async {
                        context.read<MyProfileCubit>().getFavorites();
                      },
                    ),
                  ],
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: favoritesToShow.length,
                itemBuilder: (context, index) {
                  final favItem = favoritesToShow[index];
                  return FavoriteItemWidget(
                    favItem: favItem,
                    onDelete: () async {
                      log('Deleting favoriteId : ${favItem.id}');
                      log('Deleting targetId : ${favItem.target.id}');
                      await context.read<MyProfileCubit>().deleteFavorite(
                        favItem.id,
                      );
                      await context.read<MyProfileCubit>().getFavorites();
                    },
                    onDetails: () {
                      if (favItem.targetType == "product") {
                        // context.pushNamed(
                        //   RouteNames.productDetailsScreen,
                        //   pathParameters: {'id': favItem.targetId.toString()},
                        // );
                        context.push('/product-details/${favItem.targetId}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductDetailsScreen(
                                  productId: favItem.targetId,
                                ),
                          ),
                        );
                      } else {
                        // context.pushNamed(
                        //   'carDetailsScreen', // الاسم مو path
                        //   pathParameters: {'id': favItem.targetId.toString()},
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CarDetailsScreen(carId: favItem.targetId),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
