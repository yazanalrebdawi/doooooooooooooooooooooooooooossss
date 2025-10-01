import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import 'country_field.dart';
import 'phone_number_field.dart';

class ForgetPasswordFormFields extends StatelessWidget {
  final String? selectedCountry;
  final VoidCallback? onCountryTap;
  final TextEditingController? phoneController;
  final String? Function(String?)? phoneValidator;
  final void Function(String)? onPhoneChanged;

  const ForgetPasswordFormFields({
    super.key,
    this.selectedCountry,
    this.onCountryTap,
    this.phoneController,
    this.phoneValidator,
    this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Country Field
        CountryField(
          selectedCountry: selectedCountry,
          onTap: onCountryTap,
        ),
        SizedBox(height: 16.h),
        // Phone Number Field
        PhoneNumberField(
          controller: phoneController!,
          validator: phoneValidator,
          onPhoneChanged: onPhoneChanged!,
        ),
        SizedBox(height: 18.h),
      ],
    );
  }
} 