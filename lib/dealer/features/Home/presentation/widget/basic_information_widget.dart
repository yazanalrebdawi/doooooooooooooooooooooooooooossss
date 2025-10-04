import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../user/core/utiles/validator.dart';
import '../../../../Core/style/app_text_style.dart';
import 'brand_year_selector_widget.dart';
import 'custom_form_with_title.dart';

class BasicInformtionWidget extends StatefulWidget {
  const BasicInformtionWidget({
    super.key,
    required this.model,
    required this.price,
    required this.mileage,
    required this.engineSize,
    required this.getDataBrand,
    required this.year,
    required this.status,
    //  required this.form,
  });

  final TextEditingController model;
  final TextEditingController price;
  final TextEditingController mileage;
  final TextEditingController engineSize;
  final Function(String value) getDataBrand;
  final Function(int value) year;
  final Function(String value) status;
//  final GlobalKey<FormState> form;
  @override
  State<BasicInformtionWidget> createState() => _BasicInformtionWidgetState();
}

class _BasicInformtionWidgetState extends State<BasicInformtionWidget> {
  String? isSelected;
  List<String> statusCar = List.from(['new', 'old']);
  @override
  // void initState() {
  //   super.initState();
  //   isSelected = statusCar.first; // أول عنصر من القائمة
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      // height: 515.h,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/car.svg'),
                    SizedBox(width: 8.w),
                    Text(
                      'Basic Information',
                      style: AppTextStyle.poppins718black,
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                BrandAndYearSelectorWIdget(
                  BrandSelected: (value) {
                    widget.getDataBrand(value);
                    print(value);
                  },
                  YearSelected: (value) {
                    widget.year(value);
                    print(value);
                  },
                ),
                SizedBox(height: 16.w),
                CustomFormWithTitleWidget(
                  validation: (value) {
                 return   Validator.notNullValidation(value);
                  },
                  model: widget.model,
                  title: 'Model',
                  hintForm: 'e.g., Elantra, Civic, X5',
                ),
    
                StatusCarSelectedWidget(
                  statusCar: statusCar,
                  sateus: (value) {
                    widget.status(value);
                    print(value);
                  },
                ),
    
                CustomFormWithTitleWidget(isNum: true,
                  validation: (value) {
                  return  Validator.notNullValidationValue(value);
                  },
                  model: widget.price,
                  title: 'price(USD)',
                  hintForm: '85,000',
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomFormWithTitleWidget(isNum: true,
                        validation: (value) {
                      return    Validator.notNullValidation(value);
                        },
                        model: widget.mileage,
                        title: 'Mileage (km)',
                        hintForm: '43,000',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomFormWithTitleWidget(
                        validation: (value) {
                      return    Validator.notNullValidation(value);
                        },
                        model: widget.engineSize,
                        title: 'Engine Size',
                        hintForm: '6.3L',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusCarSelectedWidget extends StatefulWidget {
  const StatusCarSelectedWidget({
    super.key,
    required this.statusCar,
    required this.sateus,
  });

  final List<String> statusCar;
  final Function(String value) sateus;
  @override
  State<StatusCarSelectedWidget> createState() =>
      _StatusCarSelectedWidgetState();
}

class _StatusCarSelectedWidgetState extends State<StatusCarSelectedWidget> {
  String? isSelected;
  @override
  void initState() {
    super.initState();
    isSelected = widget.statusCar.first; // أول عنصر من القائمة
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      width: 358.w,
      height: 75.h,
      decoration: BoxDecoration(
        color: AppColors.borderColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          ...List.generate(widget.statusCar.length, (i) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  // print('object');
                  setState(() {
                    isSelected = widget.statusCar[i];
                    widget.sateus(isSelected!);
                  });
                },
                child: Container(child: Text(widget.statusCar[i],style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: isSelected == widget.statusCar[i]?Color(0xffffffff):AppColors.silverDark),),
                  alignment: Alignment.center,
                  height: 75.h,
                  decoration: BoxDecoration(
                    color: isSelected == widget.statusCar[i]
                        ? AppColors.primary
                        : AppColors.borderColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
