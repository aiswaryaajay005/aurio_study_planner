// form_validation.dart

class FormValidation {
  // Email Validation
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Oops! You forgot to enter your email.';
    }
    if (!email.contains('@')) {
      return 'Missing "@" symbol! Are you sure this is an email?';
    }
    if (!email.contains('.')) {
      return 'Your email is incomplete! A "." is required (e.g., .com, .net, .org)';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      return 'This doesn\'t look like a real email. Double-check the format!';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    }

    // Password must be at least 8 characters
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter (A-Z)';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter (a-z)';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number (0-9)';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must include at least one special character (!@#\$%^&*)';
    }

    return null; // Password is valid
  }

  // Confirm Password Validation
  static String? validateConfirmPassword(
    String? confirmPassword,
    String? password,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Contact Number Validation (example: 10 digits)
  static String? validateContact(String? contact) {
    if (contact == null || contact.isEmpty) {
      return 'Please enter a contact number';
    }
    // Regex for 10-digit contact number (you can modify this pattern for specific formats)
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(contact)) {
      return 'Please enter a valid 10-digit contact number';
    }
    return null;
  }

  // Name Validation
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  // Address Validation
  static String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  // Dropdown Validation
  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }

  static String? validateValue(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }
}
