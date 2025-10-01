import 'package:flutter/material.dart';
import 'package:dooss_business_app/dealer/Core/style/app_Colors.dart';
import 'package:dooss_business_app/dealer/Core/style/app_text_style.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/Add_services_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/page/add_new_car_page.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/add_tags_widget.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_dropdown_list_with_title.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/custom_form_with_title.dart';
import 'package:dooss_business_app/dealer/features/Home/presentation/widget/select_rangePrice_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesInformationWidget extends StatelessWidget {
  const ServicesInformationWidget({
    super.key,
    required this.nameServices,
    required this.description,
    required this.minPriceRange,
    required this.maxPriceRange,
  });

  final TextEditingController nameServices;
  final TextEditingController description;
  final TextEditingController minPriceRange;
  final TextEditingController maxPriceRange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(24, 0, 0, 0),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text('Services inforation', style: AppTextStyle.Poppins718),
              ],
            ),
          ),
          Divider(color: AppColors.borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomFormWithTitleWidget(
                  model: nameServices,
                  hintForm: 'e.g., Car Towing, Quick Oil Change',
                  title: 'Service Name ',
                  isImportant: true,
                ),
                SizedBox(height: 16.h),
                CustomDropDownListWithTitleWidget(
                  items: [],
                  CurrentValue: (value) {},
                  hintForm: 'Select Caterory',
                  title: 'category',
                ),
                SizedBox(height: 16.h),
                CustomFormWithTitleWidget(
                  model: description,
                  hintForm: 'Explain your service clearly (what,\nhow, why)',
                  title: 'Description ',
                  isImportant: true,
                  lineNum: 2,
                ),
                SizedBox(height: 16.h),
                selectRangePriceWidget(
                  minPriceRange: minPriceRange,
                  maxPriceRange: maxPriceRange,
                ),
                SizedBox(height: 16.h),
                CustomDropDownListWithTitleWidget(
                  items: [],
                  CurrentValue: (value) {},
                  hintForm: 'Select Duration',
                  title: 'Estimated Time',
                ),
                SizedBox(height: 16.h),
                AddTagsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
