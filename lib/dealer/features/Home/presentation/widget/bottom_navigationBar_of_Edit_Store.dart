import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/style/app_Colors.dart';
import 'Custom_Button_With_icon.dart';

class BottonNavigationOfEditStore extends StatefulWidget {
  BottonNavigationOfEditStore({
    super.key,
    required this.isAvaialble,
    required this.name,
    required this.descraption,
    required this.phone,
    required this.email,
    required this.location,
    required this.linkGoogle,
    required this.onTap, required this.reset,
  });
  late bool isAvaialble;
  final String name;
  final String descraption;
  final String phone;
  final String email;
  final String location;
  final String linkGoogle;
  final Function() onTap;
  final Function() reset;
  @override
  State<BottonNavigationOfEditStore> createState() =>
      _BottonNavigationOfEditStoreState();
}

class _BottonNavigationOfEditStoreState
    extends State<BottonNavigationOfEditStore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      width: double.infinity,
      height: 160.h,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderColor, width: 1)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomButtonWithIcon(
            iconButton: Icons.save,
            type: 'Save Changes',
            ontap: () {
              // print(widget.isAvaialble);
              print(widget.name);
              widget.onTap();
              print(widget.descraption);
              print(widget.email);
              print(widget.email);
            },
          ),
      SizedBox(
        height: 10.h,
      
      )
          ,Row(
            children: [
              Expanded(
                child: GestureDetector(onTap: () {
                     widget. reset();
                  
                },
                  child: Container(
                    // width: 173.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Color(0xffF3F4F6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.replay, color: Color(0xff4B5563), size: 20),
                        Text(
                          ' Reset',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    // width: 173.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Color(0xffFEF2F2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Color(0xffDC2626), size: 20),
                        Text(
                          ' cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xffDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
