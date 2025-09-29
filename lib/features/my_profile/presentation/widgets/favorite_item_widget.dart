import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/widgets/lazy_loading_widget.dart';
import 'package:dooss_business_app/core/widgets/base/custom_cached_image_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_button_widget.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';

class FavoriteItemWidget extends StatelessWidget {
  final FavoriteModel favItem;
  final VoidCallback onDelete;
  final VoidCallback onDetails;

  const FavoriteItemWidget({
    super.key,
    required this.favItem,
    required this.onDelete,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final String name = favItem.target.name;
    final String category = favItem.target.category;
    final String brand = favItem.target.brand;
    final String model = favItem.target.model;
    final String image = favItem.target.mainImage;
    final String price = favItem.target.price;

    return ContainerBaseWidget(
      height: 322,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: LazyLoadingWidget(
                  builder:
                      () => CustomCachedImage(
                        appImage: image,
                        height: 192,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                  placeholder: Container(
                    height: 192.h,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Material(
                  elevation: 4,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: onDelete,
                    child: SizedBox(
                      height: 40.h,
                      width: 28.25.w,
                      child: Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.s18w700.copyWith(
                      color: const Color(0xff111827),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "$category  $brand ${model.isNotEmpty ? " $model" : ""
                            " $model ${brand.isNotEmpty ? " $brand" : ""}"} ",
                    style: AppTextStyles.s14w400.copyWith(
                      color: const Color(0xff4B5563),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: AppTextStyles.s20w700.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      CustomButtonWidget(
                        width: 126.375,
                        textStyle: AppTextStyles.s14w500.copyWith(
                          color: AppColors.buttonText,
                        ),
                        height: 40,
                        text: "View Details",
                        onPressed: onDetails,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
