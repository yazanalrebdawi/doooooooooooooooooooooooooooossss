import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.gray.withOpacity(0.1),
            width: 1,
          ),
        ),
        color: isDark ? Colors.black : Colors.white,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Home'),
              _buildNavItem(context, 1, Icons.build, 'Services'),
              _buildNavItem(context, 2, Icons.play_circle_outline, 'Reels'),
              _buildNavItem(context, 3, Icons.chat_bubble_outline, 'Messages'),
              _buildNavItem(context, 4, Icons.person_outline, 'Account'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = AppColors.primary;
    final defaultColor = isDark ? Colors.white : AppColors.gray;
    final color = isSelected ? selectedColor : defaultColor;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.s12w400.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
