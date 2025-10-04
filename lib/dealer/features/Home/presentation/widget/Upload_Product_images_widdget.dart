import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';

class uploadProductImagesWidget extends StatelessWidget {
  uploadProductImagesWidget({super.key, required this.Setimage});
  final Function(XFile? value) Setimage;
  ValueNotifier<XFile?> imagedata = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      width: 358.w,
      // height: 124.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.image, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                'product images',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
              ),
              Text('*', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
          SizedBox(height: 17.h),
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              Setimage(image);
              imagedata.value = image;
            },
            child: ValueListenableBuilder(
              valueListenable: imagedata,
              builder: (context, value, child) {
                if (value != null) {
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
                        File(value.path),
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        height: 170.h,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 27.h),
                    width: 324.w,
                    // height: 128.h,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/cloud.svg'),
                          Text(
                            'Drag & drop images here',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff4B5563),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'or ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color(0xff9CA3AF),
                                ),
                              ),
                              Text(
                                'browse files',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.h),
                      border: Border.all(
                        width: 1,
                        color: AppColors.borderColor,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
