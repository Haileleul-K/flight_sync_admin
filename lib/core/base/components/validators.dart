class Validator {
  static String? validateNotEmpty(String? value, {String fieldName = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName cannot be empty.";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email cannot be empty.";
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address.";
    }
    return null;
  }

  static String? validateOnlyNumber(String? value, {
    
    String fieldName = "Value"}) {
      if (value == null || value.trim().isEmpty) {
    return 'This field must not be empty';
  }

  final trimmedValue = value.trim();

  try {
    // Try to parse the number
    double.parse(trimmedValue);
  } catch (_) {
    return 'Invalid number';
  }

  return null;
  }

  static String? validateOnlyString(String? value, {String fieldName = "Text"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName cannot be empty.";
    }

    final stringRegex = RegExp(r"^[a-zA-Z\s]+$");
    if (!stringRegex.hasMatch(value.trim())) {
      return "$fieldName must contain letters only.";
    }
    return null;
  }
}
