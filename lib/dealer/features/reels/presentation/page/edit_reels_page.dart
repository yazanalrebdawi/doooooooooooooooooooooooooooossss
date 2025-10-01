import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Custom_Button_With_icon.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_form_with_title.dart';
import 'package:dooss_business_app/dealer/features/reels/data/models/Reels_data_model.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/manager/reels_state_cubit.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/Custom_app_bar.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/Custom_uplaod_video.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/UploadVidoeWidget.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/current_reel_edit_widget.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/edit_details_widget.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/time_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditReelsPage extends StatefulWidget {
  EditReelsPage({
    super.key,
    required this.item,
    required this.title,
    required this.descraption,
  });
  final ReelDataModel item;
  final TextEditingController title;
  final TextEditingController descraption;
  @override
  State<EditReelsPage> createState() => _EditReelsPageState();
}

class _EditReelsPageState extends State<EditReelsPage> {
  late String? video;
  @override
  void initState() {
    video = widget.item.video;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        ontap: () {
          BlocProvider.of<ReelsStateCubit>(context).getDataReels();
        },
        title: 'Edit Reel',
        subtitle: 'Manage your content',
        backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: currentReelEditWidget(),
            ),
            Divider(height: 1, color: AppColors.borderColor),
            editDetailsWidget(
              title: widget.title,
              descraption: widget.descraption,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(height: 1.5, color: AppColors.borderColor),
            ),

            replaceVideoWidget(),

            Center(
              child: CustomUploadVideoWidget(
                video: (value) {
                  print('****');
                  print(value!.path);
                  video = value.path;
                  print('****');
                },
              ),
            ),
            CustomButtonWithIcon(
              type: 'Save EditsReel',
              iconButton: Icons.save,
              ontap: () {
                print(video);

                BlocProvider.of<ReelsStateCubit>(context).EditDataReel(
                  widget.item.id,
                  widget.title.text,
                  widget.descraption.text,
                  video!,
                  widget.item.thumbnail,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class replaceVideoWidget extends StatelessWidget {
  const replaceVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Replace Video (Optional)', style: AppTextStyle.poppins514),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            // height: 58.h, // ⬅️ الطول المطلوب
            width: 358.w, // ⬅️ أو أي عرض تريده
            decoration: BoxDecoration(
              color: Color(0xffFEFCE8), // ⬅️ لون الخلفية (اختياري)
              borderRadius: BorderRadius.circular(8.r), // ⬅️ حواف دائرية
              border: Border.all(
                color: const Color(0xffFEF08A), // ⬅️ لون الإطار
                width: 1, // ⬅️ سمك الإطار
              ),
              // لا تضع boxShadow => بدون ظل
            ),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.warning_rounded, color: Color(0xffCA8A04)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Replacing video will reset all engagement stats',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff854D0E),
                            fontFamily: 'poppins',
                          ),
                        ),
                        Text(
                          'Views, likes, and comments will be lost permanently',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff854D0E),
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
