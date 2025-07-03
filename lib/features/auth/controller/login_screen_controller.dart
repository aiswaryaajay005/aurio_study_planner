import 'package:aurio/features/profile_setup/view/profile_set_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/bottom_navbar/view/bottom_navbar.dart';

class LoginScreenController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<String?> loginUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return "Please fill in all fields correctly.";
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await SupabaseHelper.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final user = response?.user;
      if (user == null) {
        return "Login failed. Please try again.";
      }

      final profileResponse =
          await SupabaseHelper.client
              .from('users')
              .select('profile_completed')
              .eq('id', user.id)
              .single();

      final isComplete = profileResponse['profile_completed'] == true;

      if (isComplete) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavbar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileSetUpScreen()),
        );
      }

      return null;
    } catch (e) {
      print("Login Error: $e");
      return "Invalid password or email.Try again.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeAll() {
    emailController.dispose();
    passwordController.dispose();
  }
}
