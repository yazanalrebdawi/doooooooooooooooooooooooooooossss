import 'dart:io';

import 'package:dooss_business_app/dealer/features/Home/presentation/page/edit_Prodect_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Appearance_and_colors_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/basic_information_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/spacification_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../data/remouteData/home_page_state.dart';
import '../manager/home_page_cubit.dart';
import '../widget/Custom_Button_With_icon.dart';
import '../widget/image_and_media_widget.dart';

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
  int seats = 2;
  String status = 'new';
  int? year = 2024;
  ValueNotifier<XFile?> image = ValueNotifier(null);
  double lat = 33.5138;
  double lon = 36.2765;
}

class _AddNewCarPageState extends State<AddNewCarPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
    final form = GlobalKey<FormState>();
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
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Color(0xff4B5563)),
            ),
            centerTitle: true,
            title: Text('Add New car', style: AppTextStyle.poppins720black),
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: BlocListener<HomePageCubit, HomepageState>(
        listener: (context, state) {
          if (state.isSuccessAddCar == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnakeBar(text: 'Add Car is Success'),
                backgroundColor: Colors.transparent, // ⬅️ جعل الخلفية شفافة
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  top: 20, // مسافة من الأعلى
                  left: 10,
                  right: 10,
                ),
              ),
            );
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnakeBar(text: state.error!, isFailure: true),
                backgroundColor: Colors.transparent, // ⬅️ جعل الخلفية شفافة
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  top: 20, // مسافة من الأعلى
                  left: 10,
                  right: 10,
                ),
              ),
            );
          }
        },

        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(17.r),
            child: Form(key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BasicInformtionWidget(
                    getDataBrand: (value) {
                      widget.brand = value!;
                      print(value);
                    },
                    status: (value) {
                      widget.status = value;
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
                  AppearanceAndColorsWidget(
                    color: widget.color,
                    lat: (value) {
                      widget.lat = value;
                    },
                    lon: (value) {
                      widget.lon = value;
                    },
                  ),
                  // SizedBox(height: 24.h),
                      
                  // featuresAndOptionsWidget(),
                  imageAndMediaOfAddCar(widget: widget),
                  SizedBox(height: 20.h),
                      
                  CustomButtonWithIcon(
                    type: 'add car',
                    iconButton: Icons.add,
                    ontap: () {
                      // print(widget.brand);
                      // // RemouteDealerDataSource().AddCars();
                      // print(widget.model.text);
                      // print(widget.price.text);
                      // print(widget.Doors);
                      // print(widget.drivetrain);
                      // print(widget.typeFuel);
                      // print(widget.transmission);
                      // print(widget.image.value!.path);
                      print(widget.color.text);
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
                      
                        if (formKey.currentState!.validate()){
                               if(widget.image.value!=null){
                     BlocProvider.of<HomePageCubit>(context).AddNewCar(
                          widget.brand,
                          widget.year!,
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
                          widget.status,
                          widget.lat,
                          widget.lon,
                          widget.color.text
                        );
                               }
                               else if(widget.image.value==null) {
                    return   ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomSnakeBar(
                      isFailure: true,
                      text: 'add image please',
                    ),
                    backgroundColor: Colors.transparent, // ⬅️ جعل الخلفية شفافة
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      top: 20, // مسافة من الأعلى
                      left: 10,
                      right: 10,
                    ),
                  ),
                );
                      
                }     
                      }   
                     
                    },
                  ),
                ],
              ),
            ),
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
