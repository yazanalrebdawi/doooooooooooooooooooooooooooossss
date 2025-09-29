<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
=======
import 'dart:developer';

import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/features/home/presentaion/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
>>>>>>> zoz
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/native_video_service.dart';
import '../manager/reel_cubit.dart';
import '../manager/reel_state.dart';
import '../../data/models/reel_model.dart';
import 'reel_video_player.dart';
import 'reel_actions_overlay.dart';
import 'reel_info_overlay.dart';

<<<<<<< HEAD
=======
//? هي الكاملة ريلززززز
>>>>>>> zoz
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
<<<<<<< HEAD
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
=======
    return BlocBuilder<ReelCubit, ReelState>(
      buildWhen:
          (previous, current) =>
              previous.reels != current.reels ||
              previous.isLoading != current.isLoading ||
              previous.error != current.error ||
              previous.currentReelIndex != current.currentReelIndex,
      builder: (context, state) {
        if (state.isLoading && state.reels.isEmpty) {
          return _buildLoadingState();
        }

        if (state.error != null && state.reels.isEmpty) {
          return _buildErrorState(context, state.error!);
        }

        if (state.reels.isEmpty) {
          return _buildEmptyState();
>>>>>>> zoz
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

<<<<<<< HEAD
        return _buildReelsView(context, state, isDark);
=======
        return _buildReelsView(context, state);
>>>>>>> zoz
      },
    );
  }

<<<<<<< HEAD
  Widget _buildLoadingState(bool isDark) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
=======
  Widget _buildLoadingState() {
    return Container(
      color: AppColors.black,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
>>>>>>> zoz
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildErrorState(BuildContext context, String error, bool isDark) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
=======
  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      color: AppColors.black,
>>>>>>> zoz
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
<<<<<<< HEAD
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
=======
            Icon(Icons.error_outline, color: AppColors.white, size: 64.sp),
            SizedBox(height: 16.h),
            Text('Failed to load reels', style: AppTextStyles.whiteS18W600),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTextStyles.whiteS14W400,
>>>>>>> zoz
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

<<<<<<< HEAD
  Widget _buildEmptyState(bool isDark) {
    return Container(
      color: isDark ? AppColors.black : AppColors.white,
=======
  Widget _buildEmptyState() {
    return Container(
      color: AppColors.black,
>>>>>>> zoz
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
<<<<<<< HEAD
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
=======
              color: AppColors.white,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text('No reels available', style: AppTextStyles.whiteS18W600),
            SizedBox(height: 8.h),
            Text(
              'Check back later for new content',
              style: AppTextStyles.whiteS14W400,
>>>>>>> zoz
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildReelsView(BuildContext context, ReelState state, bool isDark) {
=======
  Widget _buildReelsView(BuildContext context, ReelState state) {
>>>>>>> zoz
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: state.reels.length,
      onPageChanged: (index) {
        context.read<ReelCubit>().changeReelIndex(index);
<<<<<<< HEAD
=======
        // Dispose previous video and load new one
>>>>>>> zoz
        NativeVideoService.dispose();
      },
      itemBuilder: (context, index) {
        final reel = state.reels[index];
        final isCurrentReel = index == state.currentReelIndex;

<<<<<<< HEAD
        return _buildReelItem(context, reel, isCurrentReel, index, state, isDark);
=======
        return _buildReelItem(context, reel, isCurrentReel, index, state);
>>>>>>> zoz
      },
    );
  }

  Widget _buildReelItem(
    BuildContext context,
    ReelModel reel,
    bool isCurrentReel,
    int index,
    ReelState state,
<<<<<<< HEAD
    bool isDark,
=======
>>>>>>> zoz
  ) {
    return Stack(
      children: [
        // Video player
<<<<<<< HEAD
        ReelVideoPlayer(
          reel: reel,
          isCurrentReel: isCurrentReel,
        ),

        // Gradient overlay
=======
        ReelVideoPlayer(reel: reel, isCurrentReel: isCurrentReel),

        // Gradient overlay for better text readability
>>>>>>> zoz
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
                  (isDark ? AppColors.black : AppColors.gray).withOpacity(0.3),
                  (isDark ? AppColors.black : AppColors.gray).withOpacity(0.7),
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

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 16.h,
          left: 16.w,
          child: GestureDetector(
<<<<<<< HEAD
            onTap: () => Navigator.of(context).pop(),
=======
            onTap: () {
              // 1️⃣ أول شي تنتقل لـ HomeScreen
              context.go(RouteNames.homeScreen);

              // 2️⃣ بعدها تغيّر التاب المطلوب
              context.read<HomeCubit>().updateCurrentIndex(
                0,
              ); // غيّر الرقم حسب التاب المطلوب

              log("🔥🔥🔥");
              //todo يمكن الانتقال بدو عن طريق كيوبت
            },
>>>>>>> zoz
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: (isDark ? AppColors.black : AppColors.white).withOpacity(0.5),
=======
                color: AppColors.black.withOpacity(0.5),
>>>>>>> zoz
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
<<<<<<< HEAD
                color: isDark ? AppColors.white : AppColors.black,
=======
                color: AppColors.white,
>>>>>>> zoz
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
<<<<<<< HEAD
        if (index == state.reels.length - 3 && state.hasNextPage && !state.isLoading)
=======
        if (index == state.reels.length - 3 &&
            state.hasNextPage &&
            !state.isLoading)
>>>>>>> zoz
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
<<<<<<< HEAD
                color: (isDark ? AppColors.black : AppColors.white).withOpacity(0.5),
=======
                color: AppColors.black.withOpacity(0.5),
>>>>>>> zoz
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
<<<<<<< HEAD
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
=======
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Loading more...', style: AppTextStyles.whiteS12W400),
>>>>>>> zoz
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _handleLike(BuildContext context, ReelModel reel) {
<<<<<<< HEAD
=======
    // TODO: Implement like functionality
>>>>>>> zoz
    print('🤍 Like reel: ${reel.id}');
  }

  void _handleShare(BuildContext context, ReelModel reel) {
<<<<<<< HEAD
=======
    // TODO: Implement share functionality
>>>>>>> zoz
    print('📤 Share reel: ${reel.id}');
  }

  void _handleComment(BuildContext context, ReelModel reel) {
<<<<<<< HEAD
=======
    // TODO: Implement comment functionality
>>>>>>> zoz
    print('💬 Comment on reel: ${reel.id}');
  }
}
