import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Terms of Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "By using this app, you agree to study hard, stay consistent, and treat yourself with kindness. The app is designed for educational purposes only and does not replace professional academic counseling.",
          style: TextStyle(color: ColorConstants.textColor),
        ),
      ),
    );
  }
}
