import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/about_us_screen/view/about_us_screen.dart';
import 'package:aurio/features/auth/view/login_screen.dart';
import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:aurio/features/contact_support_screen/view/contact_support_screen.dart';
import 'package:aurio/features/manage_subject_screen/view/manage_subject_screen.dart';
import 'package:aurio/features/privacy_policy_screen/view/privacy_policy_screen.dart';
import 'package:aurio/features/user/view/profile_screen.dart';
import 'package:aurio/view/submit_feedback_screen/submit_feedback_screen.dart';
import 'package:aurio/features/terms_screen/view/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:aurio/features/user/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController()..loadProfileData(),
      child: Consumer<ProfileController>(
        builder: (context, ctrl, _) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                "Settings",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body:
                ctrl.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            backgroundImage:
                                (ctrl.photoUrl != null &&
                                        ctrl.photoUrl!.isNotEmpty)
                                    ? NetworkImage(ctrl.photoUrl!)
                                    : null,
                            child:
                                (ctrl.photoUrl == null ||
                                        ctrl.photoUrl!.isEmpty)
                                    ? Text(
                                      SupabaseHelper.getInitials(ctrl.name),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          leading: Icon(
                            Icons.person_outline,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          title: Text(
                            "My Profile",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            "Manage Subjects",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageSubjectsScreen(),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivacyPolicyScreen(),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            "Terms and Conditions",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TermsScreen(),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            "Contact Support",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactSupportScreen(),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            "Send Feedback",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubmitFeedbackScreen(),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          tileColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            "About Us",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutUsScreen(),
                              ),
                            );
                          },
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await SupabaseHelper.client.auth.signOut();
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text("Logout"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
          );
        },
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
