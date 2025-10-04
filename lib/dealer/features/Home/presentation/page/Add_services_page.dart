import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../reels/presentation/widget/Custom_app_bar.dart';
import '../../data/remouteData/home_page_state.dart';
import '../manager/home_page_cubit.dart';
import '../widget/Category_Section_widget.dart';
import '../widget/Custom_Button_With_icon.dart';
import '../widget/Services_information_widget.dart';
import '../widget/Upload_Product_images_widdget.dart';
import '../widget/form_ProductAndDescriptionWidget.dart';
import '../widget/image_and_media_widget.dart';
import '../widget/location_and_availability.dart';
import '../widget/priceAndQuantityWidget.dart';
import 'edit_Prodect_page.dart';

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
