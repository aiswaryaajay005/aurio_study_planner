import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/contact_support_screen/contact_support_screen.dart';
import 'package:aurio/view/manage_subject_screen/manage_subject_screen.dart';
import 'package:aurio/view/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:aurio/view/profile_screen/profile_screen.dart';
import 'package:aurio/view/submit_feedback_screen/submit_feedback_screen.dart';
import 'package:aurio/view/terms_screen/terms_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,

      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Text(
          "Settings",
          style: TextStyle(color: ColorConstants.textColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showLogoutDialog(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(radius: 40, backgroundColor: ColorConstants.accentColor),
          const SizedBox(height: 20),
          ListTile(
            tileColor: ColorConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            leading: Icon(
              Icons.person_outline,
              color: ColorConstants.textColor,
            ),
            title: Text(
              "My Profile",
              style: TextStyle(color: ColorConstants.accentColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),

          const SizedBox(height: 20),
          ListTile(
            tileColor: ColorConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Manage Subjects",
              style: TextStyle(color: ColorConstants.accentColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageSubjectsScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: ColorConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Privacy Policy",
              style: TextStyle(color: ColorConstants.accentColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: ColorConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Terms and Conditions",
              style: TextStyle(color: ColorConstants.accentColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: ColorConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Contact Support",
              style: TextStyle(color: ColorConstants.accentColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactSupportScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: ColorConstants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              "Send Feedback",
              style: TextStyle(color: ColorConstants.accentColor),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubmitFeedbackScreen()),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
                // TODO: Add Supabase signout if backend connected
              },
            ),
          ],
        );
      },
    );
  }
}
