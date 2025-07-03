import 'package:aurio/main.dart';
import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class TaskController with ChangeNotifier {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  Future<void> fetchTasks() async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = SupabaseHelper.getCurrentUserId();
      final data = await SupabaseHelper.client
          .from('tasks')
          .select()
          .eq('user_id', userId!)
          .order('due_date', ascending: true);

      tasks = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("❌ Error fetching tasks: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    String priority = "medium", // Must be 'low', 'medium', or 'high'
  }) async {
    try {
      final userId = SupabaseHelper.getCurrentUserId();

      final newTask = {
        'user_id': userId,
        'title': title,
        'description': description,
        'due_date': dueDate?.toIso8601String(),
        'priority': priority,
        'is_completed': false,
      };

      await SupabaseHelper.client.from('tasks').insert(newTask);
      await fetchTasks();
    } catch (e) {
      print("❌ Error adding task: $e");
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await SupabaseHelper.client.from('tasks').delete().eq('id', taskId);
      await fetchTasks();
    } catch (e) {
      print("❌ Error deleting task: $e");
    }
  }

  Future<void> toggleCompletion(int taskId, bool isDone) async {
    try {
      await SupabaseHelper.client
          .from('tasks')
          .update({'is_completed': isDone})
          .eq('id', taskId);

      if (isDone) {
        final userId = SupabaseHelper.getCurrentUserId();
        final existing =
            await SupabaseHelper.client
                .from('user_rewards')
                .select('coins')
                .eq('user_id', userId!)
                .maybeSingle();

        final int rewardCoins = 2;
        final int newCoins = (existing?['coins'] ?? 0) + rewardCoins;

        // ✅ Update user_rewards
        await SupabaseHelper.client.from('user_rewards').upsert({
          'user_id': userId,
          'coins': newCoins,
        });

        // ✅ Insert into reward_history
        await SupabaseHelper.client.from('reward_history').insert({
          'user_id': userId,
          'source': 'Task Completion',
          'reward_type': 'coins',
          'amount': rewardCoins,
        });

        // ✅ Show reward dialog
        _showRewardDialog(rewardCoins);
      }

      await fetchTasks();
    } catch (e) {
      print("❌ Error toggling completion: $e");
    }
  }

  void _showRewardDialog(int coins) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("🎉 Task Completed!"),
          content: Text("You've earned 💰 $coins coins for completing a task!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Awesome!"),
            ),
          ],
        );
      },
    );
  }
}
