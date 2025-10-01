import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/manager/home_page_cubit.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Add_brand_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Category_Section_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Custom_Button_With_icon.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Upload_Product_images_widdget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/availibility_section_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/form_ProductAndDescriptionWidget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/priceAndQuantityWidget.dart';
import 'package:dooss_business_app/dealer/features/reels/presentation/widget/Custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddNewProductPage extends StatelessWidget {
  const AddNewProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController product = TextEditingController();
    TextEditingController Description = TextEditingController();
    TextEditingController price = TextEditingController();
    TextEditingController quintity = TextEditingController();
    String category = 'rims';
    XFile? image = XFile('');
    return Scaffold(
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
                BrandWidget(),
                CategoryWidget(
                  categoryselected: (value) {
                    category = value;
                    print(value);
                  },
                ),
                SizedBox(height: 16.h),
                priceAndQuantityWidget(price: price, quantity: quintity),
                SizedBox(height: 16.h),
                availabilitySectionWidget(),
                SizedBox(height: 16.h),
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
                      child: CustomButtonWithIcon(
                        type: 'add product',
                        iconButton: Icons.add,
                        ontap: () {
                          print(image!.path);
                          BlocProvider.of<HomePageCubit>(context).addProduct(
                            product.text,
                            Description.text,
                            price.text,
                            category,
                            quintity.text,
                            image,
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
    );
  }
}
