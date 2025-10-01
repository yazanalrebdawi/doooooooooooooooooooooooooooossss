import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';

class DropDownField extends StatefulWidget {
  final String hintText;
  final List<String> listOptions;

  const DropDownField({
    super.key,
    required this.hintText,
    required this.listOptions,
  });

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String? countrySelected;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.field,
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        borderRadius: BorderRadius.circular(20),
        focusColor: AppColors.white,
        // value: countrySelected,
        hint:  Text(widget.hintText),
        items: [
          ...widget.listOptions.map(
                (country) => DropdownMenuItem(
              value: country,
              child: Text(country.toString()),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            countrySelected = value;
          });
        },
      ),
    );
  }
}
