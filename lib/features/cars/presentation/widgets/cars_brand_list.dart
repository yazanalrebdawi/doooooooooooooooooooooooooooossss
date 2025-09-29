import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarsBrandList extends StatelessWidget {
  const CarsBrandList({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = [
      'assets/images/bmw_logo.png',
      // 'assets/images/suzuki_logo.png',
      // 'assets/images/toyota_logo.png',
      // 'assets/images/honda_logo.png',
      'assets/images/nissan_logo.png',
      'assets/images/volvo_logo.png',
      'assets/images/audi_logo.png',
      // 'assets/images/mazda_logo.png',
      // 'assets/images/hyundai_logo.png',
      // 'assets/images/kia_logo.png',
      // 'assets/images/ford_logo.png',
      // 'assets/images/chevrolet_logo.png',
      'assets/images/volkswagen_logo.png',
      'assets/images/mercedes_logo.png',
    ];
    return SizedBox(
      height: 40.h,
      // width: 49.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(brands[index]),
          );
        },
      ),
    );
  }
} 