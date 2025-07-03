import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class DailyPlanController with ChangeNotifier {
  List<Map<String, dynamic>> todayTasks = [];
  bool isLoading = true;

  Future<void> loadPlanForToday() async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = SupabaseHelper.getCurrentUserId();
      final today = DateTime.now().toIso8601String().substring(0, 10);

      final response =
          await SupabaseHelper.client
              .from('study_plans')
              .select('plan, adjusted_plan')
              .eq('user_id', userId!)
              .eq('date', today)
              .maybeSingle();

      if (response != null) {
        if (response['adjusted_plan'] != null) {
          todayTasks = List<Map<String, dynamic>>.from(
            response['adjusted_plan'],
          );
        } else {
          todayTasks = List<Map<String, dynamic>>.from(response['plan']);
        }
      } else {
        todayTasks = [];
      }
    } catch (e) {
      print("Error loading plan: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getTodayFeedback() async {
    final userId = SupabaseHelper.getCurrentUserId();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final response =
        await SupabaseHelper.client
            .from('user_feedback')
            .select()
            .eq('user_id', userId!)
            .eq('date', today)
            .maybeSingle();

    return response;
  }

  Future<bool> isFeedbackGivenForToday() async {
    final userId = SupabaseHelper.getCurrentUserId();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final response =
        await SupabaseHelper.client
            .from('user_feedback')
            .select()
            .eq('user_id', userId!)
            .eq('date', today)
            .maybeSingle();

    return response != null;
  }

  bool areAllTasksDone() {
    return todayTasks.isNotEmpty &&
        todayTasks.every((task) => task['done'] == true);
  }

  void toggleTask(int index) {
    if (index >= 0 && index < todayTasks.length) {
      final currentTask = todayTasks[index];
      todayTasks[index] = {
        ...currentTask,
        'done': !(currentTask['done'] ?? false),
      };
      notifyListeners();
    }
  }

  void markTaskAsDone(int index) {
    if (index >= 0 && index < todayTasks.length) {
      todayTasks[index]['done'] = true;
      notifyListeners();
    }
  }

  Map<String, dynamic>? getNextPendingTask() {
    try {
      return todayTasks.firstWhere((task) => !(task['done'] ?? false));
    } catch (_) {
      return null;
    }
  }
}
