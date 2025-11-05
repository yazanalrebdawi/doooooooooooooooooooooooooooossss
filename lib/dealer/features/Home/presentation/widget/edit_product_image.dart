
import 'dart:io';

import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/home_page_state.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/manager/home_page_cubit.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/edit_Prodect_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

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