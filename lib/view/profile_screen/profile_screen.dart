import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/edit_profile_screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy User Data (later load from Supabase or Provider)
    final String name = "Miya James";
    final String email = "miyajames@gmail.com";
    final String grade = "12th Grade";
    final String joinDate = "Joined: April 2025";
    final int streak = 7;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: ColorConstants.primaryColor,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // User Info
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                color: ColorConstants.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(email, style: TextStyle(color: ColorConstants.TextColor)),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: Text(grade),
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department_outlined),
              title: Text("$streak Day Streak!"),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(joinDate),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
