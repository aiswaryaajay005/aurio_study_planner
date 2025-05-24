import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Your privacy is important to us. We do not share your data with third parties. Your study plans, usage, and progress remain confidential unless you explicitly grant permission.",
          style: TextStyle(color: ColorConstants.textColor),
        ),
      ),
    );
  }
}
