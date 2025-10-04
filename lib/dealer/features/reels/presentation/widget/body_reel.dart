import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../data/models/Reels_data_model.dart';
import '../manager/reels_state_cubit.dart';
import '../page/edit_reels_page.dart';

class bodyReel extends StatelessWidget {
  const bodyReel({super.key, required this.item});
  final ReelDataModel item;
  String _formatNumber(num number) {
    if (number >= 1000000) {
      // مليون فأكثر
      double value = number / 1000000;
      return value.toStringAsFixed(value < 10 ? 1 : 0) + 'm';
    } else if (number >= 1000) {
      // ألف فأكثر
      double value = number / 1000;
      return value.toStringAsFixed(value < 10 ? 1 : 0) + 'k';
    } else {
      // أقل من ألف
      return number.toString();
    }
  }

  String timeDiffStr(String isoString) {
    // نحول النص إلى DateTime
    DateTime inputTime = DateTime.parse(isoString);
    DateTime now = DateTime.now().toUtc();

    Duration diff = now.difference(inputTime);
    int seconds = diff.inSeconds;
    int minutes = diff.inMinutes;
    int hours = diff.inHours;
    int days = diff.inDays;

    if (seconds < 60) {
      return "${seconds} sec ago";
    } else if (minutes < 60) {
      return "${minutes}min ago";
    } else if (hours < 24) {
      return "${hours}hour ago";
    } else if (days < 7) {
      return "${days}day ago";
    } else if (days < 30) {
      return "${(days / 7).floor()}week ago ";
    } else if (days < 365) {
      return "${(days / 30).floor()}month age";
    } else {
      return "${(days / 365).floor()}year age";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'poppins',
              fontSize: 16.sp,
              color: Color(0xff111827),
            ),
          ),
          SizedBox(height: 10.h),
          // Container(
          //   alignment: Alignment.center,
          //   width: 148.w,
          //   padding: EdgeInsets.symmetric(
          //     // horizontal: 8,
          //     // vertical: 5,
          //   ),
          //   height: 26.h,
          //   decoration: BoxDecoration(
          //     color: Color.fromARGB(30, 52, 154, 81),
          //     borderRadius: BorderRadius.circular(100),
          //   ),

          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Icon(Icons.circle, color: AppColors.primary, size: 18.r),
          //       Text(
          //         ' Organic Tomatoes',
          //         style: TextStyle(
          //           fontWeight: FontWeight.w400,
          //           fontSize: 12.sp,
          //           color: AppColors.primary,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeDiffStr(item.createdAt),
                style: AppTextStyle.poppins414BlueDark,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye.svg',
                        color: Color(0xff6B7280),
                      ),
                      // Icon(
                      //   Icons.remove_red_eye,
                      //   size: 16,
                      //   color: Color(0xff6B7280),
                      // ),
                      SizedBox(width: 4.w),
                      Text(
                        ' ${_formatNumber(item.viewsCount)}',
                        style: AppTextStyle.poppins414BlueDark,
                      ),
                    ],
                  ),
                  SizedBox(width: 13.w),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<ReelsStateCubit>(
                            context,
                          ).togglelikeReel(item.id);
                        },
                        icon: Icon(
                          Icons.favorite,
                          size: 16,
                          color: item.liked ? Colors.red : Color(0xff6B7280),
                        ),
                      ),
                      Text(
                        '${_formatNumber(item.likesCount)}',
                        style: AppTextStyle.poppins414BlueDark,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<ReelsStateCubit>(context),
                          child: EditReelsPage(
                            item: item,
                            title: TextEditingController(text: item.title),
                            descraption: TextEditingController(
                              text: item.description,
                            ),
                          ),
                        ),
                      ),
                    );
                    // remouteDataReelsSource(
                    //   dio: Dio(),
                    // ).EditReel(item.id, 'ghassan', 'hallo12','','');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // width: 150,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.secondary,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(
                        //   Icons.edit_note_sharp,
                        //   size: 18,
                        //   color: AppColors.BlueDark,
                        // ),
                        SvgPicture.asset('assets/icons/edit.svg',color: AppColors.BlueDark,),
                        Text(' Edit', style: AppTextStyle.poppins414BD),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<ReelsStateCubit>(
                      context,
                    ).deleteReel(item.id);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    // width: 150,
                    height: 36.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.redLight,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, size: 18, color: AppColors.red),
                        Text(' Delete', style: AppTextStyle.poppins414Red),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
