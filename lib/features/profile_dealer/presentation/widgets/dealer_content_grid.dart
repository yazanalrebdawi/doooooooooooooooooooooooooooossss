import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../data/models/reel_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/content_type.dart';
import '../../../home/data/models/car_model.dart';
import 'reel_grid_item.dart';
import 'car_grid_item.dart';
import 'service_list_item.dart';
import 'empty_content_widget.dart';
import 'reels_grid_widget.dart';
import 'cars_grid_widget.dart';
import 'services_list_widget.dart';

class DealerContentGrid extends StatelessWidget {
  final ContentType contentType;
  final List<dynamic> content;
  final bool isLoading;

  const DealerContentGrid({
    super.key,
    required this.contentType,
    required this.content,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (content.isEmpty) {
      return EmptyContentWidget(contentType: contentType);
    }

    switch (contentType) {
      case ContentType.reels:
        return ReelsGridWidget(reels: content.cast<ReelModel>());
      case ContentType.cars:
        return CarsGridWidget(cars: content.cast<CarModel>());
      case ContentType.services:
        return ServicesListWidget(services: content.cast<ServiceModel>());
    }
  }


}
