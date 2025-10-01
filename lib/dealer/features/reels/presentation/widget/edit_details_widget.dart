import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_form_with_title.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/time_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class editDetailsWidget extends StatelessWidget {
  const editDetailsWidget({
    super.key,
    required this.title,
    required this.descraption,
  });
  final TextEditingController title;
  final TextEditingController descraption;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Details', style: AppTextStyle.poppins514),
            SizedBox(height: 16.w),
            CustomFormWithTitleWidget(
              model: title,
              hintForm: 'title reel',
              title: ' Title',
              wid: double.infinity,
            ),
            SizedBox(height: 16.h),
            CustomFormWithTitleWidget(
              model: descraption,
              hintForm:
                  'Summer collection is here! Check out our\nlatest styles 🌟 #fashion #summer #style',
              title: ' Caption',
              lineNum: 3,
              wid: double.infinity,
            ),
            // SizedBox(height: 16.h),
            // Text('Edit Details', style: AppTextStyle.poppins514),
            // SizedBox(height: 10.w),
            // Row(
            //   children: [
            //     ...List.generate(3, (i) {
            //       return Container(
            //         margin: EdgeInsets.only(right: 8.w),
            //         height: 26.h, // ارتفاع الـ Container
            //         width: 92.w, // يمكن تغييره حسب الحاجة
            //         decoration: BoxDecoration(
            //           color: AppColors.lightGreen, // لون الخلفية
            //           borderRadius: BorderRadius.circular(
            //             100,
            //           ), // حواف مدورة صغيرة (اختياري)
            //         ),
            //         child: Center(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 '#fashion ',
            //                 style: AppTextStyle.poppins412Primary,
            //               ),
            //               Icon(Icons.close, color: AppColors.primary, size: 15),
            //             ],
            //           ),
            //         ),
            //       );
            //     }),
            //   ],
            // ),

            // SizedBox(height: 8.h),
            // TextFormField(
            //   controller: TextEditingController(),
            //   decoration: InputDecoration(hintText: 'add hashtag.....'),
            // ),
            // SizedBox(height: 16.h),
            // Text('Thumbnail', style: AppTextStyle.poppins514),
            // SizedBox(height: 10.h),
            // Row(
            //   children: [
            //     Container(
            //       // width: double
            //       //     .infinity, // عرض الـ Container الكامل أو حسب الحاجة
            //       // height: 200, // ارتفاع الـ Container الرئيسي
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: NetworkImage(
            //             'https://via.placeholder.com/400',
            //           ), // ضع رابط الصورة أو Asset
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       child: Center(
            //         child: Container(
            //           width: 64, // طول الضلع
            //           height: 64, // طول الضلع
            //           decoration: BoxDecoration(
            //             color: Colors.white, // لون المربع الداخلي
            //             borderRadius: BorderRadius.circular(8), // حواف مدورة 8
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withOpacity(0.2),
            //                 blurRadius: 4,
            //                 offset: Offset(0, 2),
            //               ),
            //             ],
            //           ),

            //           // child: Center(
            //           //   child: Icon(
            //           //     Icons.star, // أيقونة أو محتوى داخل المربع
            //           //     color: Colors.blue,
            //           //   ),
            //           // ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 12.w),
            //     Container(
            //       alignment: Alignment.center,
            //       width: 282.w,
            //       height: 48.h,
            //       // padding: EdgeInsets.symmetric(
            //       //   horizontal: 16,
            //       //   vertical: 8,
            //       // ), // مساحة داخلية
            //       decoration: BoxDecoration(
            //         color: AppColors.silver, // لون خلفية الـ Container
            //         border: Border.all(
            //           color: AppColors.borderColor, // لون الحواف
            //           width: 1.5, // سمك الحواف
            //         ),
            //         borderRadius: BorderRadius.circular(8), // حواف مدورة
            //       ),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(
            //             Icons.photo_camera_rounded, // الأيقونة
            //             color: AppColors.BlueDark,
            //           ),
            //           SizedBox(width: 8), // مسافة بين الأيقونة والنص
            //           Text(
            //             ' Change Thumbnail',
            //             style: AppTextStyle.poppins414BlueDark,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16.h),
            // Text('Linked Product/Service', style: AppTextStyle.poppins514),
            // SizedBox(height: 12.h),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
            //   alignment: Alignment.center,
            //   width: 358.w,
            //   // height: 74.h,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.borderColor),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Container(
            //             // width: double
            //             //     .infinity, // عرض الـ Container الكامل أو حسب الحاجة
            //             // height: 200, // ارتفاع الـ Container الرئيسي
            //             decoration: BoxDecoration(
            //               image: DecorationImage(
            //                 image: NetworkImage(
            //                   'https://via.placeholder.com/400',
            //                 ), // ضع رابط الصورة أو Asset
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //             child: Center(
            //               child: Container(
            //                 width: 48, // طول الضلع
            //                 height: 48, // طول الضلع
            //                 decoration: BoxDecoration(
            //                   color: Colors.white, // لون المربع الداخلي
            //                   borderRadius: BorderRadius.circular(
            //                     8,
            //                   ), // حواف مدورة 8
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.black.withOpacity(0.2),
            //                       blurRadius: 4,
            //                       offset: Offset(0, 2),
            //                     ),
            //                   ],
            //                 ),
            //                 // child: Center(
            //                 //   child: Icon(
            //                 //     Icons.star, // أيقونة أو محتوى داخل المربع
            //                 //     color: Colors.blue,
            //                 //   ),
            //                 // ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 12.w),
            //           Column(
            //             children: [
            //               Text(
            //                 'Summer Dress Collection',
            //                 style: AppTextStyle.poppins514,
            //               ),
            //               Text(
            //                 '\$49.99 - \$89.99',
            //                 style: AppTextStyle.intel412gray,
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //       Text('Change', style: AppTextStyle.poppins514primaryColor),
            //     ],
            //   ),
            // ),
            SizedBox(height: 16.h),
            Text('Schedule', style: AppTextStyle.poppins514),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: SelectDateWidget(
                    EditData: (Date) {
                      print(Date);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TimePickerWidget(
                    editDateValue: (v) {
                      print(v);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
