import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/manager/home_page_cubit.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Appearance_and_colors_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Custom_Button_With_icon.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/basic_information_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_checkBox_with_Title.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/feature_and_option_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/image_and_media_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/spacification_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCarPage extends StatefulWidget {
  AddNewCarPage({super.key});

  @override
  State<AddNewCarPage> createState() => _AddNewCarPageState();
  final TextEditingController model = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController engineSize = TextEditingController();
  TextEditingController mileage = TextEditingController();
  TextEditingController color = TextEditingController();
  String brand = 'Audi';
  String typeFuel = 'Petrol';
  String transmission = 'Automatic';
  String drivetrain = 'FWD';
  int Doors = 4;
  int seats = 5;
  int? year = 2024;
  ValueNotifier<XFile?> image = ValueNotifier(null);
}

class _AddNewCarPageState extends State<AddNewCarPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(19, 0, 0, 0),
                offset: Offset(0, 1),
                spreadRadius: 0,
                blurRadius: 2,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Color(0xffffffff),
            leading: Icon(Icons.arrow_back, color: Color(0xff4B5563)),
            centerTitle: true,
            title: Text('Add New car', style: AppTextStyle.poppins720black),
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(17.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BasicInformtionWidget(
                getDataBrand: (value) {
                  widget.brand = value!;
                  print(value);
                },
                status: (value) {
                  print(value);
                },
                model: widget.model,
                price: widget.price,
                mileage: widget.mileage,
                engineSize: widget.engineSize,
                year: (value) {
                  widget.year = value;
                  print(value);
                },
              ),
              SizedBox(height: 24.h),
              SpecificationsWidget(
                Transmission: (value) {
                  widget.transmission = value;
                },
                Drivetrain: (value) {
                  widget.drivetrain = value;
                },
                Door: (value) {
                  widget.Doors = value;
                },
                seats: (value) {
                  widget.seats = value;
                },
                fuelType: (value) {
                  widget.typeFuel = value;
                  print(value);
                },
              ),
              SizedBox(height: 24.h),
              AppearanceAndColorsWidget(color: widget.color),
              SizedBox(height: 24.h),

              featuresAndOptionsWidget(),
              imageAndMediaOfAddCar(widget: widget),

              CustomButtonWithIcon(
                type: 'add car',
                iconButton: Icons.add,
                ontap: () {
                  print(widget.brand);
                  // RemouteDealerDataSource().AddCars();
                  print(widget.model.text);
                  print(widget.price.text);
                  print(widget.Doors);
                  print(widget.drivetrain);
                  print(widget.typeFuel);
                  print(widget.transmission);
                  print(widget.image.value!.path);
                  // RemouteDealerDataSource().AddCars(
                  //   widget.brand,
                  //   (widget.year).toString(),
                  //   widget.model.text,
                  //   widget.price.text,
                  //   widget.mileage.text,
                  //   widget.engineSize.text,
                  //   widget.typeFuel,
                  //   widget.transmission,
                  //   widget.drivetrain,
                  //   widget.Doors,
                  //   widget.seats,
                  //   widget.image.value!,
                  // );
                  BlocProvider.of<HomePageCubit>(context).AddNewCar(
                    widget.brand,
                    (widget.year).toString(),
                    widget.model.text,
                    widget.price.text,
                    widget.mileage.text,
                    widget.engineSize.text,
                    widget.typeFuel,
                    widget.transmission,
                    widget.drivetrain,
                    widget.Doors,
                    widget.seats,
                    widget.image.value!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class imageAndMediaOfAddCar extends StatelessWidget {
  const imageAndMediaOfAddCar({super.key, required this.widget});

  final AddNewCarPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(24, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text('images & media', style: AppTextStyle.Poppins718),
              ],
            ),
          ),
          Divider(color: AppColors.borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<XFile?>(
                  builder: (BuildContext context, value, child) {
                    if (widget.image.value == null) {
                      return UoloadServicesImageWidget(image: widget.image);
                    } else
                      return Container(
                        height: 170.h,
                        alignment: Alignment.center,

                        width: 326.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(widget.image.value!.path),
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            height: 170.h,
                          ),
                        ),
                      );
                  },
                  valueListenable: widget.image,
                ),

                // SizedBox(height: 16.h),
                // Text(
                //   'intro video (Optional)',
                //   style: AppTextStyle.poppins514BlueDark,
                // ),
                // SizedBox(height: 8.h),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.symmetric(vertical: 26.h),
                //   width: 326.w,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: AppColors.borderColor),
                //     borderRadius: BorderRadius.circular(8.r),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Icon(
                //         Icons.videocam,
                //         color: AppColors.silverDark,
                //         size: 38,
                //       ),
                //       Text(
                //         'MP4 • Max 30MB • 30 seconds max',
                //         style: TextStyle(
                //           fontWeight: FontWeight.w400,
                //           fontSize: 12,
                //           color: AppColors.silverDark,
                //           fontFamily: 'poppins',
                //         ),
                //       ),
                //       SizedBox(height: 8.h),
                //       Text(
                //         'Add Video',
                //         style: AppTextStyle.poppins514primaryColor,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YearDropdown extends StatefulWidget {
  const YearDropdown({Key? key, required this.CurrentYear}) : super(key: key);
  final Function(int value) CurrentYear;
  @override
  _YearDropdownState createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  final List<int> years = List<int>.generate(
    30, // عدد السنوات (مثال: آخر 30 سنة)
    (index) => DateTime.now().year - index,
  );

  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'select year',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selectedYear,
      items: years.map((year) {
        return DropdownMenuItem<int>(value: year, child: Text(year.toString()));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value;
          widget.CurrentYear(value!);
        });
      },
      validator: (value) => value == null ? 'enter year ,please' : null,
    );
  }
}
