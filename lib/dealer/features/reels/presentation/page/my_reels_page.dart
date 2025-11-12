import 'package:dio/dio.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../data/remoute_data_reels_source.dart';
import '../manager/reels_state_cubit.dart';
import '../widget/reels_card_widget.dart';
import 'add_reels_page.dart';

class MyReelsPage extends StatelessWidget {
  const MyReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReelsStateCubit(appLocator<remouteDataReelsSource>())..getDataReels(),
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
            body: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocConsumer<ReelsStateCubit, reelsState>(
                      listener: (context, state) {
                        if (state.isSuccess == true) {
                          BlocProvider.of<ReelsStateCubit>(
                            context,
                          ).getDataReels();
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: CustomSnakeBar(
                          //       text: 'add Reel is success',
                          //     ),
                          //     backgroundColor:
                          //         Colors.transparent, // ⬅️ جعل الخلفية شفافة
                          //     elevation: 0,
                          //     behavior: SnackBarBehavior.floating,
                          //     margin: EdgeInsets.only(
                          //       top: 20, // مسافة من الأعلى
                          //       left: 10,
                          //       right: 10,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                      builder: (context, state) {
                        if (state.isLoading == true) {
                          return SizedBox(
                            height: 300.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        } else if (state.error != null) {
                          return SizedBox(
                            height: 300.h,
                            child: Center(child: Text(state.error!)),
                          );
                        } else if (state.allReels == null ||
                            state.allReels.isEmpty) {
                          return SizedBox(
                            height: 300.h,
                            child: Container(
                              child: Text('No Reel available'),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            // Row(
                            //   children: [
                            //     DropdownButtonFormField(
                            //       items: [
                            //         // DropdownMenuItem(child: )
                            //       ],
                            //       onChanged: (value) {},
                            //     ),
                            //     IconButton(
                            //       onPressed: () {
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) => AddReelsPage(),
                            //           ),
                            //         );
                            //       },
                            //       icon: Icon(Icons.add),
                            //     ),
                            //   ],
                            // ),
                            // ...List.generate(state.allReels.length, (i) {
                            //   return ReelCardWidget(item: state.allReels[i]);
                            // }),
                            Expanded(
                              child: SizedBox(
                                height: 500.h,
                                child: ListView.builder(
                                  itemCount: state.allReels.length,
                                  itemBuilder: (context, index) {
                                    return ReelCardWidget(
                                      item: state.allReels[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 30.w,
                  bottom: 30.h,
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddReelsPage()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(Icons.add, color: Colors.white),
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
            ),
          );
        },
      ),
    );
  }
}
