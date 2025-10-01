import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/reel_model.dart';
import 'reel_grid_item.dart';

class ReelsGridWidget extends StatelessWidget {
  final List<ReelModel> reels;

  const ReelsGridWidget({
    super.key,
    required this.reels,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.8,
      ),
      itemCount: reels.length,
      itemBuilder: (context, index) {
        return ReelGridItem(reel: reels[index]);
      },
    );
  }
}
