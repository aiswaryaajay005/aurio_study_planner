import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class ProfileController with ChangeNotifier {
  String name = '';
  String email = '';
  String grade = '';
  String joinDate = '';
  int streak = 0;
  bool isLoading = true;
  String? photoUrl = "";

  Future<void> loadProfileData() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    try {
      isLoading = true;
      notifyListeners();

      final data =
          await SupabaseHelper.client
              .from('users')
              .select(
                'full_name, email, grade, created_at, current_streak,user_photo',
              )
              .eq('id', userId)
              .single();

      name = data['full_name'] ?? 'No Name';
      email = data['email'] ?? 'No Email';
      grade = data['grade'] ?? '';
      streak = data['current_streak'] ?? 0;
      photoUrl = data['user_photo'] ?? '';

      final date = DateTime.tryParse(data['created_at'] ?? '');
      if (date != null) {
        joinDate = "Joined: ${_formatDate(date)}";
      } else {
        joinDate = "Joined: Unknown";
      }
    } catch (e) {
      print("❌ Error loading profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
