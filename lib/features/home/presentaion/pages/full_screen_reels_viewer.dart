<<<<<<< HEAD
import 'package:dooss_business_app/core/constants/text_styles.dart';
=======
>>>>>>> zoz
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
<<<<<<< HEAD
      value: di.sl<ReelsPlaybackCubit>(), // Use existing cubit instance
=======
      value: di.appLocator<ReelsPlaybackCubit>(), // Use existing cubit instance
>>>>>>> zoz
      child: const _FullScreenReelsContent(),
    );
  }
}

class _FullScreenReelsContent extends StatefulWidget {
  const _FullScreenReelsContent();

  @override
  State<_FullScreenReelsContent> createState() => _FullScreenReelsContentState();
}

class _FullScreenReelsContentState extends State<_FullScreenReelsContent> {
  late PageController _pageController;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize page controller with current index
    final currentIndex = context.read<ReelsPlaybackCubit>().state.currentIndex;
    _pageController = PageController(initialPage: currentIndex);
    
    // Set system UI overlay style for full-screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Resume with sound for full-screen experience
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReelsPlaybackCubit>().resumeWithSound();
    });
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Exit full-screen mode in cubit
    context.read<ReelsPlaybackCubit>().exitFullScreen();
    
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
=======
      backgroundColor: AppColors.black,
>>>>>>> zoz
      body: BlocBuilder<ReelsPlaybackCubit, ReelsPlaybackState>(
        buildWhen: (previous, current) =>
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
<<<<<<< HEAD
                  final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Stack(
      children: [
        // Main page view
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: state.reels.length,
          onPageChanged: (index) => _onPageChanged(context, index),
          itemBuilder: (context, index) => _buildReelPage(context, state, index),
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 16.h,
          left: 16.w,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
<<<<<<< HEAD
                color:isDark? Colors.white : AppColors.black.withOpacity(0.5),
=======
                color: AppColors.black.withOpacity(0.5),
>>>>>>> zoz
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
<<<<<<< HEAD
                color:isDark? Colors.black : AppColors.white,
=======
                color: AppColors.white,
>>>>>>> zoz
                size: 24.sp,
              ),
            ),
          ),
        ),

<<<<<<< HEAD
        // Reel counter
        Positioned(
          top: MediaQuery.of(context).padding.top + 16.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color:isDark?Colors.white : AppColors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${state.currentIndex + 1} / ${state.reels.length}',
              style: TextStyle(
                color:isDark?Colors.black : AppColors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
=======
        // // Reel counter
        // Positioned(
        //   top: MediaQuery.of(context).padding.top + 16.h,
        //   right: 16.w,
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        //     decoration: BoxDecoration(
        //       color: AppColors.black.withOpacity(0.5),
        //       borderRadius: BorderRadius.circular(20.r),
        //     ),
        //     child: Text(
        //       '${state.currentIndex + 1} / ${state.reels.length}',
        //       style: TextStyle(
        //         color: AppColors.white,
        //         fontSize: 14.sp,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ),
>>>>>>> zoz

        // Loading indicator for pagination
        if (state.isLoading && state.reels.isNotEmpty)
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
<<<<<<< HEAD
                  color:isDark?Colors.white : AppColors.black.withOpacity(0.5),
=======
                  color: AppColors.black.withOpacity(0.5),
>>>>>>> zoz
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
<<<<<<< HEAD
                        color:isDark? AppColors.white :Colors.black,
=======
                        color: AppColors.white,
>>>>>>> zoz
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Loading more reels...',
                      style: TextStyle(
<<<<<<< HEAD
                        fontSize: 14.sp,
                      ).withThemeColor(context),
=======
                        color: AppColors.white,
                        fontSize: 14.sp,
                      ),
>>>>>>> zoz
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReelPage(BuildContext context, ReelsPlaybackState state, int index) {
    final reel = state.reels[index];
    final isCurrentReel = index == state.currentIndex;
<<<<<<< HEAD
              final isDark = Theme.of(context).brightness == Brightness.dark;
=======
>>>>>>> zoz

    return Stack(
      children: [
        // Video player with gestures
        ReelGestureDetector(
          onTap: () => _toggleControls(),
          child: PerfectVideoPlayer(
            isCurrentVideo: isCurrentReel,
          ),
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
<<<<<<< HEAD
              isDark ? Colors.white24 :    AppColors.black.withOpacity(0.3),
                 isDark ? Colors.white60 :      AppColors.black.withOpacity(0.7),
=======
                  AppColors.black.withOpacity(0.3),
                  AppColors.black.withOpacity(0.7),
>>>>>>> zoz
                ],
                stops: const [0.0, 0.5, 0.8, 1.0],
              ),
            ),
          ),
        ),

        // Reel info overlay
        ReelInfoOverlay(reel: reel),

        // Actions overlay
        ReelActionsOverlay(
          reel: reel,
          onLike: () => _handleLike(context, reel),
          onShare: () => _handleShare(context, reel),
          onComment: () => _handleComment(context, reel),
        ),

        // Controls overlay (show/hide on tap)
        if (_showControls && isCurrentReel)
          ReelControlsOverlay(
            showControls: _showControls,
            onToggleControls: _toggleControls,
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.white,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
<<<<<<< HEAD
                  final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
<<<<<<< HEAD
            color:isDark ? AppColors.white : Colors.black,
=======
            color: AppColors.white,
>>>>>>> zoz
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'Failed to load reels',
            style: TextStyle(
<<<<<<< HEAD
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ).withThemeColor(context),
=======
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
>>>>>>> zoz
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextStyle(
<<<<<<< HEAD
              color: isDark? AppColors.white.withOpacity(0.7) : Colors.black,
=======
              color: AppColors.white.withOpacity(0.7),
>>>>>>> zoz
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
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
<<<<<<< HEAD
                  final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
<<<<<<< HEAD
            color: isDark ? AppColors.white : Colors.black,
=======
            color: AppColors.white,
>>>>>>> zoz
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'No reels available',
            style: TextStyle(
<<<<<<< HEAD
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ).withThemeColor(context),
=======
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
>>>>>>> zoz
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for new content',
            style: TextStyle(
<<<<<<< HEAD
              color: isDark? AppColors.white.withOpacity(0.7):Colors.black,
=======
              color: AppColors.white.withOpacity(0.7),
>>>>>>> zoz
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(BuildContext context, int index) {
    print('📄 FullScreenReelsViewer: Page changed to index $index');
    
    final cubit = context.read<ReelsPlaybackCubit>();
    cubit.changeToIndex(index);

    // Load more reels when approaching the end
    if (index >= cubit.state.reels.length - 3 && 
        cubit.state.hasNextPage && 
        !cubit.state.isLoading) {
      cubit.loadReels(page: cubit.state.currentPage + 1);
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide controls after 3 seconds
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _handleLike(BuildContext context, reel) {
    // TODO: Implement like functionality
    print('🤍 Like reel: ${reel.id}');
  }

  void _handleShare(BuildContext context, reel) {
    // TODO: Implement share functionality
    print('📤 Share reel: ${reel.id}');
  }

  void _handleComment(BuildContext context, reel) {
    // TODO: Implement comment functionality
    print('💬 Comment on reel: ${reel.id}');
  }
}