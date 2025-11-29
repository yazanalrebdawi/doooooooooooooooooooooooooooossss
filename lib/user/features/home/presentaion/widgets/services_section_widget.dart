import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/widgets/location_disclosure_screen.dart';
import '../manager/service_cubit.dart';
import '../manager/service_state.dart';
import 'service_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/app_localizations.dart';

class ServicesSectionWidget extends StatefulWidget {
  const ServicesSectionWidget({super.key});

  @override
  State<ServicesSectionWidget> createState() => _ServicesSectionWidgetState();
}

class _ServicesSectionWidgetState extends State<ServicesSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCubit, ServiceState>(
      listenWhen: (previous, current) => 
          previous.error != current.error && 
          previous.error != null && 
          current.error == null,
      listener: (context, state) {
        // Error was cleared - reload services
        Future.microtask(() {
          if (mounted) {
            context.read<ServiceCubit>().loadServicesWithoutPermissionCheck(
              limit: 10,
              type: 'station',
              radius: 5000,
            );
          }
        });
      },
      child: BlocBuilder<ServiceCubit, ServiceState>(
        buildWhen: (previous, current) {
          return previous.services != current.services ||
              previous.isLoading != current.isLoading ||
              previous.error != current.error ||
              previous.hasAttemptedLoad != current.hasAttemptedLoad;
        },
        builder: (context, state) {
        // Priority 1: Show error if present (don't show loading if there's an error)
        if (state.error != null) {
          // Specific handling for location permission errors
          if (state.error!.contains('location') ||
              state.error!.contains('permission')) {
            // Check permission again - it might have been granted
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final hasPermission = await LocationService.checkLocationPermission(forceRefresh: true);
              if (hasPermission && context.mounted) {
                // Permission is now granted, reload services
                context.read<ServiceCubit>().clearError();
                context.read<ServiceCubit>().loadServices(
                  limit: 10,
                  type: 'station',
                  radius: 5000,
                  forceRefresh: true,
                );
              }
            });
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

        // Priority 2: Show loading ONLY if actively loading AND no error
        // Don't show loading if we have an error (even if isLoading is true)
        if (state.isLoading && state.error == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        
        // If we haven't attempted to load yet and there's no error, show loading
        if (!state.hasAttemptedLoad && state.error == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
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
      ),
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
            onPressed: () {
              // Show prominent full-screen disclosure first (Google Play requirement)
              showLocationDisclosureScreen(
                context,
                onPermissionGranted: () {
                  // Permission granted - use setState to force rebuild
                  // This will trigger the BlocBuilder to rebuild and check state again
                  if (context.mounted) {
                    // Clear error and reload immediately
                    final cubit = context.read<ServiceCubit>();
                    cubit.clearError();
                    
                    // Use Future.microtask to ensure state is cleared first
                    Future.microtask(() {
                      if (context.mounted) {
                        cubit.loadServicesWithoutPermissionCheck(
                          limit: 10,
                          type: 'station',
                          radius: 5000,
                        );
                      }
                    });
                  }
                },
                onPermissionDenied: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('locationPermissionMessage')),
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
