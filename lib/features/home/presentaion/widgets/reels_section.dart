import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/reel_card.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/empty_section.dart';
import 'package:dooss_business_app/features/home/data/models/reel_model.dart';

class ReelsSection extends StatelessWidget {
  final List<ReelModel> reels;
  final VoidCallback? onViewAllPressed;
  final VoidCallback? onReelPressed;

  const ReelsSection({
    super.key,
    required this.reels,
    this.onViewAllPressed,
    this.onReelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market Reels',
                style: AppTextStyles.blackS18W700,
              ),
              GestureDetector(
                onTap: onViewAllPressed,
                child: Text(
                  'View All',
                  style: AppTextStyles.primaryS16W600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Reels List
          if (reels.isEmpty)
            EmptySection(message: 'No reels available')
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: reels.map((reel) => ReelCard(
                  reel: reel,
                  onTap: onReelPressed,
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
