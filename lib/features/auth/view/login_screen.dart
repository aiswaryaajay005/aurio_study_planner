import 'package:aurio/features/auth/view/forgot_password_screen.dart';
import 'package:aurio/features/bottom_navbar/view/bottom_navbar.dart';
import 'package:aurio/features/auth/controller/login_screen_controller.dart';
import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:aurio/shared/widgets/reuable_header.dart';
import 'package:aurio/shared/widgets/reusable_button.dart';
import 'package:aurio/shared/widgets/reusable_text_form_field.dart';
import 'package:aurio/core/utils/form_validation.dart';
import 'package:aurio/features/auth/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginScreenState = context.watch<LoginScreenController>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),

              ReusableHeader(textContent: "Welcome Back"),
              SizedBox(height: 20),
              Form(
                key: loginScreenState.formKey,
                child: Column(
                  children: [
                    ReusableTextFormField(
                      labelText: "Email",
                      validator: (value) => FormValidation.validateEmail(value),
                      controller: loginScreenState.emailController,
                    ),
                    SizedBox(height: 20),
                    ReusableTextFormField(
                      obscureText: true,
                      controller: loginScreenState.passwordController,
                      labelText: 'Password',
                      validator: (value) {
                        return FormValidation.validatePassword(value);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),

              SizedBox(height: 30),
              ReusableButton(
                btnText: "Login",
                formKey: loginScreenState.formKey,
                onValidSubmit: () async {
                  final error = await loginScreenState.loginUser(context);
                  if (error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error)));
                  }
                },
              ),

              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
