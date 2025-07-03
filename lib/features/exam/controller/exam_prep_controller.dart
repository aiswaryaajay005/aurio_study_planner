import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class ExamPrepController with ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  Future<void> loadTasks(int examPlanId) async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = SupabaseHelper.getCurrentUserId();

      final data = await SupabaseHelper.client
          .from('exam_tasks')
          .select()
          .eq('user_id', userId!)
          .eq('exam_plan_id', examPlanId);

      tasks = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("❌ Error loading exam tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTask(int taskId, bool newStatus) async {
    try {
      await SupabaseHelper.client
          .from('exam_tasks')
          .update({'is_completed': newStatus})
          .eq('id', taskId);
      notifyListeners();
    } catch (e) {
      print("❌ Error toggling task: $e");
    }
  }

  Future<void> addTask({
    required int examPlanId,
    required String title,
    String? notes,
  }) async {
    final userId = SupabaseHelper.getCurrentUserId();
    try {
      await SupabaseHelper.client.from('exam_tasks').insert({
        'user_id': userId,
        'exam_plan_id': examPlanId,
        'title': title,
        'notes': notes,
        'is_completed': false,
      });
      await loadTasks(examPlanId);
    } catch (e) {
      print("❌ Error adding task: $e");
    }
  }

  Future<void> editTask(int taskId, String title, String? notes) async {
    try {
      await SupabaseHelper.client
          .from('exam_tasks')
          .update({'title': title, 'notes': notes})
          .eq('id', taskId);
      notifyListeners();
    } catch (e) {
      print("❌ Error editing task: $e");
    }
  }
}
