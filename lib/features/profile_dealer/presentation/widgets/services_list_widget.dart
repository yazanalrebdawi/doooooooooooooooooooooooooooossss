import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/service_model.dart';
import 'service_list_item.dart';
import 'filter_button_widget.dart';

class ServicesListWidget extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicesListWidget({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter Buttons
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              FilterButtonWidget(
                text: 'All Services',
                isSelected: true,
                icon: Icons.filter_list,
              ),
              SizedBox(width: 12.w),
              FilterButtonWidget(
                text: 'Mechanic',
                isSelected: false,
                icon: Icons.build,
              ),
              SizedBox(width: 12.w),
              FilterButtonWidget(
                text: 'Fuel',
                isSelected: false,
                icon: Icons.local_gas_station,
              ),
            ],
          ),
        ),
        // Services List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: services.length,
            itemBuilder: (context, index) {
              return ServiceListItem(service: services[index]);
            },
          ),
        ),
      ],
    );
  }
}
