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
<<<<<<< HEAD
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Positioned(
      right: 16.w,
      bottom: 100.h,
      child: Column(
        children: [
          _buildActionButton(
            icon: reel.liked ? Icons.favorite : Icons.favorite_border,  
            label: _formatCount(reel.likesCount),
            onTap: onLike,
<<<<<<< HEAD
            iconColor: reel.liked ? Colors.red : (isDark ? AppColors.white : AppColors.black),
            isDark: isDark,
=======
            iconColor: reel.liked ? Colors.red : AppColors.white,
>>>>>>> zoz
          ),
          SizedBox(height: 24.h),
          _buildActionButton(
            icon: Icons.comment,
            label: _formatCount(reel.likesCount),
            onTap: onComment,
<<<<<<< HEAD
            iconColor: isDark ? AppColors.white : AppColors.black,
            isDark: isDark,
=======
>>>>>>> zoz
          ),
          SizedBox(height: 24.h),
          _buildActionButton(
            icon: Icons.share,
            label: 'Share',
            onTap: onShare,
<<<<<<< HEAD
            iconColor: isDark ? AppColors.white : AppColors.black,
            isDark: isDark,
=======
>>>>>>> zoz
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
<<<<<<< HEAD
    required bool isDark,
=======
>>>>>>> zoz
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
<<<<<<< HEAD
              color: isDark ? AppColors.darkCard.withOpacity(0.3) : AppColors.white.withOpacity(0.3),
=======
              color: AppColors.black.withOpacity(0.3),
>>>>>>> zoz
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
<<<<<<< HEAD
            style: isDark
                ? AppTextStyles.whiteS12W400
                : AppTextStyles.blackS12W400,
=======
            style: AppTextStyles.whiteS12W400,
>>>>>>> zoz
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
<<<<<<< HEAD
}
=======
}
>>>>>>> zoz
