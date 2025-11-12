import 'dart:io';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/image_and_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class imageAndMediaOfAddCar extends StatelessWidget {
  const imageAndMediaOfAddCar({super.key, required this.widget});

  final AddNewCarPage widget;

  // Get images from widget
  ValueNotifier<List<XFile>> get images => widget.images;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
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
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              ...images.value.map((image) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: 100.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.borderColor),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(image.path),
                                          width: 100.w,
                                          height: 100.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          final currentImages =
                                              List<XFile>.from(images.value);
                                          currentImages.remove(image);
                                          images.value = currentImages;
                                        },
                                        child: Container(
                                          width: 24.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              if (images.value.length < 10)
                                GestureDetector(
                                  onTap: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final List<XFile> pickedImages =
                                        await picker.pickMultiImage();
                                    if (pickedImages.isNotEmpty) {
                                      final currentImages =
                                          List<XFile>.from(images.value);
                                      final remainingSlots =
                                          10 - currentImages.length;
                                      final imagesToAdd = pickedImages
                                          .take(remainingSlots)
                                          .toList();
                                      currentImages.addAll(imagesToAdd);
                                      images.value = currentImages;
                                    }
                                  },
                                  child: Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.borderColor,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                      size: 32.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                  valueListenable: images,
                ),

                //<--------------------------
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//this added ----->


              // SizedBox(height: 16.h),
                // Text(
                //   'intro video (Optional)',
                //   style: AppTextStyle.poppins514BlueDark,
                // ),
                // SizedBox(height: 8.h),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.symmetric(vertical: 26.h),
                //   width: 326.w,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: AppColors.borderColor),
                //     borderRadius: BorderRadius.circular(8.r),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Icon(
                //         Icons.videocam,
                //         color: AppColors.silverDark,
                //         size: 38,
                //       ),
                //       Text(
                //         'MP4 • Max 30MB • 30 seconds max',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w400,
                //           fontSize: 12,
                //           color: AppColors.silverDark,
                //           fontFamily: 'poppins',
                //         ),
                //       ),
                //       SizedBox(height: 8.h),
                //       Text(
                //         'Add Video',
                //         style: AppTextStyle.poppins514primaryColor,
                //       ),
                //     ],
                //   ),
                // ),