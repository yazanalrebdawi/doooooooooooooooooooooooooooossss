import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/Reels_data_model.dart';
import 'body_reel.dart';
import 'video_palyer_widget.dart';

class ReelCardWidget extends StatelessWidget {
  const ReelCardWidget({super.key, required this.item});
  final ReelDataModel item;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 17, top: 6),
      width: 358.w,
      // height: 826.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 2),
            color: Color.fromARGB(21, 0, 0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          VideoPlayerWidget(videoUrl: item.video??''),
          // Container(
          //   width: double.infinity,
          //   height: 632,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.black,
          //   ),
          // ),
          bodyReel(item: item),
        ],
      ),
    );
  }
}
