import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/widgets/location_disclosure_screen.dart';
import '../manager/service_cubit.dart';
import '../manager/service_state.dart';
import '../widgets/nearby_services_map_widget.dart';
import '../widgets/nearby_service_card_widget.dart';
import '../widgets/nearby_services_filter_widget.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/models/service_model.dart';

class NearbyServicesScreen extends StatefulWidget {
  const NearbyServicesScreen({super.key});

  @override
  State<NearbyServicesScreen> createState() => _NearbyServicesScreenState();
}

class _NearbyServicesScreenState extends State<NearbyServicesScreen> {
  List<ServiceModel> _previousServices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCubit>().loadServices(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<ServiceCubit, ServiceState>(
        buildWhen: (previous, current) {
          return previous.services != current.services ||
              previous.isLoading != current.isLoading ||
              previous.error != current.error ||
              previous.selectedFilter != current.selectedFilter;
        },
        builder: (context, state) {
          // Track previous services to keep map visible when filtering returns empty
          if (state.services.isNotEmpty) {
            _previousServices = List.from(state.services);
          }

          // Show full page loading only on initial load (when no services loaded yet)
          final isInitialLoad = state.isLoading && !state.hasAttemptedLoad;
          final isFiltering = state.isLoading && state.hasAttemptedLoad;

          if (isInitialLoad) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && !isFiltering) {
            if (state.error!.contains('location') ||
                state.error!.contains('permission')) {
              return Center(child: _buildLocationPermissionWidget(context));
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.gray, size: 48.sp),
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
                    child: Text(
                      AppLocalizations.of(context)!.translate('retry'),
                    ),
                  ),
                ],
              ),
            );
          }

          // Show empty state only on initial load when no services and not filtering
          if (state.services.isEmpty &&
              !isFiltering &&
              !state.hasAttemptedLoad) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    )!
                        .translate('noNearbyServicesMessage'),
                    style: AppTextStyles.secondaryS14W400,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServiceCubit>().loadServices(
                            limit: 10,
                            forceRefresh: true,
                          );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('retry'),
                    ),
                  ),
                ],
              ),
            );
          }

          // Show map and filters, with loading only in list section when filtering
          // Use previous services for map when current services are empty (after filtering)
          final servicesForMap = state.services.isNotEmpty
              ? state.services
              : (_previousServices.isNotEmpty
                  ? _previousServices
                  : <ServiceModel>[]);

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Always show map if we have services (even when filtering)
                  if (servicesForMap.isNotEmpty)
                    NearbyServicesMapWidget(services: servicesForMap),
                  NearbyServicesFilterWidget(
                    selectedFilter: state.selectedFilter,
                    onFilterChanged: (filter) {
                      context.read<ServiceCubit>().filterServices(filter);
                    },
                  ),
                  Expanded(
                    child: isFiltering
                        ? const Center(child: CircularProgressIndicator())
                        : state.services.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_off,
                                        color: AppColors.gray, size: 48.sp),
                                    SizedBox(height: 16.h),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('noNearbyServices'),
                                      style: AppTextStyles.blackS16W600,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('noNearbyServicesMessage'),
                                      style: AppTextStyles.secondaryS14W400,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                itemCount: state.services.length,
                                itemBuilder: (context, index) {
                                  final service = state.services[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: NearbyServiceCardWidget(
                                      service: service,
                                      onShowOnMap: () {
                                        context.push('/service-map',
                                            extra: service);
                                      },
                                      onMoreDetails: () {
                                        context.push('/service-details',
                                            extra: service);
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black, size: 24.sp),
        onPressed: () => context.pop(),
      ),
      title: Text(
        AppLocalizations.of(context)!.translate('nearbyServices'),
        style: AppTextStyles.blackS18W700,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.my_location, color: AppColors.primary, size: 24.sp),
          onPressed: () {
            context.read<ServiceCubit>().loadServices(
                  limit: 10,
                  forceRefresh: true,
                );
          },
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: AppColors.black, size: 24.sp),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Filter options')));
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildLocationPermissionWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, color: AppColors.gray, size: 64.sp),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(
              context,
            )!
                .translate('locationPermissionRequired'),
            style: AppTextStyles.blackS18W700,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(
              context,
            )!
                .translate('locationPermissionMessage'),
            style: AppTextStyles.secondaryS14W400,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              // Show prominent full-screen disclosure first (Google Play requirement)
              showLocationDisclosureScreen(
                context,
                onPermissionGranted: () async {
                  // Permission granted - load services directly without checking permission again
                  final cubit = context.read<ServiceCubit>();
                  cubit.clearError();
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (context.mounted) {
                    cubit.loadServicesWithoutPermissionCheck(limit: 10);
                  }
                },
                onPermissionDenied: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!
                            .translate('locationPermissionMessage'),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              );
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
              style: AppTextStyles.secondaryS14W400.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
