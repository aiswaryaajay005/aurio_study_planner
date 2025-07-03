import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordController with ChangeNotifier {
  final emailController = TextEditingController();
  bool isLoading = false;
  String? message;
  bool isError = false;

  Future<void> sendResetLink(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _setMessage("Please enter a valid email.", true);
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      _setMessage("Reset link sent! Check your email.", false);
    } catch (e) {
      _setMessage("Error: ${e.toString()}", true);
    }

    isLoading = false;
    notifyListeners();
  }

  void _setMessage(String msg, bool error) {
    message = msg;
    isError = error;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
