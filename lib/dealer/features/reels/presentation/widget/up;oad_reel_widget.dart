import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/Custom_uplaod_video.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadReelWidget extends StatelessWidget {
  UploadReelWidget({super.key, required this.video});
  final Function(XFile? value) video;
  ValueNotifier<XFile> thumbnail = ValueNotifier(XFile(''));
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      width: 358.w,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2.r,
            color: Color.fromARGB(24, 0, 0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Reel', style: AppTextStyle.poppins416blueBlack),
          SizedBox(height: 12.h),
          CustomUploadVideoWidget(
            video: (value) {
              video(value);
            },
          ),
          // SizedBox(height: 16.h),
          // Text('Thumbnail', style: AppTextStyle.poppins414BD),
          // SizedBox(height: 9.h),
          // Row(
          //   children: [
          //     // ...List.generate(1, (i) {
          //     ValueListenableBuilder(
          //       valueListenable: thumbnail,
          //       builder: (context, value, child) {
          //         return Container(
          //           margin: EdgeInsets.only(right: 8),
          //           width: 64.w,
          //           height: 64.w,
          //           decoration: BoxDecoration(
          //             border: Border.all(color: AppColors.borderColor),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: Center(
          //             child: Icon(Icons.photo, color: AppColors.silverDark),
          //           ),
          //         );
          //       },
          //     ),
          //     // }),
          //     GestureDetector(
          //       onTap: () async {
          //         final ImagePicker picker = ImagePicker();
          //         final XFile? image = await picker.pickImage(
          //           source: ImageSource.gallery,
          //         );
          //       },
          //       child: Container(
          //         width: 64.w,
          //         height: 64.w,
          //         decoration: BoxDecoration(
          //           border: Border.all(color: AppColors.borderColor),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Center(
          //           child: Icon(Icons.add, color: AppColors.silverDark),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Text(
          //   'Auto-generated or upload custom',
          //   style: AppTextStyle.intel412gray,
          // ),
        ],
      ),
    );
  }
}
