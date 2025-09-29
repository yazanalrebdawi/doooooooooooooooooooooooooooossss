import 'dart:async';


import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.onPhoneNumberSelected,
    this.validator,
  });
  final void Function(String?) onPhoneNumberSelected;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String? _phone;
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 18,
        ),
        // filled: true,
        labelText: 'Your Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      initialCountryCode: 'SY',
      onChanged: (phone) {
        setState(() {
          _phone = phone.number;
        });
         widget.onPhoneNumberSelected(_phone);
      },
      dropdownTextStyle: const TextStyle(fontSize: 14),
      validator: widget.validator,
    );
  }
}
