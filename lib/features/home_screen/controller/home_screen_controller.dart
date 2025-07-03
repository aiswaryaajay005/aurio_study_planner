// --- HomeScreenController.dart (Updated) ---

import 'dart:developer';
import 'package:aurio/core/services/notification_scheduler.dart';
import 'package:aurio/features/schedule/model/daily_schedule_generator.dart';
import 'package:aurio/view/notifications_screen/view_model/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class HomeScreenController with ChangeNotifier {
  List<Map<String, dynamic>> todaySchedule = [];
  bool isLoading = true;

  List<String> carouselList = [
    "Break big tasks into smaller steps.",
    "Revise before sleeping for better memory retention.",
    "Use the Pomodoro technique for focused sessions.",
    "Teach others to understand better.",
    "Keep your phone away while studying.",
    "Use active recall instead of passive reading.",
    "Make concept maps to connect ideas.",
    "Visualize tough concepts.",
    "Quiz yourself after every topic.",
    "Mix different subjects in your day.",
  ];
  Future<void> fetchStreak() async {
    final userId = SupabaseHelper.getCurrentUserId();
    final user =
        await SupabaseHelper.client
            .from('users')
            .select('current_streak')
            .eq('id', userId!)
            .maybeSingle();

    var streakDays = user?['current_streak'] ?? 0;
    notifyListeners();
  }

  Future<void> loadSchedule() async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = SupabaseHelper.getCurrentUserId();
      if (userId == null) return;

      final today = DateTime.now();
      final todayStr = today.toIso8601String().substring(0, 10);

      final user =
          await SupabaseHelper.client
              .from('users')
              .select('subjects, daily_hours')
              .eq('id', userId)
              .single();

      final List subjects = user['subjects'] ?? [];
      final int hours = user['daily_hours'] ?? 0;
      final currentSubjectsKey = _generateSubjectsKey(
        List<Map<String, dynamic>>.from(subjects),
      );

      final existing =
          await SupabaseHelper.client
              .from('study_plans')
              .select('plan, created_at, subjects_key')
              .eq('user_id', userId)
              .eq('date', todayStr)
              .maybeSingle();

      bool generateNew = false;

      if (existing != null && existing['plan'] != null) {
        final createdAt = DateTime.parse(existing['created_at']);
        final durationSinceCreated = today.difference(createdAt);
        final String? oldKey = existing['subjects_key'];

        if (durationSinceCreated.inHours >= 24 ||
            oldKey != currentSubjectsKey) {
          generateNew = true;
        } else {
          todaySchedule = List<Map<String, dynamic>>.from(existing['plan']);
        }
      } else {
        generateNew = true;
      }

      if (generateNew) {
        todaySchedule = await generateDailySchedule(
          subjects: List<Map<String, dynamic>>.from(subjects),
          dailyHours: hours,
          shuffle: true,
          useAI: true,
          performanceScores: await _fetchPerformanceScores(userId),
        );

        await SupabaseHelper.client.from('study_plans').insert({
          'user_id': userId,
          'date': todayStr,
          'plan': todaySchedule,
          'subjects_key': currentSubjectsKey,
        });
      }
      log("fetching streak.........");
      await fetchStreak();
      log("fetching streak.........");
      notifyListeners();
    } catch (e) {
      log("🔥 Schedule loading error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _generateSubjectsKey(List<Map<String, dynamic>> subjects) {
    final sorted = [...subjects]..sort(
      (a, b) => (a['subject'] as String).compareTo(b['subject'] as String),
    );
    return sorted.map((s) => '${s['subject']}_${s['difficulty']}').join(',');
  }

  Future<Map<String, double>> _fetchPerformanceScores(String userId) async {
    try {
      final response = await SupabaseHelper.client
          .from('user_subject_performance')
          .select('subject, score')
          .eq('user_id', userId);

      if (response == null || response.isEmpty) return {};

      return {
        for (var row in response)
          row['subject']: (row['score'] as num).toDouble().clamp(0.0, 1.0),
      };
    } catch (e) {
      log("⚠️ Error fetching performance scores: $e");
      return {};
    }
  }
}
