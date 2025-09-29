import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../manager/service_cubit.dart';
import '../manager/service_state.dart';
import '../widgets/nearby_services_map_widget.dart';
import '../widgets/nearby_service_card_widget.dart';
import '../widgets/nearby_services_filter_widget.dart';
import '../../../../core/localization/app_localizations.dart';

class NearbyServicesScreen extends StatefulWidget {
  const NearbyServicesScreen({super.key});

  @override
  State<NearbyServicesScreen> createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  @override
  void initState() {
    super.initState();
    // Load services when screen initializes with pagination (10 items)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCubit>().loadServices(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<ServiceCubit, ServiceState>(
=======
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<ServiceCubit, ServiceState>(
        buildWhen: (previous, current) {
          return previous.services != current.services ||
              previous.isLoading != current.isLoading ||
              previous.error != current.error ||
              previous.selectedFilter != current.selectedFilter;
        },

>>>>>>> zoz
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            // Check if error is related to location permission
            if (state.error!.contains('location') ||
                state.error!.contains('permission')) {
<<<<<<< HEAD
              return Center(
                child: _buildLocationPermissionWidget(context),
              );
=======
              return Center(child: _buildLocationPermissionWidget(context));
>>>>>>> zoz
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
                  Icon(
                    Icons.error_outline,
                    color: isDark ? AppColors.gray : Colors.black,
                    size: 48.sp,
                  ),
=======
                  Icon(Icons.error_outline, color: AppColors.gray, size: 48.sp),
>>>>>>> zoz
                  SizedBox(height: 16.h),
                  Text(
                    'Error: ${state.error}',
                    style: AppTextStyles.secondaryS14W400,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServiceCubit>().loadServices(limit: 10);
                    },
<<<<<<< HEAD
                    child:
                        Text(AppLocalizations.of(context)!.translate('retry')),
=======
                    child: Text(
                      AppLocalizations.of(context)!.translate('retry'),
                    ),
>>>>>>> zoz
                  ),
                ],
              ),
            );
          }

          if (state.services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
                  Icon(
                    Icons.location_off,
                    color: isDark ? AppColors.gray : Colors.black,
                    size: 64.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.translate('noNearbyServices'),
                    style: AppTextStyles.blackS16W600.withThemeColor(context),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(context)!
                        .translate('noNearbyServicesMessage'),
                    style:
                        AppTextStyles.secondaryS14W400.withThemeColor(context),
=======
                  Icon(Icons.location_off, color: AppColors.gray, size: 64.sp),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.translate('noNearbyServices'),
                    style: AppTextStyles.blackS16W600,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.translate('noNearbyServicesMessage'),
                    style: AppTextStyles.secondaryS14W400,
>>>>>>> zoz
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServiceCubit>().loadServices();
                    },
<<<<<<< HEAD
                    child:
                        Text(AppLocalizations.of(context)!.translate('retry')),
=======
                    child: Text(
                      AppLocalizations.of(context)!.translate('retry'),
                    ),
>>>>>>> zoz
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Map View - خريطة حقيقية
              if (state.services.isNotEmpty)
                NearbyServicesMapWidget(services: state.services),

              // Filters
              NearbyServicesFilterWidget(
                selectedFilter: state.selectedFilter,
                onFilterChanged: (filter) {
                  context.read<ServiceCubit>().filterServices(filter);
                },
              ),

              // Services List
              Expanded(
                child: ListView.builder(
<<<<<<< HEAD
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
=======
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
>>>>>>> zoz
                  itemCount: state.services.length,
                  itemBuilder: (context, index) {
                    final service = state.services[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: NearbyServiceCardWidget(
                        service: service,
                        onShowOnMap: () {
                          context.push('/service-map', extra: service);
                        },
                        onMoreDetails: () {
                          context.push('/service-details', extra: service);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

<<<<<<< HEAD
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? Colors.white : Colors.black,
          size: 24.sp,
        ),
=======
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
>>>>>>> zoz
        onPressed: () => context.pop(),
      ),
      title: Text(
        AppLocalizations.of(context)!.translate('nearbyServices'),
<<<<<<< HEAD
        style: AppTextStyles.blackS18W700.withThemeColor(context),
=======
        style: AppTextStyles.blackS18W700,
>>>>>>> zoz
      ),
      centerTitle: true,
      actions: [
        // Location Icon
        IconButton(
<<<<<<< HEAD
          icon: Icon(
            Icons.my_location,
            color: AppColors.primary,
            size: 24.sp,
          ),
=======
          icon: Icon(Icons.my_location, color: AppColors.primary, size: 24.sp),
>>>>>>> zoz
          onPressed: () {
            // Refresh location and services
            context.read<ServiceCubit>().loadServices();
          },
        ),
        // Filter Icon
        IconButton(
<<<<<<< HEAD
          icon: Icon(
            Icons.filter_list,
            color: isDark ? Colors.white : AppColors.black,
            size: 24.sp,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Filter options')),
            );
=======
          icon: Icon(Icons.filter_list, color: AppColors.black, size: 24.sp),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Filter options')));
>>>>>>> zoz
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildLocationPermissionWidget(BuildContext context) {
<<<<<<< HEAD
    final isDark = Theme.of(context).brightness == Brightness.dark;

=======
>>>>>>> zoz
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
<<<<<<< HEAD
          Icon(
            Icons.location_off,
            color: isDark ? AppColors.gray : Colors.black,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!
                .translate('locationPermissionRequired'),
            style: AppTextStyles.blackS18W700.withThemeColor(context),
=======
          Icon(Icons.location_off, color: AppColors.gray, size: 64.sp),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(
              context,
            )!.translate('locationPermissionRequired'),
            style: AppTextStyles.blackS18W700,
>>>>>>> zoz
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
<<<<<<< HEAD
            AppLocalizations.of(context)!
                .translate('locationPermissionMessage'),
            style: AppTextStyles.secondaryS14W400.withThemeColor(context),
=======
            AppLocalizations.of(
              context,
            )!.translate('locationPermissionMessage'),
            style: AppTextStyles.secondaryS14W400,
>>>>>>> zoz
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () async {
              // Request location permission
              bool hasPermission =
                  await LocationService.requestLocationPermission();
              if (hasPermission) {
                context.read<ServiceCubit>().loadServices(limit: 10);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
<<<<<<< HEAD
                    content: Text(AppLocalizations.of(context)!
                        .translate('locationPermissionMessage')),
=======
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.translate('locationPermissionMessage'),
                    ),
>>>>>>> zoz
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.translate('allowLocationAccess'),
<<<<<<< HEAD
              style: AppTextStyles.secondaryS14W400
                  .copyWith(
                    fontWeight: FontWeight.w600,
                  )
                  .withThemeColor(context),
=======
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
>>>>>>> zoz
            ),
          ),
        ],
      ),
    );
  }
}
