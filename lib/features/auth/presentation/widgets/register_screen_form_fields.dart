import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utiles/validator.dart';

import '../../data/models/create_account_params_model.dart';

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

class RegisterScreenFormFields extends StatefulWidget {
  final CreateAccountParams params;
  final Function(String) onFullNameChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onConfirmPasswordChanged;

  const RegisterScreenFormFields({
    super.key,
    required this.params,
    required this.onFullNameChanged,
    required this.onPhoneChanged,
    required this.onPasswordChanged,
    required this.onConfirmPasswordChanged,
  });

  @override
  State<RegisterScreenFormFields> createState() =>
      _RegisterScreenFormFieldsState();
}

class _RegisterScreenFormFieldsState extends State<RegisterScreenFormFields> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
    Country(
        name: 'Saudi Arabia',
        flagEmoji: '🇸🇦',
        phoneCode: '966',
        isoCode: 'SA'),
    Country(
        name: 'United Arab Emirates',
        flagEmoji: '🇦🇪',
        phoneCode: '971',
        isoCode: 'AE'),
    Country(name: 'Kuwait', flagEmoji: '🇰🇼', phoneCode: '965', isoCode: 'KW'),
    Country(name: 'Qatar', flagEmoji: '🇶🇦', phoneCode: '974', isoCode: 'QA'),
    Country(
        name: 'Bahrain', flagEmoji: '🇧🇭', phoneCode: '973', isoCode: 'BH'),
    Country(name: 'Oman', flagEmoji: '🇴🇲', phoneCode: '968', isoCode: 'OM'),
    Country(name: 'Jordan', flagEmoji: '🇯🇴', phoneCode: '962', isoCode: 'JO'),
    Country(
        name: 'Lebanon', flagEmoji: '🇱🇧', phoneCode: '961', isoCode: 'LB'),
    Country(name: 'Iraq', flagEmoji: '🇮🇶', phoneCode: '964', isoCode: 'IQ'),
    Country(name: 'Egypt', flagEmoji: '🇪🇬', phoneCode: '20', isoCode: 'EG'),
    Country(name: 'Turkey', flagEmoji: '🇹🇷', phoneCode: '90', isoCode: 'TR'),
  ];

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.h,
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Text(
                'Select Country',
                style: AppTextStyles.s16w600.withThemeColor(context),
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
                        style: AppTextStyles.s20w400.withThemeColor(context),
                      ),
                      title: Text(
                        country.name,
                        style: AppTextStyles.s16w400.withThemeColor(context),
                      ),
                      subtitle: Text(
                        '+${country.phoneCode}',
                        style: AppTextStyles.s14w400.withThemeColor(context),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                        });

                        if (_phoneNumberWithoutCode.isNotEmpty) {
                          String fullPhoneNumber =
                              '+${country.phoneCode}$_phoneNumberWithoutCode';
                          print('📱 Updated phone number: $fullPhoneNumber');
                          widget.onPhoneChanged(fullPhoneNumber);
                        }
                        Navigator.pop(context);
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
    return Column(
      children: [
        // Username Field
        TextFormField(
          controller: widget.params.userName,
          focusNode: widget.params.userNameNode,
          style: AppTextStyles.s16w400,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
            hintText: AppLocalizations.of(context)?.translate('username') ??
                'Username',
            hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          validator: (value) => Validator.notNullValidation(value),
          onChanged: (value) {
            widget.onFullNameChanged(value);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(widget.params.phonenumberNode);
          },
        ),
        SizedBox(height: 18.h),
        // Phone Number Field
        Container(
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
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
                  controller: widget.params.phoneNumber,
                  focusNode: widget.params.phonenumberNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                              ?.translate('phoneRequired') ??
                          'Phone number is required';
                    }
                    if (value.length < 9) {
                      return AppLocalizations.of(context)
                              ?.translate('phoneInvalid') ??
                          'Phone number is too short';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.s16w400,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: AppLocalizations.of(context)
                            ?.translate('phoneNumber') ??
                        'Phone Number',
                    hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                  ),
                  onChanged: (value) {
                    print('📱 Phone field changed: $value');
                    _phoneNumberWithoutCode = value;
                    String fullPhoneNumber =
                        '+${_selectedCountry.phoneCode}$value';
                    print('📱 Full phone number: $fullPhoneNumber');
                    print('📱 Calling onPhoneChanged callback');
                    widget.onPhoneChanged(fullPhoneNumber);
                  },
                  onFieldSubmitted: (value) {
                    FocusScope.of(context)
                        .requestFocus(widget.params.passwordNode);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        // Password Field
        TextFormField(
          controller: widget.params.password,
          focusNode: widget.params.passwordNode,
          obscureText: !_isPasswordVisible,
          style: AppTextStyles.s16w400,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            hintText: AppLocalizations.of(context)?.translate('password') ??
                'Password',
            hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          validator: (value) => Validator.notNullValidation(value),
          onChanged: (value) {
            widget.onPasswordChanged!(value);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context)
                .requestFocus(widget.params.confirmPasswordNode);
          },
        ),
        SizedBox(height: 18.h),
        // Confirm Password Field
        TextFormField(
          controller: widget.params.confirmPassword,
          focusNode: widget.params.confirmPasswordNode,
          obscureText: !_isConfirmPasswordVisible,
          style: AppTextStyles.s16w400,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            hintText:
                AppLocalizations.of(context)?.translate('confirmPassword') ??
                    'Confirm Password',
            hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.gray, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(
                    context,
                  )?.translate('confirmPassword') ??
                  'Please confirm your password';
            }
            if (value != widget.params.password.text) {
              return AppLocalizations.of(
                    context,
                  )?.translate('passwordsDoNotMatch') ??
                  'Passwords do not match';
            }
            return null;
          },
          onChanged: (value) {
            widget.onConfirmPasswordChanged!(value);
          },
        ),
        SizedBox(height: 18.h),
        // Address Field
        // TextFormField(
        //   controller:
        //       widget
        //           .params.addressController, // استخدام addressController الجديد
        //   focusNode: widget.params.addressNode,
        //   style: AppTextStyles.s16w400,
        //   decoration: InputDecoration(
        //     prefixIcon: Icon(
        //       Icons.location_on_outlined,
        //       color: AppColors.primary,
        //     ),
        //     hintText:
        //         AppLocalizations.of(context)?.translate('address') ?? 'Address',
        //     hintStyle: AppTextStyles.hintTextStyleWhiteS20W400,
        //     border: OutlineInputBorder(
        //       borderSide: const BorderSide(color: AppColors.gray, width: 1),
        //       borderRadius: BorderRadius.circular(10.r),
        //     ),
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: const BorderSide(color: AppColors.gray, width: 1),
        //       borderRadius: BorderRadius.circular(10.r),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: const BorderSide(color: AppColors.primary, width: 1),
        //       borderRadius: BorderRadius.circular(10.r),
        //     ),
        //     errorBorder: OutlineInputBorder(
        //       borderSide: const BorderSide(color: Colors.red, width: 1),
        //       borderRadius: BorderRadius.circular(10.r),
        //     ),
        //     contentPadding: EdgeInsets.symmetric(
        //       horizontal: 16.w,
        //       vertical: 18.h,
        //     ),
        //     filled: true,
        //     fillColor: AppColors.white,
        //   ),
        //   validator: (value) => Validator.notNullValidation(value),
        //   onChanged: (value) {
        //     widget.onPhoneChanged(value);
        //   },
        // ),
        SizedBox(height: 18.h),
      ],
    );
  }
}
