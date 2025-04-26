import 'package:aurio/controller/login_screen_scontroller.dart';
import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/global_widgets/reuable_header.dart';
import 'package:aurio/global_widgets/reusable_button.dart';
import 'package:aurio/global_widgets/reusable_text_form_field.dart';
import 'package:aurio/utils/form_validation.dart';
import 'package:aurio/view/signup_screen/signup_screen.dart';
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
      backgroundColor: ColorConstants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            ReusableButton(btnText: "Login", formKey: loginScreenState.formKey),
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
                style: TextStyle(color: ColorConstants.TextColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
