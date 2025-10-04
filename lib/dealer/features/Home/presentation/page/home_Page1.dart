import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/network/service_locator.dart';
import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../reels/presentation/widget/Custom_app_bar.dart';
import '../../data/remouteData/home_page_state.dart';
import '../../data/remouteData/remoute_dealer_data_source.dart';
import '../manager/home_page_cubit.dart';
import '../widget/Botton_navigation_Edit_store.dart';
import '../widget/Category_Section_widget.dart';
import '../widget/Custom_Button_With_icon.dart';
import '../widget/Upload_Product_images_widdget.dart';
import '../widget/form_ProductAndDescriptionWidget.dart';
import '../widget/priceAndQuantityWidget.dart';
import '../widget/status_section.dart';
import '../widget/store_info_card_widget.dart';
import 'add_new_Product.dart';
import 'add_new_car_page.dart';
import 'edit_Prodect_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(appLocator<RemouteDealerDataSource>())
        ..getdataproduct()
        ..gatDataDashboard()
        ..getDataProfile(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
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
                
                  shadowColor: Color.fromARGB(38, 0, 0, 0),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // IconButton(
                          //   onPressed: () {
                          //     BlocProvider.of<AuthCubit>(context).SignIn();
                          //   },
                          //   icon: Icon(Icons.notifications, size: 20),
                          // ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              // RemouteDealerDataSource().getDataStoreProfile();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomSnakeBar(text: 'ghassan'),
                                  backgroundColor: Colors
                                      .transparent, // ⬅️ جعل الخلفية شفافة
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    top: 20, // مسافة من الأعلى
                                    left: 10,
                                    right: 10,
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  title: GestureDetector(
                    onTap: () {
                  
                    },
                    child: Row(
                      children: [
                        // Icon(Icons.directions_car, color: AppColors.primary, size: 24),
                        SvgPicture.asset('assets/icons/car.svg'),
                        SizedBox(width: 12.h),
                        Text(
                          'Dooss',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<HomePageCubit, HomepageState>(
                    builder: (context, state) {
                      return StoreInfoCardWidget(
                        infoStore: [
                          StoreInfoState(
                            icon: 'assets/icons/cart.svg',
                            labal: 'Total Items',
                            value: state.dataDash.cars!.active,
                          ),
                          StoreInfoState(
                            icon: 'assets/icons/eye.svg',
                            labal: 'Store Views',
                            value: state.dataDash.reels!.views,
                          ),
                          StoreInfoState(
                            icon: 'assets/icons/massage.svg',
                            labal: 'massages',
                            value: state.dataDash.messages!.messagesNew,
                          ),
                          StoreInfoState(
                            icon: 'assets/icons/coin.svg',
                            labal: 'Total Sales',
                            value: state.dataDash.cars!.sold,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  StatusSection(),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomButtonWithIcon(
                            type: 'Add New Product',
                            iconButton: Icons.add,
                            ontap: () {
                              // RemouteDealerDataSource().AddCars();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<HomePageCubit>(context),
                                    child: AddNewProductPage(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 12.w,),
                        GestureDetector(onTap: () {
                              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<HomePageCubit>(context),
                              child: AddNewCarPage(),
                            ),
                          ),
                        );
                        },
                          child: Container(width: 60.h,
                              margin: EdgeInsets.only(top: 16.h, bottom: 16.h),
                          height: 60.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: SvgPicture.asset('assets/icons/car.svg',)),
                        )
                      ],
                    ),
                  ),
                  ProductListwidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////
// SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   StoreInfoCardWidget(),
//                   SizedBox(height: 24.h),
//                   StatusSection(),
//                   CustomButtonWithIcon(
//                     type: 'Add New Product/Service',
//                     iconButton: Icons.add,
//                     ontap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddNewProductPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 500.h, child: ProductListwidget()),
//                 ],
//               ),
//             ),

abstract class Validator {
  /// Validate international phone number (e.g., +1234567890)
  static String? phoneValidation(String? phone) {
    final phoneRegex = RegExp(r'^\+[0-9]{9,15}$');
    if (phone == null || !phoneRegex.hasMatch(phone)) {
      return 'Phone is not valid';
    }
    return null;
  }

  /// Validate email format
  static String? emailValidation(String? email) {
    email = email?.trim();
    bool valid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email ?? '');

    if (!valid) {
      return "Email is not valid";
    }
    return null;
  }

  /// Validate not null or empty field
  static String? notNullValidation(String? str) =>
      (str == null || str.isEmpty) ? 'This field is required' : null;

  /// Validate and return empty string if null
  static String? notNullValidationValue(String? str) =>
      (str == null || str.isEmpty) ? '' : null;

  /// Validate phone number length
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Not correct';
    }
    return null;
  }

  /// Validate password with context for localization
  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Please enter Password';
    } else if (value.length < 8 || value.length > 32) {
      return 'Password must be 8-32 characters';
    }
    return null;
  }

  /// Validate date of birth in YYYY-MM-DD format
  static String? validateDateOfBirth(String? value) {
    final regex = RegExp(
      r"^(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$",
    );
    if (value == null || !regex.hasMatch(value)) {
      return 'Date of birth is not valid, please enter YYYY-MM-DD';
    }
    return null;
  }

  /// Validate name (at least 3 characters)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty!';
    } else if (value.length < 3) {
      return 'Name must be at least 3 characters!';
    }
    return null;
  }
}
