import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class VideoPlayerEditReelWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerEditReelWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerEditReelWidget> createState() => _VideoPlayerEditReelWidgetState();
// }

// class _VideoPlayerEditReelWidgetState extends State<VideoPlayerEditReelWidget> {
//   late VideoPlayerController _controller;
//   bool showPlayPause = false;
//   bool isInitialized = false;

//   @override
//   void initState() {
//     super.initState();

//     final uri = Uri.tryParse(widget.videoUrl);
//     if (uri != null && (uri.scheme == "http" || uri.scheme == "https")) {
//       // رابط من الإنترنت
//       _controller = VideoPlayerController.network(widget.videoUrl);
//     } else {
//       // نفترض أنه مسار ملف محلي (مثل XFile.path)
//       _controller = VideoPlayerController.file(File(widget.videoUrl));
//     }

//     _controller.initialize().then((_) {
//       setState(() => isInitialized = true);
//       _controller.play();
//     });
//   }

//   // إيقاف الفيديو إذا خرج من الشاشة
//   void checkVisibility(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final renderObject = context.findRenderObject();
//       if (renderObject is RenderBox) {
//         final visibility = renderObject.localToGlobal(Offset.zero).dy;
//         final screenHeight = MediaQuery.of(context).size.height;

//         if (visibility + renderObject.size.height < 0 ||
//             visibility > screenHeight) {
//           if (_controller.value.isInitialized && _controller.value.isPlaying) {
//             _controller.pause();
//           }
//         }
//       }
//     });
//   }

//   void _togglePlayPause() {
//     if (!_controller.value.isInitialized) return;

//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//       showPlayPause = true;
//     });

//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) setState(() => showPlayPause = false);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     checkVisibility(context);

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         GestureDetector(
//           onTap: _togglePlayPause,
//           child: Container(
//             margin: EdgeInsets.only(bottom: 14.h),
//             width: double.infinity,
//             height: 620.h,
//             decoration: const BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 if (_controller.value.isInitialized)
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       topRight: Radius.circular(8),
//                     ),
//                     child: AspectRatio(
//                       aspectRatio: 9 / 16,
//                       child: VideoPlayer(_controller),
//                     ),
//                   )
//                 else
//                   const Center(
//                     child: CircularProgressIndicator(color: Color(0xff349A51)),
//                   ),

//                 if (showPlayPause)
//                   Container(
//                     width: 46.w,
//                     height: 46.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                     child: Icon(
//                       _controller.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                       size: 28,
//                       color: Colors.black,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



class VideoPlayerEditReelWidget extends StatefulWidget {
  final String? videoUrl;
  final String? file;
  const VideoPlayerEditReelWidget({super.key, required this.videoUrl, this.file});

  @override
  State<VideoPlayerEditReelWidget> createState() => _VideoPlayerEditReelWidgetState();
}

class _VideoPlayerEditReelWidgetState extends State<VideoPlayerEditReelWidget> {
  late VideoPlayerController _controller;
  bool showPlayPause = false;
  bool isInitialized = false;
  @override
  void initState() {
    super.initState();
    // 🔹 إذا عندي رابط إنترنت
    if (widget.videoUrl != null) {
      _controller = VideoPlayerController.network(widget.videoUrl!);
    }
    // 🔹 إذا عندي ملف محلي
    else if (widget.file != null) {
      _controller = VideoPlayerController.file(File(widget.file!));
    } else {
      throw Exception(" videoUrl / filePath");
    }

    // _controller = VideoPlayerController.network(widget.videoUrl)
    _controller.initialize().then((_) {
      setState(() => isInitialized = true);
      _controller.play();
    });
  }

  // ✅ بدل dispose بخاصية pause فقط
  void checkVisibility(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObject = context.findRenderObject();
      if (renderObject is RenderBox) {
        final visibility = renderObject.localToGlobal(Offset.zero).dy;
        final screenHeight = MediaQuery.of(context).size.height;

        if (visibility + renderObject.size.height < 0 ||
            visibility > screenHeight) {
          if (_controller.value.isInitialized && _controller.value.isPlaying) {
            _controller.pause();
          }
        }
      }
    });
  }

  void _togglePlayPause() {
    if (!_controller.value.isInitialized) return;

    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      showPlayPause = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => showPlayPause = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // فقط هون نعمل dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkVisibility(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(alignment: Alignment.center,
          
          
            width: double.infinity,
            height: 700.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)

              
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_controller.value.isInitialized)
                  ClipRRect(
                    borderRadius:BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 9.w / 16.h,
                      child: VideoPlayer(_controller),
                    ),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xff349A51)),
                  ),

                if (showPlayPause)
                  Container(
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white.withOpacity(0.8),
                    ),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}