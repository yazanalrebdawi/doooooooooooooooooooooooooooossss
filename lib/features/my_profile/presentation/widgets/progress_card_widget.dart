import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/container_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class ProgressCardWidget extends StatefulWidget {
  final double initialPercentage;
  final ValueChanged<double>? onPercentageChanged;

  const ProgressCardWidget({
    super.key,

    this.initialPercentage = 0.0,
    this.onPercentageChanged,
  });

  @override
  State<ProgressCardWidget> createState() => _ProgressCardWidgetState();
}

class _ProgressCardWidgetState extends State<ProgressCardWidget> {
  late double percentage;

  @override
  void initState() {
    super.initState();
    percentage = widget.initialPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return ContainerBaseWidget(
      height: 109,
      width: 358,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)?.translate("Screen Brightness") ??
                    "Screen Brightness",
                style: AppTextStyles.s16w500.copyWith(color: Color(0xff111827)),
              ),
              Text(
                "${(percentage * 100).toInt()}%",
                style: AppTextStyles.s14w400.copyWith(color: Color(0xff4B5563)),
              ),
            ],
          ),
          FlutterSlider(
            values: [percentage * 100],
            max: 100,
            min: 0,
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBarHeight: 8.h,
              activeTrackBarHeight: 8.h,
              inactiveTrackBar: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20),
              ),
              activeTrackBar: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            handler: FlutterSliderHandler(
              decoration: const BoxDecoration(),
              child: Container(
                width: 16.w,
                height: 16.h,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            rightHandler: FlutterSliderHandler(
              decoration: const BoxDecoration(),
              child: Container(
                width: 16.w,
                height: 16.h,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            hatchMark: FlutterSliderHatchMark(disabled: true),
            tooltip: FlutterSliderTooltip(disabled: true),
            onDragging: (handlerIndex, lowerValue, upperValue) {
              setState(() {
                percentage = lowerValue / 100;
              });
              widget.onPercentageChanged?.call(percentage);
            },
          ),
        ],
      ),
    );
  }
}
