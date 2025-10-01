import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/network/service_locator.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Custom_Button_With_icon.dart';
import 'package:dooss_business_app/dealer/features/reels/data/remoute_data_reels_source.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/manager/reels_state_cubit.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/add_Reel_Details.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/attach_product_services.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/preview_add_reel.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/publishing_option_widget.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/up;oad_reel_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddReelsPage extends StatelessWidget {
  AddReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController();
    TextEditingController descraption = TextEditingController();
    return BlocProvider(
      create: (context) => ReelsStateCubit(getIt<remouteDataReelsSource>()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            // bottomNavigationBar: BlocBuilder<ReelsStateCubit, reelsState>(
            //   builder: (context, state) {
            //     return CustomButtonWithIcon(
            //       type: 'add reel',
            //       iconButton: Icons.add,
            //       ontap: () {
            //         print(state.video!.path);
            //         // remouteDataReelsSource(dio: Dio()).addNewReels(state.video);
            //       },
            //     );
            //   },
            // ),
            appBar: AppBar(
              backgroundColor: Color(0xffffffff),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<ReelsStateCubit>(context).getDataReels();
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: Text(
                'Add New Reel',
                style: AppTextStyle.poppins418blueBlack,
              ),
              centerTitle: true,
            ),
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    UploadReelWidget(video: (value) {}),
                    addReelDetailsWidget(
                      title: title,
                      descraption: descraption,
                    ),
                    // attachProductOrService(),
                    // PublishingOptionsWidget(),
                    // preview_add_reel_widget(),
                    BlocBuilder<ReelsStateCubit, reelsState>(
                      builder: (context, state) {
                        return CustomButtonWithIcon(
                          type: 'add reels',
                          iconButton: Icons.add,
                          ontap: () {
                            print(state.video!.path);
                            remouteDataReelsSource(dio: Dio()).addNewReel(
                              state.video,
                              title.text,
                              descraption.text,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
