import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/contact_support_screen/contact_support_screen.dart';
import 'package:aurio/view/manage_subject_screen/manage_subject_screen.dart';
import 'package:aurio/view/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:aurio/view/terms_screen/terms_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.white),
          const SizedBox(height: 20),
          ListTile(
            title: const Text("Manage Subjects"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageSubjectsScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Terms and Conditions"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Contact Support"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactSupportScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
