import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class AdaptiveUpdateController with ChangeNotifier {
  List<String> suggestions = [];
  bool isLoading = true;
  bool isApplying = false;

  Future<void> loadSuggestions() async {
    try {
      isLoading = true;
      notifyListeners();

      suggestions = [
        "Move more time to Science",
        "Reduce History load",
        "Increase focus on Math",
      ];
    } catch (e) {
      print("❌ Error loading suggestions: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applySuggestions() async {
    isApplying = true;
    notifyListeners();

    try {
      final userId = SupabaseHelper.getCurrentUserId();
      if (userId == null) return;

      final user =
          await SupabaseHelper.client
              .from('users')
              .select('subjects')
              .eq('id', userId)
              .maybeSingle();

      List subjects = user?['subjects'] ?? [];

      for (var subject in subjects) {
        if (suggestions.any(
          (s) => s.toLowerCase().contains(subject['subject'].toLowerCase()),
        )) {
          if (suggestions.any(
            (s) =>
                s.toLowerCase().contains("increase") ||
                s.toLowerCase().contains("move more time"),
          )) {
            subject['difficulty'] = 'Hard';
          } else if (suggestions.any(
            (s) => s.toLowerCase().contains("reduce"),
          )) {
            subject['difficulty'] = 'Easy';
          }
        }
      }

      await SupabaseHelper.client
          .from('users')
          .update({'subjects': subjects})
          .eq('id', userId);
    } catch (e) {
      print("❌ Error applying suggestions: $e");
    } finally {
      isApplying = false;
      notifyListeners();
    }
  }
}
