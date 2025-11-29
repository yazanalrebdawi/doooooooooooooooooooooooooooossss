import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart'
    as di;
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_cubit.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/reel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/reel_model.dart';

///* Full-screen Instagram-style reel player
/// Handles video playback, pause, mute, controls overlay, and lifecycle
class FullScreenReelPlayer extends StatefulWidget {
  final ReelModel reel;
  final bool isCurrentReel;
  final VoidCallback? onTap;

  const FullScreenReelPlayer({
    super.key,
    required this.reel,
    required this.isCurrentReel,
    this.onTap,
  });

  @override
  State<FullScreenReelPlayer> createState() => _FullScreenReelPlayerState();
}

class _FullScreenReelPlayerState extends State<FullScreenReelPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isMuted = false;
  String? _errorMessage;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('🎬 FullScreenReelPlayer: initState for reel ${widget.reel.id}, isCurrentReel: ${widget.isCurrentReel}');
    // Only initialize if this is the current reel AND video URL is valid
    if (widget.isCurrentReel) {
      final videoUrl = widget.reel.video.trim();
      print('🎬 FullScreenReelPlayer: Initializing video for reel ${widget.reel.id}, URL: ${videoUrl.substring(0, videoUrl.length > 50 ? 50 : videoUrl.length)}...');
      if (videoUrl.isNotEmpty && _isValidVideoUrl(videoUrl)) {
        _initializeVideo();
      } else {
        print('❌ FullScreenReelPlayer: Invalid video URL for reel ${widget.reel.id}');
        // Set error state immediately if video is invalid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = videoUrl.isEmpty 
                  ? 'Video URL is empty' 
                  : 'Invalid video URL format';
              _isInitialized = false;
            });
          }
        });
      }
    } else {
      print('⏸️ FullScreenReelPlayer: Skipping initialization - not current reel');
    }
  }

  /// Helper method to validate video URL format
  bool _isValidVideoUrl(String url) {
    if (url.isEmpty || url.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(url.trim());
      // Must have scheme, host, and valid format
      if (!uri.hasScheme || !uri.scheme.startsWith('http')) return false;
      if (uri.host.isEmpty) return false;
      // Ensure the full URI string is valid
      final uriString = uri.toString();
      if (uriString.isEmpty || uriString == ':' || uriString == 'http:' || uriString == 'https:') return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void didUpdateWidget(FullScreenReelPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Initialize video if this reel becomes current
    if (!oldWidget.isCurrentReel &&
        widget.isCurrentReel &&
        _controller == null) {
      print('🎬 FullScreenReelPlayer: Reel ${widget.reel.id} became current - initializing');
      final videoUrl = widget.reel.video.trim();
      if (videoUrl.isNotEmpty && _isValidVideoUrl(videoUrl)) {
        _initializeVideo();
      } else {
        print('❌ FullScreenReelPlayer: Invalid video URL for reel ${widget.reel.id}');
        // Set error state if video is invalid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage = videoUrl.isEmpty 
                  ? 'Video URL is empty' 
                  : 'Invalid video URL format';
              _isInitialized = false;
            });
          }
        });
      }
    }

    // Dispose video if this reel is no longer current
    if (oldWidget.isCurrentReel && !widget.isCurrentReel) {
      print('⏸️ FullScreenReelPlayer: Reel ${widget.reel.id} no longer current - disposing');
      _disposeController();
    }

    // Play/pause based on current reel status
    if (widget.isCurrentReel && _isInitialized) {
      if (!_isPlaying) {
        print('▶️ FullScreenReelPlayer: Reel ${widget.reel.id} is current and initialized - playing');
        _playVideo();
      }
    } else {
      if (_isPlaying) {
        print('⏸️ FullScreenReelPlayer: Reel ${widget.reel.id} is not current - pausing');
        _pauseVideo();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _pauseVideo();
        break;
      case AppLifecycleState.resumed:
        if (widget.isCurrentReel && _isInitialized) _playVideo();
        break;
    }
  }

  Future<void> _initializeVideo() async {
    print('🎬 FullScreenReelPlayer: _initializeVideo() called for reel ${widget.reel.id}');
    // Validate video URL before attempting to initialize
    final videoUrl = widget.reel.video.trim();
    if (videoUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Video URL is empty';
          _isInitialized = false;
        });
      }
      return;
    }

    // Validate URL format - strict validation
    Uri? uri;
    try {
      uri = Uri.parse(videoUrl);
      // Must have scheme, host, and valid format
      if (!uri.hasScheme || !uri.scheme.startsWith('http')) {
        throw FormatException('Invalid video URL scheme');
      }
      if (uri.host.isEmpty) {
        throw FormatException('Video URL missing host');
      }
      // Ensure the full URI string is valid
      final uriString = uri.toString();
      if (uriString.isEmpty || uriString == ':' || uriString == 'http:' || uriString == 'https:') {
        throw FormatException('Invalid video URL format');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid video URL format';
          _isInitialized = false;
        });
      }
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(uri);
      _controller!.addListener(_onVideoEvent);
      
      // Add timeout for initialization (important for older devices)
      await _controller!.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Video initialization timed out after 15 seconds');
        },
      );
      
      // Check if controller is still valid after initialization
      if (!_controller!.value.isInitialized) {
        throw Exception('Video controller failed to initialize');
      }
      
      await _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      await _controller!.setLooping(true);

      if (mounted) {
        print('✅ FullScreenReelPlayer: Video initialized successfully for reel ${widget.reel.id}');
        setState(() {
          _isInitialized = true;
          _hasError = false;
          _errorMessage = null;
        });
        if (widget.isCurrentReel) {
          print('▶️ FullScreenReelPlayer: Auto-playing reel ${widget.reel.id}');
          _playVideo();
        } else {
          print('⏸️ FullScreenReelPlayer: Reel ${widget.reel.id} initialized but not current - not auto-playing');
        }
      }
    } catch (e) {
      print('❌ FullScreenReelPlayer: Error initializing video: $e');
      // Check if it's a codec/device compatibility issue
      final errorString = e.toString().toLowerCase();
      final isCodecError = errorString.contains('codec') || 
                          errorString.contains('decoder') ||
                          errorString.contains('format') ||
                          errorString.contains('unsupported');
      
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = isCodecError 
              ? 'Video format not supported on this device'
              : 'Failed to load video. Please try again.';
          _isInitialized = false;
        });
      }
      // Dispose controller on error to prevent memory leaks
      _disposeController();
    }
  }

  void _onVideoEvent() {
    if (_controller == null || !mounted) return;
    final value = _controller!.value;
    if (value.hasError) {
      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller != null) {
          final errorDesc = value.errorDescription ?? 'Video playback error';
          final errorString = errorDesc.toLowerCase();
          final isCodecError = errorString.contains('codec') || 
                              errorString.contains('decoder') ||
                              errorString.contains('format') ||
                              errorString.contains('unsupported') ||
                              errorString.contains('corrupted');
          
          setState(() {
            _hasError = true;
            _errorMessage = isCodecError 
                ? 'Video format not supported on this device'
                : errorDesc;
            _isPlaying = false;
          });
        }
      });
    }
  }

  void _playVideo() {
    if (_controller?.value.isInitialized == true && !_isPlaying) {
      print('▶️ FullScreenReelPlayer: Calling play() for reel ${widget.reel.id}');
      _controller!.play().then((_) {
        print('✅ FullScreenReelPlayer: Play() completed for reel ${widget.reel.id}');
      }).catchError((e) {
        print('❌ FullScreenReelPlayer: Error playing video for reel ${widget.reel.id}: $e');
      });
      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isPlaying = true);
        }
      });
    } else {
      print('⚠️ FullScreenReelPlayer: Cannot play reel ${widget.reel.id} - controller: ${_controller != null}, initialized: ${_controller?.value.isInitialized}, isPlaying: $_isPlaying');
    }
  }

  void _pauseVideo() {
    if (_controller?.value.isInitialized == true && _isPlaying) {
      _controller!.pause();
      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pauseVideo();
    } else {
      _playVideo();
    }
  }

  void _toggleMute() {
    if (_controller?.value.isInitialized == true) {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      // Use post-frame callback to avoid build during frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
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

  void _disposeController() {
    if (_controller != null) {
      _controller!.removeListener(_onVideoEvent);
      _controller!.dispose();
      _controller = null;
      _isInitialized = false;
      _isPlaying = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.appLocator<ReelCubit>(),
      child: GestureDetector(
        onTap: () {
          _toggleControls();
          widget.onTap?.call();
        },
        onDoubleTap: _toggleMute,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.black,
          child: Stack(
            children: [
              _buildVideoContent(),
              _buildReelInfoOverlay(),
              if (_showControls) _buildControlsOverlay(),
              _buildActionsOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) return _buildErrorState();
    if (!_isInitialized || _controller == null) return _buildLoadingState();

    // Use FittedBox with BoxFit.cover to ensure video always fills the screen
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.white, strokeWidth: 3),
          SizedBox(height: 16.h),
          Text('Loading reel...', style: AppTextStyles.whiteS16W400),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    // Show thumbnail as fallback if available
    final hasThumbnail = widget.reel.thumbnail.isNotEmpty && 
                        _isValidImageUrl(widget.reel.thumbnail);
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Show thumbnail as background if available
        if (hasThumbnail)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.reel.thumbnail,
              fit: BoxFit.cover,
              memCacheWidth: 720,
              memCacheHeight: 1280,
              errorWidget: (context, url, error) => Container(
                color: AppColors.black,
              ),
              placeholder: (context, url) => Container(
                color: AppColors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          )
        else
          Container(color: AppColors.black),
        
        // Error message overlay
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.white, size: 48.sp),
                SizedBox(height: 12.h),
                Text(
                  'Unable to play video',
                  style: AppTextStyles.whiteS18W600,
                  textAlign: TextAlign.center,
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    _errorMessage!,
                    style: AppTextStyles.whiteS14W400,
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _errorMessage = null;
                    });
                    _initializeVideo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  /// Helper to validate image URL
  bool _isValidImageUrl(String url) {
    if (url.isEmpty || url.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(url.trim());
      if (!uri.hasScheme || !uri.scheme.startsWith('http')) return false;
      if (uri.host.isEmpty) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildReelInfoOverlay() {
    return Positioned(
      left: 16.w,
      right: 80.w,
      bottom: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // Pause video immediately before navigating
              _pauseVideo();
              // Navigate after a brief delay to ensure video is paused
              Future.microtask(() {
                if (mounted) {
                  context.push(
                      '/dealer-profile/${widget.reel.dealer.toString()}?handle=${widget.reel.dealerName ?? ''}');
                }
              });
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    (widget.reel.dealerName?.isNotEmpty == true)
                        ? widget.reel.dealerName![0].toUpperCase()
                        : 'U',
                    style: AppTextStyles.whiteS14W600,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(widget.reel.dealerName ?? 'Unknown User',
                    style: AppTextStyles.whiteS14W600),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(widget.reel.title,
              style: AppTextStyles.whiteS16W600,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          if (widget.reel.description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(widget.reel.description,
                style: AppTextStyles.whiteS14W400,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }

  Widget _buildActionsOverlay() {
    return BlocProvider.value(
      value: di.appLocator<ReelCubit>(),
      child: Positioned(
        right: 16.w,
        bottom: 100.h,
        child: Column(
          children: [
            BlocBuilder<ReelCubit, ReelState>(
              builder: (context, state) {
                // Get the current reel - use widget.reel as base, but check if it's updated in state
                ReelModel updatedReel = widget.reel;
                
                // Try to find the reel in state by ID (more reliable than index)
                if (state.reels.isNotEmpty) {
                  try {
                    final reelInState = state.reels.firstWhere(
                      (r) => r.id == widget.reel.id,
                    );
                    updatedReel = reelInState;
                  } catch (e) {
                    // Reel not found in state, use widget.reel
                    updatedReel = widget.reel;
                  }
                }

                return _buildActionButton(
                  icon: updatedReel.liked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: _formatCount(updatedReel.likesCount),
                  onTap: () {
                    print('❤️ FullScreenReelPlayer: Like button tapped for reel ${updatedReel.id}');
                    print('❤️ Current liked status: ${updatedReel.liked}, likes count: ${updatedReel.likesCount}');
                    
                    // Store original values BEFORE updating (for error handling)
                    final originalLikedStatus = updatedReel.liked;
                    final originalLikesCount = updatedReel.likesCount;
                    
                    // Calculate new values
                    final newLikedStatus = !updatedReel.liked;
                    final newLikesCount = updatedReel.liked
                        ? updatedReel.likesCount - 1
                        : updatedReel.likesCount + 1;
                    
                    print('❤️ New liked status: $newLikedStatus, new likes count: $newLikesCount');
                    
                    // Update UI immediately
                    final tempReel = updatedReel.copyWith(
                      liked: newLikedStatus,
                      likesCount: newLikesCount,
                    );

                    // Update the reel in state - ensure we have a list to work with
                    List<ReelModel> tempReels;
                    if (state.reels.isNotEmpty) {
                      tempReels = List<ReelModel>.from(state.reels);
                    } else {
                      // If state is empty, create a list with the updated reel
                      tempReels = [tempReel];
                    }

                    // Find and update the reel by ID (more reliable)
                    final reelIndex = tempReels.indexWhere((r) => r.id == updatedReel.id);
                    if (reelIndex != -1) {
                      print('❤️ Found reel at index $reelIndex, updating...');
                      tempReels[reelIndex] = tempReel;
                    } else {
                      print('❤️ Reel not found in state, adding it...');
                      // If not found, add it
                      tempReels.add(tempReel);
                    }

                    print('❤️ Emitting state with ${tempReels.length} reels');
                    // Emit immediately to update UI
                    context.read<ReelCubit>().safeEmit(
                          state.copyWith(reels: tempReels),
                        );

                    // Send API request with original values for error handling
                    print('❤️ Calling likeReel API for reel ${updatedReel.id}');
                    context.read<ReelCubit>().likeReel(
                      updatedReel.id,
                      originalLikedStatus: originalLikedStatus,
                      originalLikesCount: originalLikesCount,
                    );
                  },
                  iconColor: updatedReel.liked ? Colors.red : AppColors.white,
                );
              },
            ),
            SizedBox(height: 24.h),
            // _buildActionButton(
            //   icon: Icons.comment,
            //   label: _formatCount(widget.reel.likesCount),
            //   onTap: () => print('Comment on reel ${widget.reel.id}'),
            // ),
            // SizedBox(height: 24.h),
            // _buildActionButton(
            //   icon: Icons.share,
            //   label: 'Share',
            //   onTap: () => print('Share reel ${widget.reel.id}'),
            // ),
            SizedBox(height: 24.h),
            _buildActionButton(
              icon: _isMuted ? Icons.volume_off : Icons.volume_up,
              label: _isMuted ? 'Unmute' : 'Mute',
              onTap: _toggleMute,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 4.h),
          Text(label,
              style: AppTextStyles.whiteS12W400, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay() {
    if (!_isInitialized) return const SizedBox.shrink();
    return Center(
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.white, size: 40.sp),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
