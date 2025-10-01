import 'package:dooss_business_app/user/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import '../manager/cubits/cars_cubit.dart';
import '../widgets/cars_banner.dart';
import '../widgets/cars_category_tabs.dart';
import '../widgets/cars_brand_list.dart';
import '../widgets/cars_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarsCubit(),
      child: BlocBuilder<AppManagerCubit, AppManagerState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.add_outlined),
                  onPressed: () {
                    context.go(RouteNames.addCarFlow);
                  },
                ),
              ],
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CarsBanner(),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)?.translate('Category') ??
                          'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const CarsCategoryTabs(),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)?.translate('TopBrands') ??
                          'Top Brands',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const CarsBrandList(),
                    SizedBox(height: 16.h),
                    const CarsGrid(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
