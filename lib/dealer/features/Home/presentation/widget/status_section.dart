import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/home_page_state.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/manager/home_page_cubit.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/edit_Profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({super.key});

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
                        state.dataStore!.name ?? "Auto Parts Store",
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
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Open',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xff16A34A),
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
                      builder: (context) => EditStoreProfile(
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
