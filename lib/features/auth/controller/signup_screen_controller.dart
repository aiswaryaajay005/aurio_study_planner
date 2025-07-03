import 'package:aurio/core/services/supabase_helper.dart';
import 'package:flutter/material.dart';

class SignupScreenController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final gradeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isChecked = false;
  bool isLoading = false;

  Future<String?> signupUser() async {
    // Check if form is valid
    if (!formKey.currentState!.validate()) {
      return "Please fill in all the fields correctly.";
    }

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      return "Passwords do not match.";
    }

    // Check if the checkbox is selected
    if (!isChecked) {
      return "Please agree to the Terms & Conditions.";
    }

    try {
      isLoading = true;
      notifyListeners();

      // 1. Sign up user using email & password
      print(
        "SIGN UP → Email: ${emailController.text}, Password: ${passwordController.text}",
      );

      final response = await SupabaseHelper.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final userId = response?.user?.id;
      if (userId == null) {
        return "Sign up failed. Please try again.";
      }

      // 2. Save user profile in 'users' table
      await SupabaseHelper.insertUserProfile(
        userId: userId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        grade: gradeController.text.trim(),
      );

      return null; // Success
    } catch (e) {
      // Print and return the error message
      print("Signup Error: $e");
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Don't forget to dispose controllers
  void disposeAll() {
    nameController.dispose();
    emailController.dispose();
    gradeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
