import 'dart:developer';
import 'package:dooss_business_app/user/core/constants/colors.dart';
import 'package:dooss_business_app/user/core/constants/text_styles.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:dooss_business_app/user/core/services/native_video_service.dart';
import 'package:dooss_business_app/user/features/home/data/models/reel_model.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/home_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_state.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reels_playback_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/reel_actions_overlay.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/reel_info_overlay.dart';
import 'package:dooss_business_app/user/features/home/presentaion/widgets/reel_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
          return _buildEmptyState(isDark, context);
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
        child: CircularProgressIndicator(color: AppColors.primary),
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
            Icon(Icons.error_outline,
                color: isDark ? AppColors.white : AppColors.black, size: 64.sp),
            SizedBox(height: 16.h),
            Text('Failed to load reels',
                style: AppTextStyles.whiteS18W600.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                )),
            SizedBox(height: 8.h),
            Text(error,
                style: AppTextStyles.whiteS14W400.copyWith(
                  color: (isDark ? AppColors.white : AppColors.black)
                      .withOpacity(0.7),
                )),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<ReelCubit>().loadReels(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ النسخة المعدّلة — زر رجوع فقط إذا ما في ريلز
  Widget _buildEmptyState(bool isDark, BuildContext context) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined,
                color: isDark ? AppColors.white : AppColors.black, size: 64.sp),
            SizedBox(height: 16.h),
            Text('No reels available',
                style: AppTextStyles.whiteS18W600.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                )),
            SizedBox(height: 8.h),
            Text('Check back later for new content',
                style: AppTextStyles.whiteS14W400.copyWith(
                  color: (isDark ? AppColors.white : AppColors.black)
                      .withOpacity(0.7),
                )),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                NativeVideoService.dispose();
                context.go(RouteNames.homeScreen);
              },
              icon: Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
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
        return _buildReelItem(
            context, reel, isCurrentReel, index, state, isDark);
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
            isCurrentReel: isCurrentReel), //////////////////////////

        // Gradient overlay for better text readability
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
        // ReelVideoPlayer(reel: reel, isCurrentReel: isCurrentReel),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16.h,
          left: 16.w,
          child: GestureDetector(
            onTap: () {
              context.go(RouteNames.homeScreen);
              context.read<HomeCubit>().updateCurrentIndex(0);
              log("🔥🔥🔥");
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.black : AppColors.white)
                    .withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back,
                  color: isDark ? AppColors.white : AppColors.black,
                  size: 24.sp),
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
      ],
    );
  }

  void _handleLike(BuildContext context, ReelModel reel) {
    log('🤍 Like reel: ${reel.id}');
    log('🤍 Like reel  fdfs: ${reel.id}');
    context.read<ReelCubit>().likeReel(reel.id);
  }

  void _handleShare(BuildContext context, ReelModel reel) {
    print('📤 Share reel: ${reel.id}');
  }

  void _handleComment(BuildContext context, ReelModel reel) {
    print('💬 Comment on reel: ${reel.id}');
  }
}
