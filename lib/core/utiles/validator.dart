abstract class Validator {
  static String? phoneValidation(String? phone) {
    final phoneRegex = RegExp(r'^09[0-9]{8}$');
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

  static String? validatePass(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Password';
    } else if (value.length < 8 || value.length > 32) {
      return 'Password value range 8-32 char';
    } else {
      return null;
    }
  }

  static String? validateDateOfBirth(String? value) {
    RegExp regex =
        RegExp(r"^(19|20)\d\d[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$");
    if (!regex.hasMatch(value!)) {
      return 'Date of birth is not valid, please enter YYYY-MM-DD';
    }
    return null;
  }
}
