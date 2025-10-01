import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/Log_in_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/home_Page1.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Change_status_store.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Custom_Button_With_icon.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Location_selection_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Select_Store_type_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/bottom_navigationBar_of_Edit_Store.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/contectI_info_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/form_edit_profile_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/upload_logo_store_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EditStoreProfile extends StatefulWidget {
  EditStoreProfile({
    super.key,
    required this.storeName,
    required this.phone,
    required this.location,
    required this.email,
    required this.storeDescription,
    required this.closeTime,
    required this.openTime,
    required this.lat,
    required this.log,
  });
  final TextEditingController storeName;
  final TextEditingController storeDescription;
  final TextEditingController phone;
  final TextEditingController location;
  final TextEditingController email;
  final String closeTime;
  final String openTime;
  final String lat;
  final String log;
  @override
  State<EditStoreProfile> createState() => _EditStoreProfileState();
}

class _EditStoreProfileState extends State<EditStoreProfile> {
  late String latValue;
  late String lonValue;
  late String close;
  late String start;
  List<String> days = [];
  @override
  void initState() {
    // TODO: implement initState
    close = widget.closeTime;
    start = widget.openTime;
    latValue = widget.lat;
    lonValue = widget.log;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late bool isAvaiable = true;
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: AppBar(),
      // bottomNavigationBar: BottonNavigationOfEditStore(isAvaialble: isAvaiable),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Center(
            child: Column(
              children: [
                formEditProfileWidget(
                  storeName: widget.storeName,
                  storeDescription: widget.storeDescription,
                ),
                // AddStoreLogoWidget(),
                ContactInfoWidget(phone: widget.phone),
                locationSelectWidget(
                  lat: (value) {
                    latValue = value;
                  },
                  lon: (value) {
                    lonValue = value;
                  },
                  location: widget.location,
                  linkGoogle: widget.email,
                ),
                // storeTypeSelectWidget(),
                changeStatusStoreWidget(
                  openungTime: (String value) {
                    start = value;
                  },
                  closeTime: (String value) {
                    close = value;
                    print(value);
                  },
                  day: (daysSelected) {
                    print(daysSelected);
                    days = daysSelected;
                  },
                ),

                // selectStoreStatus(
                //   toggleStatus: (value) {
                //     // print(value);
                //     isAvaiable = value;
                //     print(isAvaiable);
                //   },
                // ),
                BottonNavigationOfEditStore(
                  onTap: () {
                    RemouteDealerDataSource().editDataProfile(
                      widget.storeName.text,
                      widget.storeDescription.text,
                      widget.phone.text,
                      close.toString(),
                      start.toString(),
                      latValue,
                      lonValue,
                      days,
                    );
                  },
                  isAvaialble: isAvaiable,
                  name: widget.storeName.text,
                  descraption: widget.storeDescription.text,
                  phone: widget.phone.text,
                  email: widget.email.text,
                  location: widget.location.text,
                  linkGoogle: widget.email.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
