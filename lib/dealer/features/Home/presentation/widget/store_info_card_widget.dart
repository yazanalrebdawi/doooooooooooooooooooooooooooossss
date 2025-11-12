import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'status_Card.dart';

class StoreInfoCardWidget extends StatefulWidget {
  StoreInfoCardWidget({super.key, required this.infoStore});
  final List<StoreInfoState> infoStore;
  @override
  State<StoreInfoCardWidget> createState() => _StoreInfoCardWidgetState();
}

class _StoreInfoCardWidgetState extends State<StoreInfoCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      margin: EdgeInsets.all(16),
      height: 150.h,
      padding: EdgeInsets.only(top: 5),
      child: Center(
        child: GridView.builder(
          itemCount: 2,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // mainAxisSpacing: 1.w,
            // crossAxisSpacing: 1.h,
            childAspectRatio: 173.w / 114.h,
          ),
          itemBuilder: (context, i) {
            return StatCard(
              icon: widget.infoStore[i].icon,
              label: widget.infoStore[i].labal,
              value: widget.infoStore[i].value,
              warning: false,
            );
          },
        ),
      ),
    );
  }
}

class StoreInfoState {
  final String icon;
  final String labal;
  final int value;

  StoreInfoState({
    required this.icon,
    required this.labal,
    required this.value,
  });
}
