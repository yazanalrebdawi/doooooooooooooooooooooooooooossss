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
                ValueListenableBuilder<XFile?>(
                  builder: (BuildContext context, value, child) {
                    if (widget.image.value == null) {
                      return UoloadServicesImageWidget(image: widget.image);
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
                          child: Image.file(
                            File(widget.image.value!.path),
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            height: 170.h,
                          ),
                        ),
                      );
                  },
                  valueListenable: widget.image,
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