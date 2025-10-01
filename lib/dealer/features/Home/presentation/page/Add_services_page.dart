import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Services_information_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/availibility_section_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/image_and_media_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/location_and_availability.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class AddServicesPage extends StatefulWidget {
  AddServicesPage({super.key});

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  TextEditingController nameServices = TextEditingController();

  TextEditingController description = TextEditingController();

  TextEditingController minPriceRange = TextEditingController();

  TextEditingController maxPriceRange = TextEditingController();

  bool isAvailable = true;
  bool isServiceStatus = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              ServicesInformationWidget(
                nameServices: nameServices,
                description: description,
                minPriceRange: minPriceRange,
                maxPriceRange: maxPriceRange,
              ),
              SizedBox(height: 16.h),
              locationAndAvailability(
                isAvailable: isAvailable,
                isServiceStatus: isServiceStatus,
              ),
              SizedBox(height: 16.h),
              imageAndMediaWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
