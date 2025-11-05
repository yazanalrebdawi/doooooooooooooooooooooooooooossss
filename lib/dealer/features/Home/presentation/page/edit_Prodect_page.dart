// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dooss_business_app/dealer/Core/services/notification_service.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../../../Core/style/app_text_style.dart';
import '../../../reels/presentation/widget/Custom_app_bar.dart';
import '../../data/models/product_data_model.dart';
import '../../data/remouteData/home_page_state.dart';
import '../manager/home_page_cubit.dart';
import '../widget/Category_Section_widget.dart';
import '../widget/Custom_Button_With_icon.dart';
import '../widget/Upload_Product_images_widdget.dart';
import '../widget/form_ProductAndDescriptionWidget.dart';
import '../widget/priceAndQuantityWidget.dart';
import 'edit_Prodect_page.dart';

class EditProdectPage extends StatefulWidget {
  EditProdectPage({
    super.key,
    required this.item,
    required this.productName,
    required this.price,
    required this.discount,
    required this.isAvailable,
  });
  final productdata item;
  final TextEditingController productName;
  TextEditingController description = TextEditingController();
  final TextEditingController price;
  final TextEditingController discount;
  final Function(bool value) isAvailable;

  @override
  State<EditProdectPage> createState() => _EditProdectPageState();
}

class _EditProdectPageState extends State<EditProdectPage> {
  @override
  void initState() {
    // widget.productName.text = widget.item.name;
    // widget. =widget.item.

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool? isAvailableCurrent = widget.item.isAvailable;
    String Category = 'rims';
    XFile? imageData;
    // TextEditingController price = TextEditingController();
    return Scaffold(
      // bottomNavigationBar: BottonNavigationOfEditStore(),
      backgroundColor: Color(0xffffffff),
      // appBar: AppBar(backgroundColor: Color(0xffffffff)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: BlocListener<HomePageCubit, HomepageState>(
            listener: (context, state) {
              if (state.isSuccessEditProduct) {
                // Show foreground notification with translations
                LocalNotificationService.instance.showNotification(
                  id: 10,
                  title: AppLocalizations.of(context)
                          ?.translate('notificationProductEditedTitle') ??
                      'Product Updated',
                  body: AppLocalizations.of(context)
                          ?.translate('notificationProductEditedBody') ??
                      'Product has been updated successfully.',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomSnakeBar(
                      text: 'Product updated successfully',
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
                Navigator.pop(context);
                BlocProvider.of<HomePageCubit>(context).getdataproduct();
              }
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomSnakeBar(
                      isFailure: true,
                      text: state.error!,
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
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              BlocProvider.of<HomePageCubit>(
                                context,
                              ).getdataproduct();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Color(0xff4B5563),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Icon(Icons.oil_barrel, color: AppColors.primary),
                          SvgPicture.asset(
                            'assets/icons/product.svg',
                            width: 18.w,
                          ),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            '  ${widget.item.name}',
                            style: AppTextStyle.poppins616blueDark,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text('Edit Product', style: AppTextStyle.poppins720black),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.borderColor),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 358.w,
                        // height: 825.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/coin.svg',
                                    color: AppColors.silverDark,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'product Name',
                                    style: AppTextStyle.poppins514BlueDark,
                                  ),

                                  // Text(
                                  //   '*',
                                  //   style: TextStyle(color: Colors.redAccent,),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 17.h),
                              SizedBox(
                                width: 324.w,
                                // height: 50.h,
                                child: TextFormField(
                                  controller: widget.productName,
                                  decoration: InputDecoration(
                                      // hintText: 'e.g., Brake Pads - Toyota',
                                      ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.format_align_left,
                                    color: AppColors.silverDark,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Description',
                                    style: AppTextStyle.poppins514BlueDark,
                                  ),
                                  // Text(
                                  //   '*',
                                  //   style: TextStyle(color: Colors.redAccent,),
                                  // ),
                                  // SizedBox(width: 4.w,),
                                  // Icon(Icons.info,color: Color(0xff9CA3AF),size: 14,)
                                ],
                              ),
                              SizedBox(height: 17.h),
                              SizedBox(
                                width: 324.w,
                                // height: 50.h,
                                child: TextFormField(
                                  maxLines: 4,
                                  controller: widget.description,
                                  decoration: InputDecoration(
                                    hintText:
                                        'High-quality synthetic engine oil\nsuitable for all car models.\nProvides excellent protection and\nperformance.',
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.business_outlined,
                              //       color: AppColors.silverDark,
                              //     ),
                              //     SizedBox(width: 8.w),
                              //     Text(
                              //       'Brand',
                              //       style: AppTextStyle.poppins514BlueDark,
                              //     ),
                              //     // Text('*', style: TextStyle(color: Colors.redAccent)),
                              //   ],
                              // ),
                              // SizedBox(height: 17.h),
                              // SizedBox(
                              //   width: 324.w,
                              //   // height: 55.h,
                              //   child: DropdownButtonFormField(
                              //     icon: Icon(
                              //       Icons.keyboard_arrow_down,
                              //       color: Colors.black,
                              //     ),
                              //     hint: Text(
                              //       ' Toyota',
                              //       style: AppTextStyle.poppinsw416black,
                              //       textAlign: TextAlign.center,
                              //     ),
                              //     items: [],
                              //     onChanged: (value) {},
                              //   ),
                              // ),
                              // SizedBox(height: 24.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/coin.svg',
                                              color: AppColors.silverDark,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'price',
                                              style: AppTextStyle
                                                  .poppins514BlueDark,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 17.h),
                                        SizedBox(
                                          width: 137.w,
                                          // height: 55.h,
                                          child: TextFormField(
                                            keyboardType: TextInputType
                                                .numberWithOptions(),
                                            controller: widget.price,
                                            decoration: InputDecoration(
                                              hintText: widget.price.text,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.account_balance_rounded,
                                              color: AppColors.silverDark,
                                            ),
                                            // SvgPicture.asset('assets/icons/coin.svg',color: AppColors.silverDark,),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'Discount',
                                              style: AppTextStyle
                                                  .poppins514BlueDark,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 17.h),
                                        SizedBox(
                                          width: 137.w,
                                          // height: 55.h,
                                          child: TextFormField(
                                            keyboardType: TextInputType
                                                .numberWithOptions(),
                                            controller: widget.discount,
                                            decoration: InputDecoration(
                                              hintText: widget.discount.text,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.toggle_on,
                              //       color: AppColors.silverDark,
                              //       size: 22,
                              //     ),
                              //     SizedBox(width: 8.w),
                              // //     Text(
                              //       'Availability',
                              //       style: AppTextStyle.poppins514BlueDark,
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 10.h),
                              // Row(
                              //   children: [
                              //     SizedBox(
                              //       height: 15.h,
                              //       width: 40.w,
                              //       child: Transform.scale(
                              //         scale: 0.8,
                              //         child: Switch(
                              //           value: isAvailableCurrent,
                              //           onChanged: (value) {
                              //             setState(() {
                              //               isAvailableCurrent = value;
                              //               print(isAvailableCurrent);
                              //             });
                              //           },
                              //           activeTrackColor: AppColors.primary,
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(width: 12.w),
                              //     Text(
                              //       'Available',
                              //       style: AppTextStyle.poppins516primaryColor,
                              //     ),
                              //   ],
                              // ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.format_list_bulleted_sharp,
                                    color: AppColors.silverDark,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Category',
                                    style: AppTextStyle.poppins514BlueDark,
                                  ),
                                  // Text('*', style: TextStyle(color: Colors.redAccent)),
                                ],
                              ),
                              SizedBox(height: 17.h),
                              SizedBox(
                                width: 324.w,
                                // height: 55.h,
                                child: DropdownButtonFormField(
                                  // value: 'rims',
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  hint: Text(
                                    widget.item.category,
                                    style: AppTextStyle.poppinsw416black,
                                    textAlign: TextAlign.center,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('lighting'),
                                      value: 'lighting',
                                    ),
                                    DropdownMenuItem(
                                      child: Text('screens'),
                                      value: 'screens',
                                    ),
                                    DropdownMenuItem(
                                      child: Text('rims'),
                                      value: 'rims',
                                    ),
                                  ],
                                  onChanged: (value) {
                                    Category = value!;
                                  },
                                ),
                              ),
                              SizedBox(height: 24.h),
                              editProductImage(
                                imagedata: (value) {
                                  imageData = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      CustomButtonWithIcon(
                        type: 'save',
                        iconButton: Icons.save,
                        ontap: () {
                          // print(widget.productName);
                          // print(Category);
                          // print(widget.item.id);
                          // print(widget.productName.text);
                          // print(widget.price.text);
                          // print(widget.discount.text);
                          // print(widget.item.isAvailable);
                          // print(Category);
                          // if(imageData!=null){
                          BlocProvider.of<HomePageCubit>(context).EditProduct(
                            widget.item.id,
                            widget.productName.text,
                            widget.price.text,
                            widget.discount.text,
                            widget.item.isAvailable,
                            Category,
                            imageData,
                          );
                        },

                        // },
                      ),

                      // Icon(Icons.line)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class editProductImage extends StatefulWidget {
  editProductImage({super.key, required this.imagedata});
  final Function(XFile value) imagedata;
  @override
  State<editProductImage> createState() => _editProductImageState();
}

class _editProductImageState extends State<editProductImage> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<XFile?> imagelistner = ValueNotifier<XFile?>(null);
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.image, color: AppColors.silverDark),
            SizedBox(width: 8.w),
            Row(
              children: [
                Text('Product Images', style: AppTextStyle.poppins514BlueDark),
              ],
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          width: 308.w,
          height: 85.h,
          child: BlocListener<HomePageCubit, HomepageState>(
            listener: (context, state) {
              if (state.isLoadingeditProfile == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomSnakeBar(text: 'change data profile'),
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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      imagelistner.value = image;
                      widget.imagedata(image!);
                    },
                    child: ValueListenableBuilder(
                      valueListenable: imagelistner,
                      builder: (context, value, child) {
                        if (value == null) {
                          return Container(
                            width: 94.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.silverDark,
                              ),
                            ),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              margin: EdgeInsets.only(right: 12.w),
                              width: 94.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderColor,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.file(
                                  File(value.path), // ✅ تحويل XFile إلى File
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSnakeBar extends StatelessWidget {
  const CustomSnakeBar({super.key, required this.text, this.isFailure = false});
  final String text;
  final bool? isFailure;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      width: 358.w,
      // height: 58.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: isFailure == true ? AppColors.red : Color(0xff22C55E),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(33, 0, 0, 0),
            blurRadius: 15.r,
            offset: Offset(0, 15.w),
          ),
          BoxShadow(
            color: Color.fromARGB(8, 0, 0, 0),
            blurRadius: 4.r,
            offset: Offset(0, 6.w),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            isFailure == true
                ? Icon(Icons.error, color: Colors.white, size: 20.r)
                : Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
            SizedBox(width: 8.w),
            SizedBox(
              width: 250.w,
              child: Text(
                text,
                style: AppTextStyle.poppins416white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



//  ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(8.r),
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         right: 12.w,
//                       ),
//                       width: 94.w,
//                       height: 80.h,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color:
//                               AppColors.borderColor,
//                           width: 1.5,
//                         ),
//                         borderRadius:
//                             BorderRadius.circular(
//                               8.r,
//                             ),
//                       ),
//                       child: ClipRRect(
//                         borderRadius:
//                             BorderRadius.circular(
//                               8.r,
//                             ),
//                         child: Image.asset(
//                           fit: BoxFit.cover,
//                           'assets/images/OliFilter.png',
//                         ),
//                       ),
//                     ),
//                   );