
import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/Add_services_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class imageAndMediaWidget extends StatefulWidget {
  const imageAndMediaWidget({super.key});

  @override
  State<imageAndMediaWidget> createState() => _imageAndMediaWidgetState();
}

class _imageAndMediaWidgetState extends State<imageAndMediaWidget> {
  ValueNotifier<XFile?> image = ValueNotifier<XFile?>(null);
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
                ValueListenableBuilder<XFile?>(
                  builder: (BuildContext context, value, child) {
                    if (image.value == null) {
                      return UoloadServicesImageWidget(image: image);
                    } else
                   return   Container(height: 170.h,
                        alignment: Alignment.center,
                       
                        width: 326.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(borderRadius: BorderRadiusGeometry.circular(8),
                          child: Image.asset('assets/images/OliFilter.png',width: double.infinity,fit: BoxFit.fitWidth,height: 170.h,)),
                      );
                  },
                  valueListenable: image,
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
  const UoloadServicesImageWidget({super.key, required this.image});

  final ValueNotifier<XFile?> image;

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
            'Upload Service images',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff4B5563),
              fontFamily: 'poppins',
            ),
          ),
          Text(
            'Up to 5 images • JPG, PNG • Max 5MB each',
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
              image.value = await picker.pickImage(source: ImageSource.gallery);
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