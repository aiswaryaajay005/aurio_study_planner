import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class AdjustedScheduleController with ChangeNotifier {
  List<Map<String, dynamic>> adjustedPlan = [];
  bool isSaving = false;

  void loadPlan(List<Map<String, dynamic>> plan) {
    adjustedPlan = List<Map<String, dynamic>>.from(plan);
    notifyListeners();
  }

  void updateDuration(int index, int newDuration) {
    adjustedPlan[index]['duration_minutes'] = newDuration;
    notifyListeners();
  }

  Future<void> saveAdjustedPlan() async {
    isSaving = true;
    notifyListeners();

    try {
      final userId = SupabaseHelper.getCurrentUserId();
      final today = DateTime.now().toIso8601String().substring(0, 10);

      await SupabaseHelper.client
          .from('study_plans')
          .update({'adjusted_plan': adjustedPlan})
          .eq('user_id', userId!)
          .eq('date', today);
    } catch (e) {
      print("❌ Error saving adjusted plan: $e");
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  void revertToOriginal(List<Map<String, dynamic>> originalPlan) {
    adjustedPlan = List<Map<String, dynamic>>.from(originalPlan);
    notifyListeners();
  }
}
