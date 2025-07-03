import 'package:aurio/core/services/supabase_helper.dart';
import 'package:flutter/material.dart';
import 'package:aurio/features/user/view/edit_profile_screen.dart';
import 'package:aurio/features/user/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController()..loadProfileData(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ProfileController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "My Profile",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage:
                          ctrl.photoUrl != null && ctrl.photoUrl!.isNotEmpty
                              ? NetworkImage(ctrl.photoUrl!)
                              : null,
                      child:
                          (ctrl.photoUrl == null || ctrl.photoUrl!.isEmpty)
                              ? Text(
                                SupabaseHelper.getInitials(ctrl.name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ctrl.name,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ctrl.email,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.school_outlined),
                      title: Text(ctrl.grade),
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_fire_department_outlined),
                      title: Text("${ctrl.streak} Day Streak!"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text(ctrl.joinDate),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
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
