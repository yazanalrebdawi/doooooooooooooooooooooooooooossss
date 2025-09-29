import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/reel_model.dart';

class ReelActionsOverlay extends StatelessWidget {
  final ReelModel reel;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final VoidCallback? onComment;

  const ReelActionsOverlay({
    super.key,
    required this.reel,
    this.onLike,
    this.onShare,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      right: 16.w,
      bottom: 100.h,
      child: Column(
        children: [
          _buildActionButton(
            icon: reel.liked ? Icons.favorite : Icons.favorite_border,  
            label: _formatCount(reel.likesCount),
            onTap: onLike,
            iconColor: reel.liked ? Colors.red : (isDark ? AppColors.white : AppColors.black),
            isDark: isDark,
          ),
          SizedBox(height: 24.h),
          _buildActionButton(
            icon: Icons.comment,
            label: _formatCount(reel.likesCount),
            onTap: onComment,
            iconColor: isDark ? AppColors.white : AppColors.black,
            isDark: isDark,
          ),
          SizedBox(height: 24.h),
          _buildActionButton(
            icon: Icons.share,
            label: 'Share',
            onTap: onShare,
            iconColor: isDark ? AppColors.white : AppColors.black,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color iconColor = Colors.white,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard.withOpacity(0.3) : AppColors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: isDark
                ? AppTextStyles.whiteS12W400
                : AppTextStyles.blackS12W400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}
