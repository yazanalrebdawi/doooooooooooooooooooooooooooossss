import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NativeVideoService {
  static VideoPlayerController? _controller;

  static Future<void> loadVideo(String url) async {
    // Validate video URL before attempting to load
    final videoUrl = url.trim();
    if (videoUrl.isEmpty) {
      print('❌ NativeVideoService: Empty video URL');
      return;
    }

    // Validate URL format - strict validation
    Uri? uri;
    try {
      uri = Uri.parse(videoUrl);
      // Must have scheme, host, and valid format
      if (!uri.hasScheme || !uri.scheme.startsWith('http')) {
        print('❌ NativeVideoService: Invalid video URL scheme: $videoUrl');
        return;
      }
      if (uri.host.isEmpty) {
        print('❌ NativeVideoService: Video URL missing host: $videoUrl');
        return;
      }
      // Ensure the full URI string is valid
      final uriString = uri.toString();
      if (uriString.isEmpty || uriString == ':' || uriString == 'http:' || uriString == 'https:') {
        print('❌ NativeVideoService: Invalid video URL format: $videoUrl');
        return;
      }
    } catch (e) {
      print('❌ NativeVideoService: Invalid video URL format: $videoUrl');
      return;
    }

    try {
      _controller?.dispose();
      _controller = VideoPlayerController.networkUrl(uri);
      await _controller!.initialize();
      print('🎬 NativeVideoService: Video loaded: $videoUrl');
    } catch (e) {
      print('❌ NativeVideoService: Error loading video: $e');
      _controller?.dispose();
      _controller = null;
    }
  }

  static Future<void> play() async {
    try {
      await _controller?.play();
      print('▶️ NativeVideoService: Video playing');
    } catch (e) {
      print('❌ NativeVideoService: Error playing video: $e');
    }
  }

  static Future<void> pause() async {
    try {
      await _controller?.pause();
      print('⏸️ NativeVideoService: Video paused');
    } catch (e) {
      print('❌ NativeVideoService: Error pausing video: $e');
    }
  }

  static Future<void> stop() async {
    try {
      await _controller?.pause();
      await _controller?.seekTo(Duration.zero);
      print('⏹️ NativeVideoService: Video stopped');
    } catch (e) {
      print('❌ NativeVideoService: Error stopping video: $e');
    }
  }

  static Future<void> dispose() async {
    try {
      await _controller?.dispose();
      _controller = null;
      print('🗑️ NativeVideoService: Video disposed');
    } catch (e) {
      print('❌ NativeVideoService: Error disposing video: $e');
    }
  }

  static bool isPlaying() {
    return _controller?.value.isPlaying ?? false;
  }

  static bool isInitialized() {
    return _controller?.value.isInitialized ?? false;
  }

  static Future<void> setVolume(double volume) async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.setVolume(volume);
        print('🔊 NativeVideoService: Volume set to $volume');
      }
    } catch (e) {
      print('❌ NativeVideoService: Error setting volume: $e');
    }
  }

  static VideoPlayerController? getController() {
    return _controller;
  }
}

class NativeVideoWidget extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final bool muted;
  final bool loop;
  final VoidCallback? onVideoReady;
  final VoidCallback? onVideoEnded;
  final VoidCallback? onVideoError;

  const NativeVideoWidget({
    super.key,
    required this.videoUrl,
    required this.width,
    required this.height,
    this.muted = false,
    this.loop = true,
    this.onVideoReady,
    this.onVideoEnded,
    this.onVideoError,
  });

  @override
  State<NativeVideoWidget> createState() => _NativeVideoWidgetState();
}

class _NativeVideoWidgetState extends State<NativeVideoWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(NativeVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If video URL changed, reinitialize
    if (oldWidget.videoUrl != widget.videoUrl && !_isDisposed) {
      print(
          '🔄 NativeVideoWidget: Video URL changed from ${oldWidget.videoUrl} to ${widget.videoUrl}');
      _disposeController();
      _initializeVideo();
    }

    // Update mute state if changed
    if (oldWidget.muted != widget.muted &&
        _controller?.value.isInitialized == true) {
      _controller!.setVolume(widget.muted ? 0.0 : 1.0);
      print('🔇 NativeVideoWidget: Volume updated to ${widget.muted ? 0.0 : 1.0}');
    }
    
    // Handle play/pause based on whether this is the current reel
    // Note: This widget doesn't know if it's current, so parent should handle visibility
  }

  Future<void> _muteVideo() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        widget.muted) {
      await _controller!.setVolume(0.0);
      print('🔇 NativeVideoWidget: Video muted');
    }
  }

  Future<void> _initializeVideo() async {
    // Validate video URL before attempting to initialize
    final videoUrl = widget.videoUrl.trim();
    if (videoUrl.isEmpty) {
      print('❌ NativeVideoWidget: Empty video URL');
      widget.onVideoError?.call();
      return;
    }

    // Validate URL format
    Uri? uri;
    try {
      uri = Uri.parse(videoUrl);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        print('❌ NativeVideoWidget: Invalid video URL scheme: $videoUrl');
        widget.onVideoError?.call();
        return;
      }
    } catch (e) {
      print('❌ NativeVideoWidget: Invalid video URL format: $videoUrl');
      widget.onVideoError?.call();
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(
        uri,
        // Add video player options for better compatibility with older devices
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      _controller!.addListener(() {
        if (_isDisposed) return;

        // Handle errors
        if (_controller!.value.hasError) {
          print('❌ NativeVideoWidget: Video error: ${_controller!.value.errorDescription}');
          widget.onVideoError?.call();
          return;
        }

        if (_controller!.value.isInitialized && !_isInitialized) {
          if (mounted && !_isDisposed) {
            setState(() {
              _isInitialized = true;
            });
            _muteVideo(); // إيقاف الصوت عند التهيئة
            widget.onVideoReady?.call();
          }
        }

        // التحقق من انتهاء الفيديو وإعادة التشغيل
        if (_controller!.value.duration.inMilliseconds > 0 &&
            _controller!.value.position >= _controller!.value.duration) {
          widget.onVideoEnded?.call();

          // إعادة تشغيل الفيديو إذا كان loop = true
          if (widget.loop && !_isDisposed) {
            _controller!.seekTo(Duration.zero);
            _controller!.play();
            print('🔄 NativeVideoWidget: Video looped');
          }
        }
      });

      // Add timeout for initialization (important for older devices like Galaxy Note 9)
      await _controller!.initialize().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Video initialization timed out after 20 seconds');
        },
      );
      
      // Check if controller is still valid after initialization
      if (!_controller!.value.isInitialized) {
        throw Exception('Video controller failed to initialize');
      }
      
      if (widget.muted) {
        await _controller!
            .setVolume(0.0); // إيقاف الصوت فقط إذا كان muted = true
      }
      
      // Set looping before playing
      await _controller!.setLooping(widget.loop);
      
      await _controller!.play();

      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('❌ NativeVideoWidget: Error initializing video: $e');
      // Dispose controller on error to prevent memory leaks
      _disposeController();
      widget.onVideoError?.call();
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
    if (mounted && !_isDisposed) {
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: VideoPlayer(_controller!),
    );
  }
}
