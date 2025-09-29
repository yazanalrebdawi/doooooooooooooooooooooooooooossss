import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utiles/validator.dart';

// Country model
class Country {
  final String name;
  final String flagEmoji;
  final String phoneCode;
  final String isoCode;

  Country({
    required this.name,
    required this.flagEmoji,
    required this.phoneCode,
    required this.isoCode,
  });
}

class PhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String) onPhoneChanged;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.validator,
    required this.onPhoneChanged,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  // Country selection
  Country _selectedCountry = Country(
    name: 'Syria',
    flagEmoji: '🇸🇾',
    phoneCode: '963',
    isoCode: 'SY',
  );
  
  // Store phone number without country code
  String _phoneNumberWithoutCode = '';

  // List of available countries
  final List<Country> _countries = [
    Country(name: 'Syria', flagEmoji: '🇸🇾', phoneCode: '963', isoCode: 'SY'),
    Country(name: 'Saudi Arabia', flagEmoji: '🇸🇦', phoneCode: '966', isoCode: 'SA'),
    Country(name: 'United Arab Emirates', flagEmoji: '🇦🇪', phoneCode: '971', isoCode: 'AE'),
    Country(name: 'Kuwait', flagEmoji: '🇰🇼', phoneCode: '965', isoCode: 'KW'),
    Country(name: 'Qatar', flagEmoji: '🇶🇦', phoneCode: '974', isoCode: 'QA'),
    Country(name: 'Bahrain', flagEmoji: '🇧🇭', phoneCode: '973', isoCode: 'BH'),
    Country(name: 'Oman', flagEmoji: '🇴🇲', phoneCode: '968', isoCode: 'OM'),
    Country(name: 'Jordan', flagEmoji: '🇯🇴', phoneCode: '962', isoCode: 'JO'),
    Country(name: 'Lebanon', flagEmoji: '🇱🇧', phoneCode: '961', isoCode: 'LB'),
    Country(name: 'Iraq', flagEmoji: '🇮🇶', phoneCode: '964', isoCode: 'IQ'),
    Country(name: 'Egypt', flagEmoji: '🇪🇬', phoneCode: '20', isoCode: 'EG'),
    Country(name: 'Turkey', flagEmoji: '🇹🇷', phoneCode: '90', isoCode: 'TR'),
  ];

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.h,
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Text(
                'Select Country',
                style: AppTextStyles.s16w600,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    return ListTile(
                      leading: Text(
                        country.flagEmoji,
                        style: AppTextStyles.s20w400,
                      ),
                      title: Text(
                        country.name,
                        style: AppTextStyles.s14w400,
                      ),
                      subtitle: Text(
                        '+${country.phoneCode}',
                        style: AppTextStyles.s12w400,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                        });
                        Navigator.pop(context);
                        
                        // Update full phone number
                        String fullPhoneNumber = '+${country.phoneCode}$_phoneNumberWithoutCode';
                        widget.onPhoneChanged(fullPhoneNumber);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.gray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Country Selector
          GestureDetector(
            onTap: () => _showCountryPicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCountry.flagEmoji,
                    style: AppTextStyles.s20w400,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '+${_selectedCountry.phoneCode}',
                    style: AppTextStyles.s16w400,
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          
          // Divider
          Container(
            height: 40.h,
            width: 1,
            color: AppColors.gray,
          ),
          
          // Phone Number Input
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator ?? (value) => Validator.notNullValidation(value),
              keyboardType: TextInputType.phone,
              style: AppTextStyles.s16w400,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.translate('phoneNumber') ?? 'Phone Number',
                hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              ),
              onChanged: (value) {
                print('📱 Phone field changed: $value');
                _phoneNumberWithoutCode = value;
                String fullPhoneNumber = '+${_selectedCountry.phoneCode}$value';
                print('📱 Full phone number: $fullPhoneNumber');
                print('📱 Calling onPhoneChanged callback');
                widget.onPhoneChanged(fullPhoneNumber);
              },
            ),
          ),
        ],
      ),
    );
  }
} 