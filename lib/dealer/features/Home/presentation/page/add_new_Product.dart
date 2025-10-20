import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_snack_bar.dart';
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
import '../widget/Upload_Product_images_widdget.dart';
import '../widget/form_ProductAndDescriptionWidget.dart';
import '../widget/priceAndQuantityWidget.dart';
import 'edit_Prodect_page.dart';

class AddNewProductPage extends StatelessWidget {
  const AddNewProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController product = TextEditingController();
    TextEditingController Description = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController quintity = TextEditingController();
    String category = 'rims';
    XFile? image = null;
    final _form = GlobalKey<FormState>();
    return Form(
      key: _form,
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: Color(0xffffffff),

          title: 'Add New Product',
          subtitle: 'Fill the details below to add a new item to\nyour store',
          ontap: () {},
        ),
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  formProductAndDescrictionWidget(
                    product: product,
                    Description: Description,
                  ),
                  // BrandWidget(),
                  CategoryWidget(
                    categoryselected: (value) {
                      category = value;
                      print(value);
                    },
                  ),
                  SizedBox(height: 16.h),
                  priceAndQuantityWidget(price: price, quantity: quintity),
                  SizedBox(height: 16.h),
                  // availabilitySectionWidget(),
                  // SizedBox(height: 16.h),
                  uploadProductImagesWidget(
                    Setimage: (value) {
                      image = value;
                    },
                  ),
                  Divider(color: AppColors.borderColor, height: 1),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 24.h, bottom: 16.h),
                          alignment: Alignment.center,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: AppColors.BlueDark),
                              Text(
                                'Cancel',
                                style: AppTextStyle.poppins514BlueDark,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),

                      Expanded(
                        child: BlocConsumer<HomePageCubit, HomepageState>(
                          listener: (context, state) {
                            if (state.isLoadingFecthProductData == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomSnakeBar(
                                    text: 'added product',
                                  ),
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
                              BlocProvider.of<HomePageCubit>(
                                context,
                              ).getDataProfile();// ediiiit
                              Navigator.pop(context);
                            } else if (state.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomSnakeBar(
                                    text: state.error!,
                                    isFailure: true,
                                  ),
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
                            }
                          },
                          builder: (context, state) {
                            return CustomButtonWithIcon(
                              type: 'add product',
                              iconButton: Icons.add,
                              ontap: () {
                                if (_form.currentState!.validate()) {
                                  if(image!=null){
                                     print(image!.path);
                                  BlocProvider.of<HomePageCubit>(
                                    context,
                                  ).addProduct(
                                    product.text,
                                    Description.text,
                                    price.text,
                                    category,
                                    quintity.text,
                                    image,
                                  );
                                  }else{
                                     ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CustomSnakeBar(
                      isFailure: true,
                      text: 'please ,add image product',
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
                            );
                          },
                        ),
                      ),
                    ],
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
