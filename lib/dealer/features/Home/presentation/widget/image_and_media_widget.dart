import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';

class imageAndMediaWidget extends StatefulWidget {
  const imageAndMediaWidget({super.key});

  @override
  State<imageAndMediaWidget> createState() => _imageAndMediaWidgetState();
}

class _imageAndMediaWidgetState extends State<imageAndMediaWidget> {
  ValueNotifier<List<XFile>> images = ValueNotifier<List<XFile>>([]);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(24, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text('images & media', style: AppTextStyle.Poppins718),
              ],
            ),
          ),
          Divider(color: AppColors.borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<List<XFile>>(
                  builder: (BuildContext context, value, child) {
                    if (images.value.isEmpty) {
                      return UoloadServicesImageWidget(images: images);
                    } else
                      return Container(
                        height: 170.h,
                        alignment: Alignment.center,
                        width: 326.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/OliFilter.png',
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              height: 170.h,
                            )),
                      );
                  },
                  valueListenable: images,
                ),
                SizedBox(height: 16.h),
                Text(
                  'intro video (Optional)',
                  style: AppTextStyle.poppins514BlueDark,
                ),
                SizedBox(height: 8.h),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 26.h),
                  width: 326.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.videocam,
                        color: AppColors.silverDark,
                        size: 38,
                      ),
                      Text(
                        'MP4 • Max 30MB • 30 seconds max',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.silverDark,
                          fontFamily: 'poppins',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add Video',
                        style: AppTextStyle.poppins514primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UoloadServicesImageWidget extends StatelessWidget {
  const UoloadServicesImageWidget({super.key, required this.images});

  final ValueNotifier<List<XFile>> images;

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
          SvgPicture.asset('assets/icons/cloud.svg'),
          Text(
            'Upload Car images',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff4B5563),
              fontFamily: 'poppins',
            ),
          ),
          Text(
            'Up to 10 images • JPG, PNG • Max 5MB each',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.silverDark,
              fontFamily: 'poppins',
            ),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final List<XFile> pickedImages = await picker.pickMultiImage();
              if (pickedImages.isNotEmpty) {
                final remainingSlots = 10 - images.value.length;
                final imagesToAdd = pickedImages.take(remainingSlots).toList();
                images.value = [...images.value, ...imagesToAdd];
              }
            },
            child: Container(
              width: 142.w,
              height: 36.h,
              alignment: Alignment.center,
              child: Text(
                'Choose images',
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
