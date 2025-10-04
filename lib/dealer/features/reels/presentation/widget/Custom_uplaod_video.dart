import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../manager/reels_state_cubit.dart';

class CustomUploadVideoWidget extends StatefulWidget {
  CustomUploadVideoWidget({super.key, required this.video});
  final Function(XFile? value) video;
  @override
  State<CustomUploadVideoWidget> createState() =>
      _CustomUploadVideoWidgetState();
}

class _CustomUploadVideoWidgetState extends State<CustomUploadVideoWidget> {
  ValueNotifier<XFile?> image = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 26.h),
      width: 326.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(Icons.videocam, color: AppColors.silverDark, size: 32),
          ValueListenableBuilder(
            valueListenable: image,
            builder: (context, value, child) {
              if (value != null) {
                return Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_done_outlined,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Upload Video is success',
                      style: AppTextStyle.poppinsw416Gray,
                    ),
                       SizedBox(height: 12.h),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Text(
                      'Tap to upload or drag & drop',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff4B5563),
                        fontFamily: 'poppins',
                      ),
                    ),
                    Text(
                      '.mp4 / .mov • Max 60s • Max 100MB',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.silverDark,
                        fontFamily: 'poppins',
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                );
              }
            },
          ),

          InkWell(
            onTap: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? galleryVideo = await _picker.pickVideo(
                source: ImageSource.gallery,
                preferredCameraDevice: CameraDevice.rear,
              );
              widget.video(galleryVideo);
              BlocProvider.of<ReelsStateCubit>(
                context,
              ).setVidoeValue(galleryVideo);
              print(galleryVideo!.path);
              image.value = galleryVideo;
            },
            child: Container(
              width: 142.w,
              height: 36.h,
              alignment: Alignment.center,
              child: Text(
                'Browse Files',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'poppins',
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
