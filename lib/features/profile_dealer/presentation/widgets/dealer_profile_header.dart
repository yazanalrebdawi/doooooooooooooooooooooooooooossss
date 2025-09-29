import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/dealer_model.dart';
import 'stat_item_widget.dart';

class DealerProfileHeader extends StatelessWidget {
  final DealerModel? dealer;
  final VoidCallback onFollowPressed;
  final VoidCallback onMessagePressed;

  const DealerProfileHeader({
    super.key,
    this.dealer,
    required this.onFollowPressed,
    required this.onMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.black;
    final secondaryTextColor = isDark ? Colors.grey[400]! : AppColors.gray;

=======
>>>>>>> zoz
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
<<<<<<< HEAD
                              color: secondaryTextColor,
=======
                              color: AppColors.gray,
>>>>>>> zoz
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40.sp,
<<<<<<< HEAD
                        color: secondaryTextColor,
=======
                        color: AppColors.gray,
>>>>>>> zoz
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
<<<<<<< HEAD
                            color: textColor,
=======
                            color: AppColors.black,
>>>>>>> zoz
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
<<<<<<< HEAD
                        color: secondaryTextColor,
=======
                        color: AppColors.gray,
>>>>>>> zoz
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Description
                    if (dealer!.description != null) ...[
                      Text(
                        dealer!.description!,
                        style: AppTextStyles.s14w400.copyWith(
<<<<<<< HEAD
                          color: textColor,
=======
                          color: AppColors.black,
>>>>>>> zoz
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    // Car emoji
                    Text(
                      '🚗',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
<<<<<<< HEAD
          // Statistics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatItemWidget(
                label: 'Reels',
                value: dealer!.reelsCount.toString(),
              ),
              SizedBox(width: 40.w),
              StatItemWidget(
                label: 'Followers',
                value: _formatNumber(dealer!.followersCount),
              ),
              SizedBox(width: 40.w),
              StatItemWidget(
                label: 'Following',
                value: dealer!.followingCount.toString(),
              ),
            ],
          ),
=======
                     // Statistics Row
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               StatItemWidget(
                 label: 'Reels',
                 value: dealer!.reelsCount.toString(),
               ),
               SizedBox(width: 40.w),
               StatItemWidget(
                 label: 'Followers',
                 value: _formatNumber(dealer!.followersCount),
               ),
               SizedBox(width: 40.w),
               StatItemWidget(
                 label: 'Following',
                 value: dealer!.followingCount.toString(),
               ),
             ],
           ),
>>>>>>> zoz
          SizedBox(height: 16.h),
          // Action Buttons Row
          Row(
            children: [
              // Following Button
              Expanded(
                child: GestureDetector(
                  onTap: onFollowPressed,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
<<<<<<< HEAD
                      color: dealer!.isFollowing
                          ? AppColors.gray.withOpacity(0.2)
                          : AppColors.primary,
=======
                      color: dealer!.isFollowing ? AppColors.gray.withOpacity(0.2) : AppColors.primary,
>>>>>>> zoz
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        dealer!.isFollowing ? 'Following' : 'Follow',
                        style: AppTextStyles.s14w500.copyWith(
<<<<<<< HEAD
                          color:
                              dealer!.isFollowing ? textColor : AppColors.white,
=======
                          color: dealer!.isFollowing ? AppColors.black : AppColors.white,
>>>>>>> zoz
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Message Button
              GestureDetector(
                onTap: onMessagePressed,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.gray.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
<<<<<<< HEAD
                    color: textColor,
=======
                    color: AppColors.black,
>>>>>>> zoz
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
=======
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.s18w700.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.s14w400.copyWith(
            color: AppColors.gray,
          ),
        ),
      ],
    );
  }

>>>>>>> zoz
  String _formatNumber(int number) {
    if (number >= 1000) {
      double k = number / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return number.toString();
  }
}
