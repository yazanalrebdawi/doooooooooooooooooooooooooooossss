import 'package:dooss_business_app/core/routes/route_names.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/features/home/presentaion/widgets/empty_section.dart';
import 'package:dooss_business_app/features/home/data/models/service_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesSection extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicesSection({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Car Services',
                style: AppTextStyles.blackS18W700,
              ),
              
               TextButton(
                  onPressed: () {
                    context.push(RouteNames.nearbyServicesScreen);
                  },
                  child: Text(
                    'View All',
                    style: AppTextStyles.primaryS16W600,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          // Services List
          if (services.isEmpty)
            EmptySection(message: 'No services available')
          else
            ...services.map((service) => Column(
              children: [
                ServiceCardWidget(
                  service: service,
                  onViewDetails: () {
                    // Navigate to service details
                    print('🔍 ServicesSection: View Details pressed for service: ${service.name}');
                    print('🔍 ServicesSection: Service ID: ${service.id}');
                    context.push('/service-details', extra: service);
                  },
                  onMaps: () async {
                    // Launch maps
                    final url = service.mapsUrl;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  onCall: () async {
                    // Launch call
                    final url = service.callUrl;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                ),
                SizedBox(height: 12.h),
              ],
            )),
        ],
      ),
    );
  }
}
