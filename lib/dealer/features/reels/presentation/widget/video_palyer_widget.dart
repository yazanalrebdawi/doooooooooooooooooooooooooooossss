import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

// class videoPlayerWidget extends StatefulWidget {
//   videoPlayerWidget({super.key, required this.Video});
//   final String Video;
//   @override
//   State<videoPlayerWidget> createState() => _videoPlayerWidgetState();
// }

// class _videoPlayerWidgetState extends State<videoPlayerWidget> {
//   final ScrollController _scrollController = ScrollController();
//   late VideoPlayerController _controller;
//   bool showPlayPause = false;
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.Video))
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//     _scrollController.addListener(() {
//       // عند أي تمرير، نوقف الفيديو ونحرر الموارد
//       if (_controller != null) {
//         _controller.pause();
//         _controller.dispose();
//       }
//     });
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//       showPlayPause = true; // إظهار الدائرة عند الضغط
//     });

//     // إخفاء الأيقونة بعد ثانيتين (اختياري)
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) setState(() => showPlayPause = false);
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _controller.dispose(); // تحرير الموارد عند غلق الصفحة
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,

//       children: [
//         GestureDetector(
//           onTap: _togglePlayPause,
//           child: Container(
//             margin: EdgeInsets.only(bottom: 14.h),
//             width: double.infinity,
//             height: 620.h,
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             // child: Center(
//             //   child: _controller.value.isInitialized
//             //       ? AspectRatio(
//             //           aspectRatio: _controller.value.aspectRatio,
//             //           child: VideoPlayer(_controller),
//             //         )
//             //       : Container(),
//             // ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // 🎥 الفيديو
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

//                 // ▶️ زر التشغيل/الإيقاف (يظهر فقط عند الضغط)
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
//         // InkWell(
//         //   onTap: () {
//         //     print(_controller.value.position);
//         //     setState(() {
//         //       _controller.value.isPlaying
//         //           ? _controller.pause()
//         //           : _controller.play();
//         //     });
//         //   },
//         //   child: Container(
//         //     width: 46.w,
//         //     height: 46.w,
//         //     decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(100),
//         //       color: Colors.white,
//         //     ),
//         //     child: Icon(
//         //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool showPlayPause = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play(); // بدء التشغيل تلقائيًا
//       });
//   }

//   // دالة للتحقق إن كان الفيديو ظاهر على الشاشة
//   void checkVisibility(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final RenderObject? renderObject = context.findRenderObject();
//       if (renderObject is RenderBox) {
//         final visibility = renderObject.localToGlobal(Offset.zero).dy;
//         final screenHeight = MediaQuery.of(context).size.height;

//         if (visibility + renderObject.size.height < 0 ||
//             visibility > screenHeight) {
//           // الفيديو خرج من الشاشة → إيقاف وتحرير الموارد
//           if (_controller.value.isInitialized) {
//             _controller.pause();
//             _controller.dispose();
//           }
//         }
//       }
//     });
//   }

//   void _togglePlayPause() {
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
//     if (_controller.value.isInitialized) _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // التحقق من ظهور الفيديو على الشاشة
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
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 // 🎥 عرض الفيديو
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

//                 // ▶️ أيقونة التشغيل/الإيقاف عند الضغط
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
class VideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final String? file;
  const VideoPlayerWidget({super.key, required this.videoUrl, this.file});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
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
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            width: double.infinity,
            height: 620.h,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_controller.value.isInitialized)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
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
