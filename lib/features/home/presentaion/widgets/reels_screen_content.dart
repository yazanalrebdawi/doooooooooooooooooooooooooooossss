import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/native_video_service.dart';
import '../manager/reel_cubit.dart';
import '../manager/reel_state.dart';
import '../../data/models/reel_model.dart';
import 'reel_video_player.dart';
import 'reel_actions_overlay.dart';
import 'reel_info_overlay.dart';

class ReelsScreenContent extends StatelessWidget {
  final PageController pageController;
  final int? initialReelId;

  const ReelsScreenContent({
    super.key,
    required this.pageController,
    this.initialReelId,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ReelCubit, ReelState>(
      buildWhen: (previous, current) =>
          previous.reels != current.reels ||
          previous.isLoading != current.isLoading ||
          previous.error != current.error ||
          previous.currentReelIndex != current.currentReelIndex,
      builder: (context, state) {
        if (state.isLoading && state.reels.isEmpty) {
          return _buildLoadingState(isDark);
        }

        if (state.error != null && state.reels.isEmpty) {
          return _buildErrorState(context, state.error!, isDark);
        }

        if (state.reels.isEmpty) {
          return _buildEmptyState(isDark);
        }

        // Jump to initial reel if provided
        if (initialReelId != null && state.reels.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ReelCubit>().jumpToReelById(initialReelId!);
            if (pageController.hasClients) {
              pageController.jumpToPage(state.currentReelIndex);
            }
          });
        }

        return _buildReelsView(context, state, isDark);
      },
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, bool isDark) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: isDark ? AppColors.white : AppColors.black,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load reels',
              style: AppTextStyles.whiteS18W600.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTextStyles.whiteS14W400.copyWith(
                color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<ReelCubit>().loadReels(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              color: isDark ? AppColors.white : AppColors.black,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'No reels available',
              style: AppTextStyles.whiteS18W600.copyWith(
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Check back later for new content',
              style: AppTextStyles.whiteS14W400.copyWith(
                color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReelsView(BuildContext context, ReelState state, bool isDark) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: state.reels.length,
      onPageChanged: (index) {
        context.read<ReelCubit>().changeReelIndex(index);
        NativeVideoService.dispose();
      },
      itemBuilder: (context, index) {
        final reel = state.reels[index];
        final isCurrentReel = index == state.currentReelIndex;

        return _buildReelItem(context, reel, isCurrentReel, index, state, isDark);
      },
    );
  }

  Widget _buildReelItem(
    BuildContext context,
    ReelModel reel,
    bool isCurrentReel,
    int index,
    ReelState state,
    bool isDark,
  ) {
    return Stack(
      children: [
        // Video player
        ReelVideoPlayer(
          reel: reel,
          isCurrentReel: isCurrentReel,
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
                  (isDark ? AppColors.black : AppColors.gray).withOpacity(0.3),
                  (isDark ? AppColors.black : AppColors.gray).withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 0.8, 1.0],
              ),
            ),
          ),
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
                color: (isDark ? AppColors.black : AppColors.white).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.white : AppColors.black,
                size: 24.sp,
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

        // Loading more indicator
        if (index == state.reels.length - 3 && state.hasNextPage && !state.isLoading)
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.black : AppColors.white).withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Loading more...',
                    style: AppTextStyles.whiteS12W400.copyWith(
                      color: isDark ? AppColors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _handleLike(BuildContext context, ReelModel reel) {
    print('🤍 Like reel: ${reel.id}');
  }

  void _handleShare(BuildContext context, ReelModel reel) {
    print('📤 Share reel: ${reel.id}');
  }

  void _handleComment(BuildContext context, ReelModel reel) {
    print('💬 Comment on reel: ${reel.id}');
  }
}
