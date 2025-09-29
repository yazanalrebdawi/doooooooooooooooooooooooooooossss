// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_label_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/input_name_widget.dart';

class FormEditProfileWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController cityController;

  const FormEditProfileWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        spacing: 3.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputLabelWidget(label: "Full Name"),
          InputNameWidget(
            controller: nameController,
            hintText: "Cardealer_uae",
          ),
          SizedBox(height: 10.h),
          InputLabelWidget(label: "Phone Number"),
          InputNumberWidget(
            controller: phoneController,
            hintText: "+971 50 123 4567",
          ),
          // SizedBox(height: 10.h),
          // InputLabelWidget(label: "Location (optional)"),
          // DropdownInputField(
          //   controller: cityController,
          //   hintText: "Select City",
          //   options: ["Damascus", "Homs", "Aleppo", "Latakia"],
          // ),
        ],
      ),
    );
  }
}
