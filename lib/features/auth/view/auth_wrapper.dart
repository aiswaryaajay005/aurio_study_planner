import 'package:aurio/features/bottom_navbar/view/bottom_navbar.dart';
import 'package:aurio/features/auth/view/login_screen.dart';
import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/profile_setup/view/profile_set_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Widget> _determineStartScreen() async {
    final session = Supabase.instance.client.auth.currentSession;
    final user = session?.user;

    if (user == null) {
      return const LoginScreen();
    }

    try {
      final profile =
          await SupabaseHelper.client
              .from('users')
              .select('profile_completed')
              .eq('id', user.id)
              .single();

      final bool complete = profile['profile_completed'] == true;
      return complete ? const BottomNavbar() : const ProfileSetUpScreen();
    } catch (e) {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
