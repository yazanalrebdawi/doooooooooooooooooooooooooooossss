import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../manager/reels_playback_cubit.dart';
import '../manager/reels_playback_state.dart';
import '../widgets/perfect_video_player.dart';
import '../widgets/reel_gesture_detector.dart';
import '../widgets/reel_controls_overlay.dart';
import '../widgets/reel_actions_overlay.dart';
import '../widgets/reel_info_overlay.dart';

/// Full-screen reels viewer with vertical swipe navigation
/// Seamless transition from home screen reel preview
class FullScreenReelsViewer extends StatelessWidget {
  const FullScreenReelsViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.appLocator<ReelsPlaybackCubit>(), // Use existing cubit instance
      child: const _FullScreenReelsContent(),
    );
  }
}

class _FullScreenReelsContent extends StatefulWidget {
  const _FullScreenReelsContent();

  @override
  State<_FullScreenReelsContent> createState() =>
      _FullScreenReelsContentState();
}

class _FullScreenReelsContentState extends State<_FullScreenReelsContent> {
  late PageController _pageController;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();

    final currentIndex = context.read<ReelsPlaybackCubit>().state.currentIndex;
    _pageController = PageController(initialPage: currentIndex);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReelsPlaybackCubit>().resumeWithSound();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    context.read<ReelsPlaybackCubit>().exitFullScreen();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocBuilder<ReelsPlaybackCubit, ReelsPlaybackState>(
        buildWhen:
            (previous, current) =>
                previous.reels != current.reels ||
                previous.currentIndex != current.currentIndex ||
                previous.isLoading != current.isLoading ||
                previous.error != current.error,
        builder: (context, state) {
          if (state.isLoading && state.reels.isEmpty) {
            return _buildLoadingState();
          }

          if (state.error != null && state.reels.isEmpty) {
            return _buildErrorState(context, state.error!);
          }

          if (state.reels.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildReelsPageView(context, state);
        },
      ),
    );
  }

  Widget _buildReelsPageView(BuildContext context, ReelsPlaybackState state) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: state.reels.length,
          onPageChanged: (index) => _onPageChanged(context, index),
          itemBuilder:
              (context, index) => _buildReelPage(context, state, index),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16.h,
          left: 16.w,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),
          ),
        ),
        if (state.isLoading && state.reels.isNotEmpty)
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Loading more reels...',
                      style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReelPage(
    BuildContext context,
    ReelsPlaybackState state,
    int index,
  ) {
    final reel = state.reels[index];
    final isCurrentReel = index == state.currentIndex;

    return Stack(
      children: [
        ReelGestureDetector(
          onTap: () => _toggleControls(),
          child: PerfectVideoPlayer(isCurrentVideo: isCurrentReel),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.black.withOpacity(0.3),
                  AppColors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 0.8, 1.0],
              ),
            ),
          ),
        ),
        ReelInfoOverlay(reel: reel),
        ReelActionsOverlay(
          reel: reel,
          onLike: () => _handleLike(context, reel),
          onShare: () => _handleShare(context, reel),
          onComment: () => _handleComment(context, reel),
        ),
        if (_showControls && isCurrentReel)
          ReelControlsOverlay(
            showControls: _showControls,
            onToggleControls: _toggleControls,
          ),
      ],
    );
  }

  Widget _buildLoadingState() =>
      const Center(child: CircularProgressIndicator(color: AppColors.white));

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.white, size: 64.sp),
          SizedBox(height: 16.h),
          Text(
            'Failed to load reels',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.7),
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.read<ReelsPlaybackCubit>().loadReels(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            color: AppColors.white,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No reels available',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new content',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.7),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(BuildContext context, int index) {
    final cubit = context.read<ReelsPlaybackCubit>();
    cubit.changeToIndex(index);

    if (index >= cubit.state.reels.length - 3 &&
        cubit.state.hasNextPage &&
        !cubit.state.isLoading) {
      cubit.loadReels(page: cubit.state.currentPage + 1);
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);

    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showControls = false);
      });
    }
  }

  void _handleLike(BuildContext context, reel) =>
      print('🤍 Like reel: ${reel.id}');
  void _handleShare(BuildContext context, reel) =>
      print('📤 Share reel: ${reel.id}');
  void _handleComment(BuildContext context, reel) =>
      print('💬 Comment on reel: ${reel.id}');
}
