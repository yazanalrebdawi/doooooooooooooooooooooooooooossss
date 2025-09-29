import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';

class DealerProfileTabs extends StatelessWidget {
  final TabController tabController;
  final int currentIndex;
  final Function(int) onTabChanged;

  const DealerProfileTabs({
    super.key,
    required this.tabController,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.gray.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.gray,
        labelStyle: AppTextStyles.s14w500,
        unselectedLabelStyle: AppTextStyles.s14w400,
        tabs: [
          // Reels Tab
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 20.sp,
                  color: currentIndex == 0 ? AppColors.primary : AppColors.gray,
                ),
                SizedBox(width: 8.w),
                Text('Reels'),
              ],
            ),
          ),
          // Cars Tab
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: 20.sp,
                  color: currentIndex == 1 ? AppColors.primary : AppColors.gray,
                ),
                SizedBox(width: 8.w),
                Text('Cars'),
              ],
            ),
          ),
          // Services Tab
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.build_outlined,
                  size: 20.sp,
                  color: currentIndex == 2 ? AppColors.primary : AppColors.gray,
                ),
                SizedBox(width: 8.w),
                Text('Services'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
