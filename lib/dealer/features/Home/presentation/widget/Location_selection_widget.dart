import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../page/google_map.dart';

class locationSelectWidget extends StatelessWidget {
  const locationSelectWidget({
    super.key,
    required this.location,
    required this.linkGoogle,
    required this.lat,
    required this.lon,
  });

  final TextEditingController location;
  final TextEditingController linkGoogle;
  final Function(String value) lat;
  final Function(String value) lon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      width: 358.w,
      // height: 124.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // SvgPicture.asset('assets/icons/svg.svg'),
              Icon(Icons.location_pin, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text('Location', style: AppTextStyle.poppins514),
              Text('*', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
          SizedBox(height: 17.h),

          InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    lat: (value) {
                      lat(value);
                    },
                    lon: (value) {
                      lon(value);
                    },
                  ),
                ),
              );
              // final LatLng? result = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const FlutterMapPicker(),
              //   ),
              // );

              // if (result != null) {
              //   print(
              //     "تم اختيار الموقع: ${result.latitude}, ${result.longitude}",
              //   );
              //   // تقدر تخزنها أو تعرضها في TextField مثلاً
              // }
            },
            child: Container(
              width: 324.w,
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('📍 Select location on map'),
                  Icon(Icons.location_pin, color: AppColors.primary),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderColor),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: 324.w,
            height: 50.h,
            child: TextFormField(
              controller: location,
              decoration: InputDecoration(
                hintText: '123 Main Street, Cairo, Egypt',
              ),
            ),
          ),

          SizedBox(height: 12.h),
          // SizedBox(
          //   width: 324.w,
          //   height: 50.h,
          //   child: TextFormField(
          //     controller: linkGoogle,
          //     decoration: InputDecoration(
          //       hintText: 'Google Maps link (optional)',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
