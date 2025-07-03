import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class ProfileSetupController with ChangeNotifier {
  final subjectController = TextEditingController();
  final List<Map<String, String>> subjects = [];

  String? selectedDifficulty;
  double dailyHours = 0;

  void addSubject(String subject, String difficulty) {
    subjects.add({"subject": subject, "difficulty": difficulty});
    notifyListeners();
  }

  void updateHours(double value) {
    dailyHours = value;
    notifyListeners();
  }

  Future<String?> saveToSupabase() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return "User not logged in.";

    try {
      await SupabaseHelper.client
          .from('users')
          .update({
            "subjects": subjects,
            "difficulty": selectedDifficulty,
            "daily_hours": dailyHours.toInt(),
            "profile_completed": true,
          })
          .eq('id', userId);

      return null;
    } catch (e) {
      print("Save Error: $e");
      return "Failed to save preferences.";
    }
  }

  void removeSubject(int index) {
    subjects.removeAt(index);
    notifyListeners();
  }

  void disposeAll() {
    subjectController.dispose();
  }
}
