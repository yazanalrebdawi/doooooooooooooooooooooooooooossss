import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/core/localization/language_cubit.dart';
import 'package:go_router/go_router.dart';
import '../manager/cubits/cars_cubit.dart';
import '../widgets/cars_banner.dart';
import '../widgets/cars_category_tabs.dart';
import '../widgets/cars_brand_list.dart';
import '../widgets/cars_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarsCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return Scaffold(
            appBar: AppBar(
        
              centerTitle: true,
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(icon: const Icon(Icons.add_outlined), onPressed: () {context.go(RouteNames.addCarFlow);}),
              ],
              leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
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
                      AppLocalizations.of(context)?.translate('Category') ?? 'Category',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18).withThemeColor(context),
                    ),
                    SizedBox(height: 8.h),
                    const CarsCategoryTabs(),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)?.translate('TopBrands') ?? 'Top Brands',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18).withThemeColor(context),
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