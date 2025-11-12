import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../manager/service_cubit.dart';
import '../manager/service_state.dart';
import 'service_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/app_localizations.dart';

class ServicesSectionWidget extends StatelessWidget {
  const ServicesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      buildWhen: (previous, current) {
        return previous.services != current.services ||
            previous.isLoading != current.isLoading ||
            previous.error != current.error ||
            previous.hasAttemptedLoad != current.hasAttemptedLoad;
      },
      builder: (context, state) {
        // Show loading if actively loading OR if we haven't attempted to load yet
        if (state.isLoading || !state.hasAttemptedLoad) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state.error != null) {
          // Specific handling for location permission errors
          if (state.error!.contains('location') ||
              state.error!.contains('permission')) {
            return Center(child: _buildLocationPermissionWidget(context));
          }

          // General error display
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
              ],
            ),
          );
        }

        // Use services directly (no filtering)
        final services = state.services;

        // Only show "no service available" if truly empty (not loading, has error or explicitly empty)
        if (services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_gas_station_outlined,
                    color: AppColors.gray, size: 64.sp),
                SizedBox(height: 16.h),
                Text(
                  AppLocalizations.of(context)
                          ?.translate('noServiceAvailable') ??
                      'No services available',
                  style: AppTextStyles.blackS16W600,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)
                          ?.translate('checkBackLaterForNewServices') ??
                      'Check back later for new services',
                  style: AppTextStyles.secondaryS14W400,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // List of services
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return ServiceCardWidget(
              service: service,
              onViewDetails: () {
                print('🔍 Viewing details for service: ${service.name}');
                context.push('/service-details', extra: service);
              },
              onMaps: () async {
                final url = service.mapsUrl;
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
              onCall: () async {
                final url = service.callUrl;
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                }
              },
            );
          },
        );
      },
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
            AppLocalizations.of(context)!
                .translate('locationPermissionRequired'),
            style: AppTextStyles.blackS18W700,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)!
                .translate('locationPermissionMessage'),
            style: AppTextStyles.secondaryS14W400,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () async {
              bool hasPermission =
                  await LocationService.requestLocationPermission();
              if (hasPermission) {
                context.read<ServiceCubit>().loadServices(
                      limit: 10,
                      type: 'station',
                      radius: 5000,
                      forceRefresh: true,
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .translate('locationPermissionMessage')),
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
