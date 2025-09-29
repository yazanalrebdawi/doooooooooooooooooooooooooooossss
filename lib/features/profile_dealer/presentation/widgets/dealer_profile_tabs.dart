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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    final unselectedColor = isDark ? Colors.grey[400]! : AppColors.gray;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: unselectedColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        indicatorColor: primaryColor,
        indicatorWeight: 2,
        labelColor: primaryColor,
        unselectedLabelColor: unselectedColor,
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
                  color: currentIndex == 0 ? primaryColor : unselectedColor,
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
                  color: currentIndex == 1 ? primaryColor : unselectedColor,
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
                  color: currentIndex == 2 ? primaryColor : unselectedColor,
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
