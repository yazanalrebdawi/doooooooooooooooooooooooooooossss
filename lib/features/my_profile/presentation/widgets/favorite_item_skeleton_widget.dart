import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteItemSkeletonWidget extends StatelessWidget {
  const FavoriteItemSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 322.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.primary.withOpacity(0.15),
            highlightColor: AppColors.primary.withOpacity(0.05),
            child: Container(
              height: 192.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // ✨ مهم لتجنب flex غير محدد
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.primary.withOpacity(0.15),
                  highlightColor: AppColors.primary.withOpacity(0.05),
                  child: Container(
                    height: 20.h,
                    width: 150.w,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: AppColors.primary.withOpacity(0.15),
                  highlightColor: AppColors.primary.withOpacity(0.05),
                  child: Container(
                    height: 16.h,
                    width: 100.w,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.primary.withOpacity(0.15),
                      highlightColor: AppColors.primary.withOpacity(0.05),
                      child: Container(
                        height: 20.h,
                        width: 60.w,
                        color: Colors.grey[300],
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: AppColors.primary.withOpacity(0.15),
                      highlightColor: AppColors.primary.withOpacity(0.05),
                      child: Container(
                        height: 36.h,
                        width: 117.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
