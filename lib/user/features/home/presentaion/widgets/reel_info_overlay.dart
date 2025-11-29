import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../core/services/native_video_service.dart';
import '../../data/models/reel_model.dart';
import '../manager/reels_playback_cubit.dart';

class ReelInfoOverlay extends StatelessWidget {
  final ReelModel reel;

  const ReelInfoOverlay({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      right: 80.w, // Leave space for actions
      bottom: 30.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dealer info
          InkWell(
            onTap: () async {
              // AGGRESSIVE: Stop video sound in EVERY possible way before navigating
              await _stopVideoSoundAggressively(context);
              
              // Small delay to ensure everything stops
              await Future.delayed(Duration(milliseconds: 200));
              
              // Navigate to dealer profile when tapped (using pushReplacement)
              if (context.mounted) {
                log("Navigating to dealer profile");
                context.pushReplacement(
                    '/dealer-profile/${reel.dealer.toString()}?handle=${reel.dealerName ?? ''}');
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    (reel.dealerName != null && reel.dealerName!.isNotEmpty)
                        ? reel.dealerName![0].toUpperCase()
                        : 'U',
                    style: AppTextStyles.whiteS14W600,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  reel.dealerName ?? 'Unknown User',
                  style: AppTextStyles.whiteS14W600,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Reel title and description
          Text(
            reel.title,
            style: AppTextStyles.whiteS16W600,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (reel.description != null && reel.description!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              reel.description!,
              style: AppTextStyles.whiteS14W400,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 8.h),
          // Tags or metadata (views and created at)
          Row(
            children: [
              // Icon(Icons.visibility, color: AppColors.white.withOpacity(0.7), size: 16.sp),
              // SizedBox(width: 4.w),
              // Text(
              //   _formatCount(reel.viewsCount),
              //   style: AppTextStyles.whiteS12W400.copyWith(color: AppColors.white.withOpacity(0.7)),
              // ),
              // SizedBox(width: 16.w),
              Icon(Icons.schedule,
                  color: AppColors.white.withOpacity(0.7), size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                _formatDate(reel.createdAt),
                style: AppTextStyles.whiteS12W400
                    .copyWith(color: AppColors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// AGGRESSIVE: Stop video sound in EVERY FUCKING WAY POSSIBLE
  Future<void> _stopVideoSoundAggressively(BuildContext context) async {
    log("🔇 AGGRESSIVE: Starting to stop video sound...");
    
    // Method 1: Mute and stop NativeVideoService FIRST (most important!)
    try {
      await NativeVideoService.setVolume(0.0);
      await NativeVideoService.pause();
      await NativeVideoService.stop();
      log("✅ Method 1: NativeVideoService muted and stopped");
    } catch (e) {
      log("❌ Method 1 failed: $e");
    }
    
    // Method 2: Use ReelsPlaybackCubit methods
    try {
      final cubit = di.appLocator<ReelsPlaybackCubit>();
      await cubit.setMuted(true);
      await cubit.pause();
      await cubit.onNavigationAway();
      log("✅ Method 2: ReelsPlaybackCubit methods called");
    } catch (e) {
      log("❌ Method 2 failed: $e");
    }
    
    // Method 3: Try to get controller and stop it directly
    try {
      final cubit = di.appLocator<ReelsPlaybackCubit>();
      final state = cubit.state;
      final controller = state.controller;
      if (controller != null && controller.value.isInitialized) {
        await controller.setVolume(0.0);
        await controller.pause();
        log("✅ Method 3: Direct controller stop");
      }
    } catch (e) {
      log("❌ Method 3 failed: $e");
    }
    
    // Method 4: Multiple NativeVideoService mute/stop attempts
    for (int i = 0; i < 5; i++) {
      try {
        await NativeVideoService.setVolume(0.0);
        await NativeVideoService.pause();
        await NativeVideoService.stop();
        await Future.delayed(Duration(milliseconds: 50));
      } catch (e) {
        // Ignore errors, keep trying
      }
    }
    log("✅ Method 4: Multiple NativeVideoService stop attempts");
    
    log("🔇 AGGRESSIVE: Finished trying to stop video sound");
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}


