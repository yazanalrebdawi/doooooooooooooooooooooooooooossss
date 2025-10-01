import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/network/service_locator.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/edit_Prodect_page.dart';
import 'package:dooss_business_app/dealer/features/reels/data/models/Reels_data_model.dart';
import 'package:dooss_business_app/dealer/features/reels/data/remoute_data_reels_source.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/manager/reels_state_cubit.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/page/add_reels_page.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/reels_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class MyReelsPage extends StatelessWidget {
  const MyReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReelsStateCubit(getIt<remouteDataReelsSource>())..getDataReels(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              elevation: 1,
              backgroundColor: AppColors.background,
              title: Text(
                'My Reels',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xff111827),
                ),
              ),
              leading: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back),
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocConsumer<ReelsStateCubit, reelsState>(
                  listener: (context, state) {
                    if (state.isSuccess == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: CustomSnakeBar(
                            text: 'Delete Reel is success',
                          ),
                          backgroundColor:
                              Colors.transparent, // ⬅️ جعل الخلفية شفافة
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
                  builder: (context, state) {
                    return Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                DropdownButtonFormField(
                                  items: [
                                    // DropdownMenuItem(child: )
                                  ],
                                  onChanged: (value) {},
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddReelsPage(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                            ...List.generate(state.allReels.length, (i) {
                              return ReelCardWidget(item: state.allReels[i]);
                            }),
                            Expanded(
                              child: SizedBox(
                                height: 500.h,
                                child: ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return ReelCardWidget(
                                      item: state.allReels[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 25.w,
                          bottom: 25.h,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReelsPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.primary,
                                border: Border.all(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
