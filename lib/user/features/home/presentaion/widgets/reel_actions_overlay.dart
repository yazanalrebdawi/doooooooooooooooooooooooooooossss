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
  final bool? isMuted;
  const ReelActionsOverlay({
    super.key,
    required this.reel,
    this.onLike,
    this.onShare,
    this.onComment, 
     this.isMuted =false,
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
            isDark: isDark,
            icon: reel.liked ? Icons.favorite : Icons.favorite_border,
            label: _formatCount(reel.likesCount),
            onTap: onLike,
            iconColor: reel.liked
                ? Colors.red
                : (isDark ? AppColors.white : AppColors.black),
          ),
          SizedBox(height: 24.h),
          _buildActionButton(
            isDark: isDark,
            icon: Icons.visibility,
            label: _formatCount(reel.viewsCount),
            onTap: onComment,
            iconColor: isDark ? AppColors.white : AppColors.black,
            imageIcon:'assets/images/seen.png'
            
          ),
          SizedBox(height: 24.h),
          _buildActionButton(
            // icon: Icons.share,
            isDark: isDark,
            onTap: onShare,
            iconColor: isDark ? AppColors.white : AppColors.black,
            icon: isMuted==true ? Icons.volume_off : Icons.volume_up,
            label: isMuted==true  ? 'Unmute' : 'Mute',
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
    String? imageIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: imageIcon != null
                ? Padding(
                  padding:  EdgeInsets.all(12.r),
                  child: Image.asset(
                      imageIcon,
                      width: 20,
                    ),
                )
                : Icon(icon, color: iconColor, size: 24.sp),
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
