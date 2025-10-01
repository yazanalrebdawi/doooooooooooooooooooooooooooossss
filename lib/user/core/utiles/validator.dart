import 'package:dooss_business_app/user/core/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

abstract class Validator {
  /// Validate international phone number (e.g., +1234567890)
  static String? phoneValidation(String? phone) {
    final phoneRegex = RegExp(r'^\+[0-9]{9,15}$');
    if (phone == null || !phoneRegex.hasMatch(phone)) {
      return 'Phone is not valid';
    }
    return null;
  }

  /// Validate email format
  static String? emailValidation(String? email) {
    email = email?.trim();
    bool valid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email ?? '');

    if (!valid) {
      return "Email is not valid";
    }
    return null;
  }

  /// Validate not null or empty field
  static String? notNullValidation(String? str) =>
      (str == null || str.isEmpty) ? 'This field is required' : null;

  /// Validate and return empty string if null
  static String? notNullValidationValue(String? str) =>
      (str == null || str.isEmpty) ? '' : null;

  /// Validate phone number length
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Not correct';
    }
    return null;
  }

  /// Validate password with context for localization
  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.translate('Please enter Password') ??
          'Please enter Password';
    } else if (value.length < 8 || value.length > 32) {
      return 'Password must be 8-32 characters';
    }
    return null;
  }

  /// Validate date of birth in YYYY-MM-DD format
  static String? validateDateOfBirth(String? value) {
    final regex = RegExp(
      r"^(19|20)\d\d-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$",
    );
    if (value == null || !regex.hasMatch(value)) {
      return 'Date of birth is not valid, please enter YYYY-MM-DD';
    }
    return null;
  }

  /// Validate name (at least 3 characters)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty!';
    } else if (value.length < 3) {
      return 'Name must be at least 3 characters!';
    }
    return null;
  }
}
