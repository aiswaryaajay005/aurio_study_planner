import 'package:aurio/controller/signup_screen_controller.dart';
import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/global_widgets/reuable_header.dart';
import 'package:aurio/global_widgets/reusable_button.dart';
import 'package:aurio/global_widgets/reusable_text_form_field.dart';
import 'package:aurio/utils/form_validation.dart';
import 'package:aurio/view/login_screen/login_screen.dart';
import 'package:aurio/view/profile_set_up_screen/profile_set_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final signupState = context.watch<SignupScreenController>();
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: signupState.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                ReusableHeader(textContent: "Start Your Journey"),
                const SizedBox(height: 20),
                Text(
                  "Let's craft your perfect plan",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorConstants.accentColor,
                  ),
                ),
                const SizedBox(height: 40),

                ReusableTextFormField(
                  labelText: "Full Name",
                  controller: signupState.nameController,
                  validator: (value) => FormValidation.validateValue(value),
                ),
                const SizedBox(height: 20),
                ReusableTextFormField(
                  labelText: "Email",
                  controller: signupState.emailController,
                  validator: (value) => FormValidation.validateEmail(value),
                ),
                const SizedBox(height: 20),
                ReusableTextFormField(
                  labelText: "Grade Level (eg. 10th)",
                  controller: signupState.gradeController,
                  validator: (value) => FormValidation.validateValue(value),
                ),
                const SizedBox(height: 20),
                ReusableTextFormField(
                  labelText: "Password",
                  suffixIcon: Icon(Icons.visibility),
                  controller: signupState.passwordController,
                  validator: (value) => FormValidation.validatePassword(value),
                ),
                SizedBox(height: 20),
                ReusableTextFormField(
                  labelText: "Confirm Password",
                  suffixIcon: Icon(Icons.visibility),
                  controller: signupState.confirmPasswordController,
                  // validator:
                  //     (value) => FormValidation.validateConfirmPassword(
                  //       value,
                  //       signupState.passwordController.text,
                  //     ),
                ),
                CheckboxListTile(
                  value: signupState.isChecked,
                  onChanged: (value) {
                    setState(() {
                      signupState.isChecked = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("I agree to Terms & Conditions"),
                ),
                const SizedBox(height: 20),
                ReusableButton(
                  btnText: "Sign Up",
                  formKey: signupState.formKey,
                  onValidSubmit: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSetUpScreen(),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(
                      color: ColorConstants.textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
