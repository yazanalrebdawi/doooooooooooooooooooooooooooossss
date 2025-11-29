import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../data/remouteData/home_page_state.dart';
import '../manager/home_page_cubit.dart';
import '../page/edit_Profile_page.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({super.key});
  bool isWithinRange(DateTime start, DateTime end) {
  DateTime now = DateTime.now(); // الوقت الحالي
  return now.isAfter(start) && now.isBefore(end);
}
bool isNowInSchedule({
  required List<String> daysList, // مثال: ["sun", "mon", "tue"]
  required String startTime,      // مثال: "09:00"
  required String endTime,        // مثال: "18:00"
}) {
  // تحويل الأيام لأحرف صغيرة
  final days = daysList.map((d) => d.toLowerCase().trim()).toList();

  // جلب اليوم الحالي (0=Mon ... 6=Sun)
  final now = DateTime.now();
  final weekDays = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
  final today = weekDays[now.weekday - 1];

  // إذا اليوم الحالي مش ضمن الأيام المطلوبة -> false
  if (!days.contains(today)) return false;

  // تحويل أوقات البداية والنهاية
  final startParts = startTime.split(':').map(int.parse).toList();
  final endParts = endTime.split(':').map(int.parse).toList();

  final start = DateTime(now.year, now.month, now.day, startParts[0], startParts[1]);
  final end = DateTime(now.year, now.month, now.day, endParts[0], endParts[1]);

  // إذا البداية < النهاية (مثال: 09:00 - 18:00)
  if (start.isBefore(end)) {
    return now.isAfter(start) && now.isBefore(end);
  }

  // إذا الفترة تتجاوز منتصف الليل (مثال: 22:00 - 02:00)
  return now.isAfter(start) || now.isBefore(end);
}


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomepageState>(
      builder: (context, state) {
        
        return Container(
          width: 358.w,
          height: 100.h,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ), //////////////////////
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                blurRadius: 4.r,
                spreadRadius: 0,
                offset: Offset(0, 2),
                color: Color.fromARGB(7, 0, 0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(),
                    width: 21.w,
                    height: 27.w,
                    // child: Icon(Icons.shopping_bag,color: Colors.white,),
                    child: SvgPicture.asset(
                      'assets/icons/svg.svg',
                      width: 21.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (state.dataStore.name.isEmpty) ? "Auto Parts Store" : state.dataStore.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 48.w,
                            alignment: Alignment.center,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: state.dataStore.isStoreOpen 
                                  ? AppColors.lightGreen 
                                  : AppColors.redLight,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              state.dataStore.isStoreOpen ? 'Open' : 'Close',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: state.dataStore.isStoreOpen 
                                    ? Color(0xff16A34A) 
                                    : AppColors.red,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 100.w,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              state.dataStore.locationAddress,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<HomePageCubit>(context),
                        child: EditStoreProfile(
                          lat: state.dataStore.latitude.toString(),
                          log: state.dataStore.longitude.toString(),
                          closeTime: state.dataStore.closingTime,
                          openTime: state.dataStore.openingTime,
                          storeDescription: TextEditingController(
                            text: state.dataStore.storeDescription,
                          ),
                          phone: TextEditingController(
                            text: state.dataStore.phone,
                          ),
                          storeName: TextEditingController(
                            text: state.dataStore.name,
                          ),
                          location: TextEditingController(
                            text: state.dataStore.locationAddress,
                          ),
                          email: TextEditingController(
                            text: state.dataStore.googleMapsLink,
                          ),
                        ),
                      ),
                    ),
                  );
                },

                child: Container(
                  alignment: Alignment.center,
                  width: 68.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(Icons.edit_calendar_rounded,color: Colors.white,size: 18.r,),
                      SvgPicture.asset('assets/icons/edit.svg', width: 14),
                      // SizedBox(width: ,)
                      Text(
                        ' Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
