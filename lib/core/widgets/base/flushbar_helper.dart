// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class FlushbarHelper {
//   static Flushbar? _currentFlushbar;

//   static void showFlushbar({
//     required BuildContext context,
//     String? title,
//     String? message,
//     required Color backgroundColor,
//     IconData? iconData,
//     Color iconColor = Colors.white,
//     double sizeIcon = 28,
//     required String? mainButtonText,
//     VoidCallback? mainButtonOnPressed,
//     Duration duration = const Duration(seconds: 3),
//     Color? progressColor,
//     bool isShowProgress = false,
//   }) {
//     if (_currentFlushbar != null) {
//       return;
//     }

//     _currentFlushbar = Flushbar(
//       flushbarPosition: FlushbarPosition.TOP,
//       backgroundColor: backgroundColor,
//       borderRadius: BorderRadius.circular(12.r),
//       margin: EdgeInsets.symmetric(horizontal: 10.w),
//       boxShadows: [
//         BoxShadow(
//           color: Colors.black38,
//           blurRadius: 6.r,
//           offset: Offset(0, 3),
//         ),
//       ],
//       icon: iconData != null
//           ? Icon(
//               iconData,
//               size: sizeIcon.sp,
//               color: iconColor,
//             )
//           : null,
//       title: title?.tr() ?? '',
//       titleColor: Colors.white,
//       messageText: message != null
//           ? Text(
//               message.tr(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             )
//           : null,
//       duration: duration,
//       mainButton: (mainButtonText != null && mainButtonOnPressed != null)
//           ? TextButton(
//               onPressed: () {
//                 mainButtonOnPressed();
//                 _currentFlushbar?.dismiss();
//               },
//               child: Text(
//                 mainButtonText.tr(),
//                 style: TextStyle(color: Colors.white),
//               ),
//             )
//           : null,
//       animationDuration: Duration(milliseconds: 400),
//       forwardAnimationCurve: Curves.easeIn,
//       reverseAnimationCurve: Curves.easeOut,
//       dismissDirection: FlushbarDismissDirection.HORIZONTAL,
//       showProgressIndicator: isShowProgress,
//       progressIndicatorBackgroundColor:
//           // ignore: deprecated_member_use
//           isShowProgress ? backgroundColor.withOpacity(0.5) : null,
//       progressIndicatorValueColor: isShowProgress
//           ? AlwaysStoppedAnimation<Color>(progressColor ?? Colors.white)
//           : null,
//     );

//     _currentFlushbar!.show(context).then((_) => _currentFlushbar = null);
//   }

//   //?------------------------------------------------------------------------------
//   static bool _isSnackBarShowing = false;

//   static void showSnackBar({
//     required BuildContext context,
//     required String message,
//     String? title,
//     Color backgroundColor = Colors.red,
//     Duration duration = const Duration(seconds: 3),
//     IconData? icon,
//     Color iconColor = Colors.white,
//     Color messageColor = Colors.white,
//     String? mainButtonText,
//     VoidCallback? mainButtonOnPressed,
//     int? maxLines = 1,
//   }) {
//     if (_isSnackBarShowing) return;

//     _isSnackBarShowing = true;

//     final content = Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (title != null && title.isNotEmpty)
//           Text(
//             title.tr(),
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16.sp,
//               color: Colors.white,
//             ),
//           ),
//         Row(
//           children: [
//             if (icon != null)
//               Padding(
//                 padding: EdgeInsets.only(right: 8.0.w),
//                 child: Icon(
//                   icon,
//                   color: iconColor,
//                   size: 24.sp,
//                 ),
//               ),
//             Expanded(
//               child: Text(
//                 message.tr(),
//                 maxLines: maxLines,
//                 style: TextStyle(color: messageColor),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );

//     final snackBar = SnackBar(
//       content: InkWell(
//         onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
//         child: Material(
//           color: Colors.transparent,
//           child: content,
//         ),
//       ),
//       backgroundColor: backgroundColor,
//       duration: duration,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       elevation: 6,
//       action: (mainButtonText != null && mainButtonOnPressed != null)
//           ? SnackBarAction(
//               label: mainButtonText.tr(),
//               textColor: Colors.white,
//               onPressed: () {
//                 mainButtonOnPressed();
//                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
//               },
//             )
//           : null,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
//       _isSnackBarShowing = false;
//     });
//   }
// }
