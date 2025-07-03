import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class DailySummaryController with ChangeNotifier {
  final List<Map<String, dynamic>> todayTasks;
  final Duration timeSpent;

  int xp = 0;
  int coins = 0;
  int tasksDone = 0;
  double hours = 0;
  bool isLoading = true;
  List<double> weeklyMinutes = [];
  Map<String, Map<String, dynamic>> subjectPerformanceSummary = {};
  int currentStreak = 0;
  DailySummaryController({required this.todayTasks, required this.timeSpent});

  Future<void> processRewards(BuildContext context) async {
    log("📢 processRewards CALLED");
    try {
      isLoading = true;
      notifyListeners();

      final userId = SupabaseHelper.getCurrentUserId();
      if (userId == null) return;

      final completedTasks =
          todayTasks.where((task) => task['done'] == true).toList();
      tasksDone = completedTasks.length;

      final totalMinutes = completedTasks.fold<int>(
        0,
        (sum, task) => sum + ((task['duration_minutes'] ?? 0) as int),
      );
      hours = totalMinutes / 60.0;

      final int minutesSpent = timeSpent.inMinutes;
      xp = (minutesSpent * 2).clamp(1, 50);
      coins = (xp / 10).floor();

      await SupabaseHelper.updateUserRewards(
        userId: userId,
        sessionXP: xp,
        sessionCoins: coins,
      );
      final streakData =
          await SupabaseHelper.client
              .from('users')
              .select('current_streak')
              .eq('id', SupabaseHelper.getCurrentUserId() as Object)
              .maybeSingle();

      currentStreak = streakData?['current_streak'] ?? 0;

      notifyListeners();
      if (tasksDone > 0) {
        final streakIncreased =
            await SupabaseHelper.updateStreakAfterTaskCompletion(userId);
        final streakBonusXP = 5;
        final streakBonusCoins = 2;
        xp += streakBonusXP;
        coins += streakBonusCoins;
        if (streakIncreased) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("🔥 Streak continued! Keep it up!"),
              backgroundColor: Colors.deepOrange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
      final result = await SupabaseHelper.processPostSessionSummary(
        userId: userId,
        completedTasks: tasksDone,
        totalTasks: todayTasks.length,
      );

      subjectPerformanceSummary = Map<String, Map<String, dynamic>>.from(
        result['subjectPerformanceSummary'] ?? {},
      );
      weeklyMinutes = List<double>.from(result['weeklyMinutes'] ?? []);

      log("✅ Rewards processed: XP=$xp, Coins=$coins");

      log("🚀 Calling _showSubjectFeedbackDialogs...");
      await _showSubjectFeedbackDialogs(context);
      log("✅ Finished showing all dialogs.");
    } catch (e) {
      log("❌ Error processing rewards: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _showSubjectFeedbackDialogs(BuildContext context) async {
    final userId = SupabaseHelper.getCurrentUserId();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    log("🧪 Feedback Dialog Triggered");

    for (final task in todayTasks.where((t) => t['done'] == true)) {
      int rating = 3;
      log("🔁 Showing dialog for subject: ${task['subject']}");

      await showDialog(
        context: context,
        useRootNavigator: true,
        builder:
            (_) => StatefulBuilder(
              builder:
                  (context, setState) => AlertDialog(
                    title: Text("How was your session in ${task['subject']}?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Too hard, easy, or just right?"),
                        Slider(
                          value: rating.toDouble(),
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: rating.toString(),
                          onChanged: (val) {
                            setState(() => rating = val.toInt());
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final current =
                              await SupabaseHelper.client
                                  .from('user_subject_performance')
                                  .select('score')
                                  .eq('user_id', userId!)
                                  .eq('subject', task['subject'])
                                  .maybeSingle();

                          double newScore;
                          if (current != null) {
                            final oldScore =
                                (current['score'] as num).toDouble();
                            double delta = 0.0;
                            if (rating <= 2)
                              delta = -0.05;
                            else if (rating >= 4)
                              delta = 0.05;
                            newScore = (oldScore + delta).clamp(0.0, 1.0);

                            await SupabaseHelper.client
                                .from('user_subject_performance')
                                .update({
                                  'score': newScore,
                                  'updated_at':
                                      DateTime.now().toIso8601String(),
                                })
                                .eq('user_id', userId)
                                .eq('subject', task['subject']);
                          } else {
                            await SupabaseHelper.client
                                .from('user_subject_performance')
                                .insert({
                                  'user_id': userId,
                                  'subject': task['subject'],
                                  'score': 0.8,
                                });
                          }

                          await SupabaseHelper.client
                              .from('user_feedback')
                              .insert({
                                'user_id': userId,
                                'subject': task['subject'],
                                'rating': rating,
                                'date': today,
                              });

                          Navigator.pop(context);
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
            ),
      );
    }
  }
}
