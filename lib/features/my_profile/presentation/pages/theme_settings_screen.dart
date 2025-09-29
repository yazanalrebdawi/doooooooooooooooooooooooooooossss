import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/custom_app_bar_profile_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/selected_them_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarProfileWidget(title: "Theme Settings"),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            spacing: 15.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)?.translate("Choose Your Theme") ??
                    "Choose Your Theme",
                style: AppTextStyles.s16w500.copyWith(color: Color(0xff111827)),
              ),
              SelectedThemWidget(),
              // ContainerBaseWidget(
              //   height: 102,
              //   width: 358,
              //   padding: EdgeInsets.all(15),
              //   child: Column(
              //     spacing: 5.h,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         AppLocalizations.of(
              //               context,
              //             )?.translate("Auto Dark Mode") ??
              //             "Auto Dark Mode",
              //         style: AppTextStyles.s16w500.copyWith(
              //           color: Color(0xff111827),
              //         ),
              //       ),
              //       Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Expanded(
              //             child: Text(
              //               AppLocalizations.of(context)?.translate(
              //                     "Switch automatically based on system settings",
              //                   ) ??
              //                   "Switch automatically based on system settings",
              //               style: AppTextStyles.s14w400.copyWith(
              //                 color: Color(0xff4B5563),
              //               ),
              //             ),
              //           ),
              //           CustomSwitchWidget(initialValue: false),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 11.h),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       AppLocalizations.of(
              //             context,
              //           )?.translate("Display Preferences") ??
              //           "Display Preferences",
              //       style: AppTextStyles.s16w500.copyWith(
              //         color: Color(0xff111827),
              //       ),
              //     ),
              //     ProgressCardWidget(
              //       initialPercentage: 0.6,
              //       onPercentageChanged: (newValue) {
              //         log("القيمة الجديدة: $newValue");
              //       },
              //     ),
              //   ],
              // ),
              // ContainerBaseWidget(
              //   height: 98,
              //   width: 358,
              //   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         spacing: 4.h,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             AppLocalizations.of(
              //                   context,
              //                 )?.translate("Font Size") ??
              //                 "Font Size",
              //             style: AppTextStyles.s16w500.copyWith(
              //               color: Color(0xff111827),
              //             ),
              //           ),
              //           Text(
              //             AppLocalizations.of(context)?.translate(
              //                   "Adjust text size for better\nreadability",
              //                 ) ??
              //                 "Adjust text size for better\nreadability",
              //             style: AppTextStyles.s14w400.copyWith(
              //               color: Color(0xff4B5563),
              //             ),
              //           ),
              //         ],
              //       ),
              //       FontSizeDropdown(
              //         initialValue: "Small",
              //         onChanged: (value) {
              //           log("Selected: $value");
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
              //   child: CustomButtonWidget(
              //     width: 358,
              //     height: 56,
              //     text: "Apply Theme Settings",
              //     icon: Icons.check,
              //     textStyle: AppTextStyles.s16w500.copyWith(
              //       color: AppColors.buttonText,
              //     ),
              //     onPressed: () {
              //       log("apply");
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
