import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/dealer_model.dart';
import 'stat_item_widget.dart';

class DealerProfileHeader extends StatelessWidget {
  final DealerModel? dealer;
  final VoidCallback onMessagePressed;

  const DealerProfileHeader({
    super.key,
    this.dealer,
    required this.onMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.black;
    final secondaryTextColor = isDark ? Colors.grey[400]! : AppColors.gray;

    if (dealer == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Profile Info Row
          Row(
            children: [
              // Profile Image
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gray.withOpacity(0.1),
                ),
                child: dealer?.profileImage != null
                    ? ClipOval(
                        child: Image.network(
                          dealer!.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 40.sp,
                              color: secondaryTextColor,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40.sp,
                        color: secondaryTextColor,
                      ),
              ),
              SizedBox(width: 16.w),
              // Profile Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with verification badge
                    Row(
                      children: [
                        Text(
                          dealer!.name,
                          style: AppTextStyles.s18w700.copyWith(
                            color: textColor,
                          ),
                        ),
                        if (dealer!.isVerified) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Handle
                    Text(
                      dealer!.handle,
                      style: AppTextStyles.s14w400.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Description
                    if (dealer!.description != null) ...[
                      Text(
                        dealer!.description!,
                        style: AppTextStyles.s14w400.copyWith(color: textColor),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    // Car Emoji
                    Text('🚗', style: TextStyle(fontSize: 16.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Statistics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatItemWidget(
                label: 'Reels',
                value: dealer!.reelsCount.toString(),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Message Button
          Center(
            child: GestureDetector(
              onTap: onMessagePressed,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Message',
                      style: AppTextStyles.s14w600.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
