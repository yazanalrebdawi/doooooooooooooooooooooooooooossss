<<<<<<< HEAD
abstract class Validator {
  static String? phoneValidation(String? phone) {
    final phoneRegex = RegExp(r'^09[0-9]{8}$');
=======
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

abstract class Validator {
  static String? phoneValidation(String? phone) {
    final phoneRegex = RegExp(r'^\+[0-9]{9,15}$');
>>>>>>> zoz
    if (!phoneRegex.hasMatch(phone!)) return 'Phone is not valid';
    return null;
  }

  static String? emailValidation(String? email) {
    email = email?.trim();
    bool valid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email!);

    if (valid) {
      return null;
    } else {
      return "Email is not valid";
    }
  }

  static String? notNullValidation(String? str) =>
      (str == null || str == '') ? 'This Filed is required' : null;

  static String? notNullValidationValue(String? str) =>
      (str == null || str == '') ? '' : null;

  static String? validatePhone(String? value) {
    if (value!.isEmpty || value.length < 8) {
      return 'not correct';
    } else {
      return null;
    }
  }

<<<<<<< HEAD
  static String? validatePass(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Password';
=======
  static String? validatePassword(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)?.translate('Please enter Password') ??
          'Please enter Password';
>>>>>>> zoz
    } else if (value.length < 8 || value.length > 32) {
      return 'Password value range 8-32 char';
    } else {
      return null;
    }
  }

  static String? validateDateOfBirth(String? value) {
<<<<<<< HEAD
    RegExp regex =
        RegExp(r"^(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$");
=======
    RegExp regex = RegExp(
      r"^(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$",
    );
>>>>>>> zoz
    if (!regex.hasMatch(value!)) {
      return 'Date of birth is not valid, please enter YYYY-MM-DD';
    }
    return null;
  }
<<<<<<< HEAD
=======

  static String? validateName(String? value) {
    {
      if (value == null || value.isEmpty) {
        return 'Name cannot be empty!';
      } else if (value.length < 3) {
        return 'Name must be at least 3 characters!';
      }
      return null;
    }
  }
>>>>>>> zoz
}
