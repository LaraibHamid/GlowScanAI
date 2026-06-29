/// ======================================================
/// GlowScanAI — Form Validators
/// Use these methods for validating user inputs.
/// Example:
/// validator: Validators.validateEmail
/// ======================================================

class Validators {

  const Validators._(); // Prevent class instantiation


  // ======================================================
  // EMAIL VALIDATION
  // ======================================================

  static String? validateEmail(String? value) {

    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex =
    RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }


  // ======================================================
  // PASSWORD VALIDATION
  // ======================================================

  static String? validatePassword(String? value) {

    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }


  // ======================================================
  // NAME VALIDATION
  // ======================================================

  static String? validateName(String? value) {

    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Enter a valid name';
    }

    return null;
  }


  // ======================================================
  // PHONE VALIDATION
  // ======================================================

  static String? validatePhone(String? value) {

    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

    if (!phoneRegex.hasMatch(phone)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

}

