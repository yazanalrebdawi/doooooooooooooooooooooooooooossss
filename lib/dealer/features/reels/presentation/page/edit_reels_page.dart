import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../Home/presentation/page/edit_Prodect_page.dart';
import '../../../Home/presentation/widget/Custom_Button_With_icon.dart';
import '../../data/models/Reels_data_model.dart';
import '../manager/reels_state_cubit.dart';
import '../widget/Custom_app_bar.dart';
import '../widget/Custom_uplaod_video.dart';
import '../widget/current_reel_edit_widget.dart';
import '../widget/edit_details_widget.dart';

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
  late String video;
  @override
  void initState() {
    video = widget.item.video ?? '';
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
        child: BlocListener<ReelsStateCubit, reelsState>(
          listener: (context, State) {
            if (State.isSuccess == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomSnakeBar(
                    // isFailure: true,
                    text: 'editing reel is success',
                  ),
                  backgroundColor: Colors.transparent, // ⬅️ جعل الخلفية شفافة
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    top: 20, // مسافة من الأعلى
                    left: 10,
                    right: 10,
                  ),
                ),
              );
              BlocProvider.of<ReelsStateCubit>(context).getDataReels();
              Navigator.pop(context);
            }
            if (State.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: CustomSnakeBar(
                    isFailure: true,
                    text: 'edit reel .error',
                  ),
                  backgroundColor: Colors.transparent, // ⬅️ جعل الخلفية شفافة
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(
                    top: 20, // مسافة من الأعلى
                    left: 10,
                    right: 10,
                  ),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: currentReelEditWidget(link: video),
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
              SizedBox(height: 12.h,),

              Center(
                child: CustomUploadVideoWidget(
                  video: (value) {
                    print('****');

                    // setState(() {
                    print(value!.path);
                    video = value.path;
                    // });

                    print('****');
                  },
                ),
              ),
              SizedBox(height: 16.h,),
              Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
                  child: CustomButtonWithIcon(
                    type: 'Save Edits Reel',
                    iconButton: Icons.save,
                    ontap: () {
                      print(video);
                  
                      BlocProvider.of<ReelsStateCubit>(context).EditDataReel(
                        widget.item.id,
                        widget.title.text,
                        widget.descraption.text,
                        video,
                        widget.item.thumbnail,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
