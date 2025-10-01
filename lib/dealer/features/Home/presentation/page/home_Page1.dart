import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/network/service_locator.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/home_page_state.dart';
import 'package:dooss_business_app/dealer/features/Home/data/remouteData/remoute_dealer_data_source.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/manager/home_page_cubit.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_Product.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/edit_Prodect_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Botton_navigation_Edit_store.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/Custom_Button_With_icon.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/status_section.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/store_info_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(getIt<RemouteDealerDataSource>())
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
                          IconButton(
                            onPressed: () {
                              // RemouteDealerDataSource().getDataDashboard();
                            },
                            icon: Icon(Icons.notification_add, size: 20),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              RemouteDealerDataSource().getDataStoreProfile();
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
                    child: Row(
                      children: [
                        // Icon(Icons.directions_car, color: AppColors.primary, size: 24),
                        SvgPicture.asset('assets/icons/car.svg'),
                        SizedBox(width: 8.h),
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
                    buildWhen: (previous, current) =>
                        previous.allProduct != current.allProduct ||
                        previous.dataDash != current.dataDash,
                    builder: (context, state) {
                      return StoreInfoCardWidget(
                        infoStore: [
                          StoreInfoState(
                            icon: Icons.abc,
                            labal: 'Total Items',
                            value: state.dataDash.cars!.active,
                          ),
                          StoreInfoState(
                            icon: Icons.visibility_sharp,
                            labal: 'Store Views',
                            value: state.dataDash.reels!.views,
                          ),
                          StoreInfoState(
                            icon: Icons.abc,
                            labal: 'massages',
                            value: state.dataDash.messages!.messagesNew,
                          ),
                          StoreInfoState(
                            icon: Icons.attach_money,
                            labal: 'Total Sales',
                            value: state.dataDash.cars!.sold,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  StatusSection(),
                  CustomButtonWithIcon(
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
