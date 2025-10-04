import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Core/style/app_Colors.dart';
import '../../data/models/product_data_model.dart';
import '../../data/remouteData/home_page_state.dart';
import '../manager/home_page_cubit.dart';
import '../page/edit_Prodect_page.dart';

class ProductListwidget extends StatelessWidget {
  const ProductListwidget({super.key});

  @override
  Widget build(BuildContext context) {
    // var wid = 358.w;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: BlocBuilder<HomePageCubit, HomepageState>(
        builder: (context, state) {
          if (state.isLoadingeditProfile==true) {
            return SizedBox(
              height: 300.h,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          } else if (state.error != null) {
            return SizedBox(
              height: 300.h,
              child: Center(child: Text(state.error!)),
            );
          } else if (state.allProduct == null || state.allProduct.isEmpty) {
            return SizedBox(
              height: 300.h,
              child: Container(child: Text('No product available')),
            );
          }
          return ListView.builder(
            shrinkWrap: true, // ← يخليها تتمدد مع المحتوى
            physics: NeverScrollableScrollPhysics(),
            itemCount: state.allProduct.length,
            itemBuilder: (context, i) {
              return productInfoCard(item: state.allProduct[i]);
            },
          );
        },
      ),
    );
  }
}

class productInfoCard extends StatelessWidget {
  const productInfoCard({super.key, required this.item});
  final productdata item;
  @override
  Widget build(BuildContext context) {
    print(item.mainImage);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.only(top: 16, left: 16.w),
      width: 358.w,
      // height: 130.h,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.r,
            spreadRadius: 0,
            offset: Offset(0, 2),
            color: Color.fromARGB(7, 0, 0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageProduct(item: item.mainImage),
          SizedBox(width: 12.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 240.w),
                child: Tooltip(
                  message: item.name,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    item.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
              Text(
                item.finalPrice,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                width: 250.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            splashFactory: NoSplash.splashFactory,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Checkbox(
                            value: item.isAvailable,
                            // splashRadius: 0,
                            activeColor: Color(0xff349A51),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              BlocProvider.of<HomePageCubit>(
                                context,
                              ).toggleAvailableProduct(item.id);
                            },
                          ),
                        ),
                        Text(
                          item.isAvailable ? 'Available' : 'unAvailable',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff4B5563),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<HomePageCubit>(
                                    context,
                                  ),
                                  child: EditProdectPage(
                                    item: item,
                                    productName: TextEditingController(
                                      text: item.name,
                                    ),
                                    price: TextEditingController(
                                      text: item.price,
                                    ),
                                    discount: TextEditingController(
                                      text: item.discount,
                                    ),
                                    isAvailable: (v) {
                                      print(v);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            color: AppColors.primary,
                            width: 22,
                            height: 22,
                          ),
                        ),
                        // SizedBox(width: 12.w),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<HomePageCubit>(
                              context,
                            ).deleteProduct(item.id);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class imageProduct extends StatelessWidget {
//   const imageProduct({
//     super.key,
//     required this.item,
//   });

//   final String? item;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60,
//       height: 60,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.network(
//           'http://10.0.2.2:8010${item.mainImage ?? ''}',
//           width: 60.w,
//           height: 60.w,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
class ImageProduct extends StatelessWidget {
  const ImageProduct({
    super.key,
    required this.item,
  });

  final dynamic? item; // لو string url

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: item == null || item!.isEmpty
            ? Container(color: Colors.grey[300]) // بدون صورة
            : Image.network(
                '$item',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Container(color: AppColors.borderColor), // لو صار خطأ بالتحميل
              ),
      ),
    );
  }
}