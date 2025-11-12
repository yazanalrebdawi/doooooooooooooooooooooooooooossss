import 'dart:io';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddImagesCar extends StatelessWidget {
  AddImagesCar({super.key, required this.images});

  XFile? image = XFile('');
  ValueNotifier<List<XFile>> allImages = ValueNotifier([]);
  final Function(List<XFile> value) images;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<XFile>>(
      valueListenable: allImages,
      builder: (context, value, child) {
        print('👌👌 rebuild widget ${value.length}');
        return Column(
          children: [
            ...List.generate(value.length, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                height: 170.h,
                alignment: Alignment.center,
                width: 326.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(value[index].path),
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                        height: 170.h,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          final newList = List<XFile>.from(allImages.value);
                          newList.removeAt(index);
                          allImages.value = newList;
                          images(allImages.value);
                        },
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Container(
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
                      if (allImages.value.length >= 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Maximum 10 images allowed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      final ImagePicker picker = ImagePicker();
                      image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        final newList = List<XFile>.from(allImages.value)
                          ..add(image!);
                        allImages.value = newList;
                        images(allImages.value);
                        print('✅✅✅✅${allImages.value.length} images added');
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
            ),
          ],
        );
      },
    );
  }
}
