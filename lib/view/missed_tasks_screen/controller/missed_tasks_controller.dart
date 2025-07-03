import 'package:aurio/core/services/supabase_helper.dart';
import 'package:flutter/cupertino.dart';

class MissedTasksController with ChangeNotifier {
  List<Map<String, dynamic>> missedTasks = [];
  bool isLoading = true;
  Future<void> loadMissedTasks() async {
    final userId = SupabaseHelper.client.auth.currentUser?.id;
    if (userId == null) return;

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final date = "${yesterday.toIso8601String().substring(0, 10)}";

    final result =
        await SupabaseHelper.client
            .from('study_plans')
            .select('plan')
            .eq('user_id', userId)
            .eq('date', date)
            .maybeSingle();

    if (result != null && result['plan'] != null) {
      List<dynamic> plan = result['plan'];

      final missed =
          plan
              .where(
                (task) => task is Map<String, dynamic> && task['done'] != true,
              )
              .map(
                (task) => {
                  'subject': task['subject'],
                  'task': task['task'] ?? '',
                },
              )
              .toList();
      missedTasks = missed;
      isLoading = false;
      notifyListeners();
    } else {
      missedTasks = [];
      isLoading = false;
      notifyListeners();
    }
  }
}
