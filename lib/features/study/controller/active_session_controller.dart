import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/study/controller/daily_plan_controller.dart';

class ActiveSessionController with ChangeNotifier {
  final Map<String, dynamic> sessionData;
  final DailyPlanController dailyCtrl;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Timer _timer;
  int secondsRemaining = 0;
  bool isSessionCompleted = false;

  ActiveSessionController({
    required this.sessionData,
    required this.dailyCtrl,
  }) {
    secondsRemaining = (sessionData['duration_minutes'] ?? 25) * 60;
  }
  Future<void> _playCompletionSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/session_complete.mp3'));
    } catch (e) {
      print("Audio play error: $e");
    }
  }

  void countdown() {
    if (secondsRemaining > 0) {
      secondsRemaining--;
      notifyListeners();
    } else {
      _playCompletionSound(); // 🔊 Play sound here
      completeSession();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _logSessionToAnalytics() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    final subject = sessionData['subject'] ?? 'Unknown';
    final durationMinutes = timeSpent.inMinutes;
    final now = DateTime.now();

    try {
      await SupabaseHelper.client.from('study_sessions').insert({
        'user_id': userId,
        'subject': subject,
        'duration_minutes': durationMinutes,
        'date': now.toIso8601String(),
      });
    } catch (e) {
      debugPrint('❌ Error logging study session: $e');
    }
  }

  DateTime? _startTime;
  Duration _timeSpent = Duration.zero;

  Duration get timeSpent => _timeSpent;

  void startTimer() {
    _startTime = DateTime.now(); // ✅ Record when the timer started

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      countdown();
    });
  }

  // Future<void> completeSession() async {
  //   _timer.cancel();
  //   isSessionCompleted = true;

  //   final index = dailyCtrl.todayTasks.indexWhere(
  //     (task) =>
  //         task['subject'] == sessionData['subject'] &&
  //         task['duration_minutes'] == sessionData['duration_minutes'],
  //   );

  //   if (index != -1) {
  //     // ✅ Mark the task as done locally
  //     dailyCtrl.markTaskAsDone(index);

  //     // ✅ Update the Supabase record for today's plan
  //     final userId = SupabaseHelper.getCurrentUserId();
  //     final today = DateTime.now().toIso8601String().substring(0, 10);

  //     await SupabaseHelper.client
  //         .from('study_plans')
  //         .update({'plan': dailyCtrl.todayTasks})
  //         .eq('user_id', userId!)
  //         .eq('date', today);
  //   }

  //   notifyListeners();
  // }
  Future<void> _markTaskAsDoneInSupabase() async {
    final index = dailyCtrl.todayTasks.indexWhere(
      (task) =>
          task['subject'] == sessionData['subject'] &&
          task['duration_minutes'] == sessionData['duration_minutes'],
    );

    if (index != -1) {
      dailyCtrl.todayTasks[index]['done'] = true;

      final userId = SupabaseHelper.getCurrentUserId();
      final today = DateTime.now().toIso8601String().substring(0, 10);

      final studyPlan =
          await SupabaseHelper.client
              .from('study_plans')
              .select('adjusted_plan')
              .eq('user_id', userId!)
              .eq('date', today)
              .maybeSingle();

      // If adjusted_plan exists, mark the task as done there too
      if (studyPlan != null && studyPlan['adjusted_plan'] != null) {
        List adjustedPlan = List<Map<String, dynamic>>.from(
          studyPlan['adjusted_plan'],
        );

        final adjustedIndex = adjustedPlan.indexWhere(
          (task) =>
              task['subject'] == sessionData['subject'] &&
              task['duration_minutes'] == sessionData['duration_minutes'],
        );

        if (adjustedIndex != -1) {
          adjustedPlan[adjustedIndex]['done'] = true;
        }

        await SupabaseHelper.client
            .from('study_plans')
            .update({
              'plan': dailyCtrl.todayTasks,
              'adjusted_plan': adjustedPlan,
            })
            .eq('user_id', userId)
            .eq('date', today);
      } else {
        // If no adjusted_plan, only update plan
        await SupabaseHelper.client
            .from('study_plans')
            .update({'plan': dailyCtrl.todayTasks})
            .eq('user_id', userId)
            .eq('date', today);
      }
    }
  }

  void extendSessionByFiveMinutes() {
    secondsRemaining += 300; // 5 minutes = 300 seconds
    notifyListeners();
  }

  String get formattedTimeSpent {
    final effective =
        _startTime != null
            ? _timeSpent + DateTime.now().difference(_startTime!)
            : _timeSpent;

    final mins = effective.inMinutes;
    final secs = effective.inSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  bool isPaused = false;

  Future<void> _applyRewards({required int coins, required int xp}) async {
    final userId = SupabaseHelper.getCurrentUserId();

    final existing =
        await SupabaseHelper.client
            .from('user_rewards')
            .select()
            .eq('user_id', userId!)
            .maybeSingle();

    final newCoins = (existing?['coins'] ?? 0) + coins;

    await SupabaseHelper.client.from('user_rewards').upsert({
      'user_id': userId,
      'coins': newCoins,
    });

    // TODO: Add XP table or logic here if needed
  }

  // Add this to update timeSpent from _startTime till now
  void _updateTimeSpent() {
    if (_startTime != null) {
      final now = DateTime.now();
      _timeSpent += now.difference(_startTime!);
      _startTime = null;
    }
  }

  // Fix pauseOrStop to use _updateTimeSpent
  void pauseOrStop() {
    _timer.cancel();
    _updateTimeSpent();
    isPaused = true;
    notifyListeners();
  }

  void togglePause() {
    if (isPaused) {
      // Resume
      _startTime = DateTime.now();
      startTimer();
    } else {
      _timer.cancel();
      _updateTimeSpent();
    }
    isPaused = !isPaused;
    notifyListeners();
  }

  // Ensure this is called before reward logic
  Future<void> completeSession() async {
    _timer.cancel();
    _updateTimeSpent();

    isSessionCompleted = true;

    final secondsSpent = timeSpent.inSeconds;
    final bool eligible = secondsSpent >= 600;

    final int coins = eligible ? 3 : 1;
    final int xp = eligible ? 10 : 5;

    await _applyRewards(coins: coins, xp: xp);
    await _logSessionToAnalytics();

    await _markTaskAsDoneInSupabase();
    notifyListeners();
  }

  Future<void> stopSession() async {
    _timer.cancel();
    _updateTimeSpent();
    await _logSessionToAnalytics();
    await _applyRewards(coins: 0, xp: 1);
  }

  Future<void> skipSession() async {
    _timer.cancel();
    _updateTimeSpent();
    await _applyRewards(coins: 0, xp: 0);
  }

  void disposeTimer() {
    _timer.cancel();
  }
}
