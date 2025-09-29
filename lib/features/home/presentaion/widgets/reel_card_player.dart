import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/colors.dart';
import '../manager/reels_cubit.dart';
import '../manager/reels_state.dart';

/// Critical ReelCardPlayer Widget - Handles individual video controller
/// This is a StatefulWidget for proper video controller disposal
class ReelCardPlayer extends StatefulWidget {
  final String reelUrl;
  final int reelId;
  final String? thumbnailUrl;
  final VoidCallback? onTap;
  final bool isInViewport;

  const ReelCardPlayer({
    super.key,
    required this.reelUrl,
    required this.reelId,
    this.thumbnailUrl,
    this.onTap,
    this.isInViewport = false,
  });

  @override
  State<ReelCardPlayer> createState() => _ReelCardPlayerState();
}

class _ReelCardPlayerState extends State<ReelCardPlayer> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print('🎬 ReelCardPlayer: Initializing for reel ${widget.reelId}');
    _initializeVideo();
  }

  @override
  void didUpdateWidget(ReelCardPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reelUrl != widget.reelUrl) {
      print('🔄 ReelCardPlayer: URL changed, reinitializing video');
      _disposeController();
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (widget.reelUrl.isEmpty) {
      print('❌ ReelCardPlayer: Empty video URL for reel ${widget.reelId}');
      return;
    }

    try {
      print('🎬 ReelCardPlayer: Creating controller for ${widget.reelUrl}');
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reelUrl));
      _controller!.addListener(_onVideoEvent);
      await _controller!.initialize();
      await _controller!.setVolume(0.0);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
          _errorMessage = null;
        });
        print('✅ ReelCardPlayer: Video initialized for reel ${widget.reelId}');
      }
    } catch (e) {
      print('❌ ReelCardPlayer: Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isInitialized = false;
        });
      }
    }
  }

  void _onVideoEvent() {
    if (_controller == null || !mounted) return;
    final value = _controller!.value;

    if (value.position >= value.duration && value.duration.inMilliseconds > 0) {
      print('🔄 ReelCardPlayer: Video completed, restarting');
      _controller!.seekTo(Duration.zero);
      if (_isPlaying) _controller!.play();
    }

    if (value.hasError) {
      print('❌ ReelCardPlayer: Video error: ${value.errorDescription}');
      setState(() {
        _hasError = true;
        _errorMessage = value.errorDescription;
      });
    }
  }

  void pauseVideo() {
    if (_controller?.value.isInitialized == true) {
      print('⏸️ ReelCardPlayer: Pausing video ${widget.reelId}');
      _controller!.pause();
      setState(() => _isPlaying = false);
    }
  }

  void playVideo({bool withSound = false}) {
    if (_controller?.value.isInitialized == true) {
      print('▶️ ReelCardPlayer: Playing video ${widget.reelId} ${withSound ? 'with sound' : 'muted'}');
      _controller!.setVolume(withSound ? 1.0 : 0.0);
      _controller!.play();
      setState(() => _isPlaying = true);
    }
  }

  void togglePlayPause({bool withSound = false}) {
    if (_isPlaying) {
      pauseVideo();
    } else {
      playVideo(withSound: withSound);
    }
  }

  void _disposeController() {
    if (_controller != null) {
      print('🗑️ ReelCardPlayer: Disposing controller for reel ${widget.reelId}');
      _controller!.removeListener(_onVideoEvent);
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    print('🗑️ ReelCardPlayer: Disposing widget for reel ${widget.reelId}');
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<ReelsCubit, ReelsState>(
      listener: (context, state) {
        if (state.isBackgroundPlaybackPaused) {
          pauseVideo();
        } else if (widget.isInViewport && state.shouldAutoPlay) {
          playVideo(withSound: false);
        }
      },
      child: GestureDetector(
        onTap: () {
          togglePlayPause(withSound: true);
          widget.onTap?.call();
        },
        child: Container(
          width: 200.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.black,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: _buildVideoContent(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent(bool isDark) {
    if (_hasError) return _buildErrorState(isDark);
    if (!_isInitialized || _controller == null) return _buildLoadingState(isDark);

    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        if (!_isPlaying)
          Center(
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard.withOpacity(0.6) : AppColors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: isDark ? AppColors.white : AppColors.white,
                size: 30.sp,
              ),
            ),
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
                  isDark ? AppColors.darkCard.withOpacity(0.3) : AppColors.black.withOpacity(0.3),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkCard.withOpacity(0.2) : AppColors.gray.withOpacity(0.2),
      child: Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.white : AppColors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Container(
      color: isDark ? AppColors.darkCard.withOpacity(0.2) : AppColors.gray.withOpacity(0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: isDark ? AppColors.white : AppColors.white,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Video Error',
              style: TextStyle(
                color: isDark ? AppColors.white : AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: 4.h),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: isDark ? AppColors.white.withOpacity(0.7) : AppColors.white.withOpacity(0.7),
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
