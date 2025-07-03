import 'package:aurio/features/auth/controller/signup_screen_controller.dart'
    show SignupScreenController;
import 'package:aurio/shared/widgets/reuable_header.dart';
import 'package:aurio/shared/widgets/reusable_button.dart';
import 'package:aurio/shared/widgets/reusable_text_form_field.dart';
import 'package:aurio/core/utils/form_validation.dart';
import 'package:aurio/features/auth/view/login_screen.dart';
import 'package:aurio/features/profile_setup/view/profile_set_up_screen.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    color: Theme.of(context).colorScheme.secondary,
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
                  onValidSubmit: () async {
                    final error = await signupState.signupUser();
                    if (error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error)));
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSetUpScreen(),
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
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
