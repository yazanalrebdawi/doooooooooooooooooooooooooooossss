import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/colors.dart';
import '../manager/reels_playback_cubit.dart';
import '../manager/reels_playback_state.dart';

/// Perfect aspect ratio video player with no cropping or distortion
class PerfectVideoPlayer extends StatefulWidget {
  final bool isCurrentVideo;
  final VoidCallback? onTap;

  const PerfectVideoPlayer({
    super.key,
    required this.isCurrentVideo,
    this.onTap,
  });

  @override
  State<PerfectVideoPlayer> createState() => _PerfectVideoPlayerState();
}

class _PerfectVideoPlayerState extends State<PerfectVideoPlayer> {
  @override
  void dispose() {
    print('🗑️ PerfectVideoPlayer: Disposing video player widget');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsPlaybackCubit, ReelsPlaybackState>(
      buildWhen: (previous, current) =>
          previous.controller != current.controller ||
          previous.playbackState != current.playbackState ||
          previous.isLoading != current.isLoading ||
          previous.error != current.error,
      builder: (context, state) {
        if (!widget.isCurrentVideo || state.controller == null) {
          return _buildPlaceholder(state);
        }

        if (!state.isInitialized) {
          return _buildLoadingState();
        }

        return _buildVideoPlayer(state);
      },
    );
  }

  Widget _buildVideoPlayer(ReelsPlaybackState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final controller = state.controller!;
        final videoAspectRatio = controller.value.aspectRatio;
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final screenAspectRatio = screenWidth / screenHeight;

        return GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: _buildAspectRatioContainer(
                videoAspectRatio: videoAspectRatio,
                screenAspectRatio: screenAspectRatio,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAspectRatioContainer({
    required double videoAspectRatio,
    required double screenAspectRatio,
    required double screenWidth,
    required double screenHeight,
    required VideoPlayerController controller,
  }) {
    double containerWidth;
    double containerHeight;

    if (videoAspectRatio > screenAspectRatio) {
      containerHeight = screenHeight;
      containerWidth = containerHeight * videoAspectRatio;
    } else {
      containerWidth = screenWidth;
      containerHeight = containerWidth / videoAspectRatio;
    }

    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: AspectRatio(
        aspectRatio: videoAspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildPlaceholder(ReelsPlaybackState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.hasError) ...[
            Icon(
              Icons.error_outline,
              color: AppColors.primary,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Video Error',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.error ?? 'Unknown error',
              style: TextStyle(
                color: AppColors.primary.withOpacity(0.7),
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Icon(
              Icons.video_library,
              color: AppColors.primary.withOpacity(0.5),
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              state.currentReel?.title ?? 'No Video',
              style: TextStyle(
                color: AppColors.primary.withOpacity(0.7),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
