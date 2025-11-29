import 'package:dio/dio.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import '../widget/Change_status_store.dart';
import '../widget/Custom_Button_With_icon.dart';
import '../widget/Location_selection_widget.dart';
import '../widget/Upload_Product_images_widdget.dart';
import '../widget/bottom_navigationBar_of_Edit_Store.dart';
import '../widget/contectI_info_widget.dart';
import '../widget/form_ProductAndDescriptionWidget.dart';
import '../widget/form_edit_profile_widget.dart';
import '../widget/priceAndQuantityWidget.dart';
import 'edit_Prodect_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
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
  late bool isStoreOpen;

  @override
  void initState() {
    super.initState();
    close = widget.closeTime;
    start = widget.openTime;
    latValue = widget.lat;
    lonValue = widget.log;
    // Initialize store status from current state
    // Use WidgetsBinding to ensure context is ready before accessing cubit state
    // Initialize with default value first, then update from state
    isStoreOpen = true; // Default value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final currentState = BlocProvider.of<HomePageCubit>(context).state;
          // Access dataStore (it's required in state, but check for safety)
          if (mounted) {
            setState(() {
              isStoreOpen = currentState.dataStore.isStoreOpen;
            });
          }
        } catch (e) {
          // Fallback to default if state access fails
          if (mounted) {
            setState(() {
              isStoreOpen = true;
            });
          }
        }
      }
    });
  }

  GlobalKey<FormState> form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    late bool isAvaiable = true;
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Color(0xffffffff),
        title: 'Edit Store profile',
        subtitle:
            'Keep your store details up to date for better\nvisibility and trust',
        ontap: () {
          BlocProvider.of<HomePageCubit>(context).getDataProfile();
        },
      ),
      backgroundColor: AppColors.background,
      // appBar: AppBar(),
      // bottomNavigationBar: BottonNavigationOfEditStore(isAvaialble: isAvaiable),
      body: BlocListener<HomePageCubit, HomepageState>(
        listener: (context, state) {
          if (state.isSuccess == true) {
            // Refresh the profile data to ensure UI is updated
            BlocProvider.of<HomePageCubit>(context).getDataProfile();
            Navigator.pop(context);
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomSnakeBar(
                  text: 'failure edit Store ',
                  isFailure: true,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                ),
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate responsive max width (max 600px on larger screens)
            final maxWidth =
                constraints.maxWidth > 600 ? 600.0 : constraints.maxWidth;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Form(
                      key: form,
                      child: Column(
                        children: [
                          formEditProfileWidget(
                            storeName: widget.storeName,
                            storeDescription: widget.storeDescription,
                          ),
                          // AddStoreLogoWidget(),
                          ContactInfoWidget(
                            phone: widget.phone,
                            email: widget.email,
                          ),
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
                          BlocBuilder<HomePageCubit, HomepageState>(
                              builder: (context, state) {
                            return changeStatusStoreWidget(
                              days: state.dataStore.workingDays,
                              initialOpeningTime: state.dataStore.openingTime,
                              initialClosingTime: state.dataStore.closingTime,
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
                            );
                          }),

                          BlocBuilder<HomePageCubit, HomepageState>(
                            builder: (context, state) {
                              return selectStoreStatus(
                                initialStatus: state.dataStore.isStoreOpen,
                                toggleStatus: (value) {
                                  setState(() {
                                    isStoreOpen = value;
                                  });
                                  print(
                                      'Store status changed to: ${value ? "Open" : "Closed"}');
                                },
                              );
                            },
                          ),
                          BottonNavigationOfEditStore(
                            reset: () {
                              widget.storeName.clear();
                              widget.storeDescription.clear();
                              widget.phone.clear();
                              widget.email.clear();
                              widget.location.clear();
                              // days = [];
                              print('reset');
                            },
                            onTap: () {
                              if (form.currentState!.validate()) {
                                BlocProvider.of<HomePageCubit>(context)
                                    .EditDataProfile(
                                  widget.storeName.text,
                                  widget.storeDescription.text,
                                  widget.phone.text,
                                  close.toString(),
                                  start.toString(),
                                  latValue,
                                  lonValue,
                                  days,
                                  isStoreOpen,
                                );
                              }
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
              ),
            );
          },
        ),
      ),
    );
  }
}
