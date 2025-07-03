import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class StreakController with ChangeNotifier {
  int currentStreak = 0;
  int longestStreak = 0;
  int totalFreezesUsed = 0;
  List<String> freezeDates = [];
  Map<String, String> monthlyStreakLog = {};
  bool isLoading = true;

  Future<void> loadStreakData() async {
    try {
      isLoading = true;
      notifyListeners();

      final userId = SupabaseHelper.getCurrentUserId();
      if (userId == null) return;

      final user =
          await SupabaseHelper.client
              .from('users')
              .select('current_streak, longest_streak, freeze_dates')
              .eq('id', userId)
              .maybeSingle();

      if (user == null) return;

      currentStreak = user['current_streak'] ?? 0;
      longestStreak = user['longest_streak'] ?? 0;
      freezeDates = List<String>.from(user['freeze_dates'] ?? []);
      totalFreezesUsed = freezeDates.length;

      final now = DateTime.now();
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      monthlyStreakLog = {};

      // Step 1: Add current streak days (assumed studied)
      for (int i = 0; i < currentStreak; i++) {
        final date = now.subtract(Duration(days: i));
        final dateStr = date.toIso8601String().substring(0, 10);
        monthlyStreakLog[dateStr] = 'continued';
      }

      // Step 2: Add freeze days
      for (String date in freezeDates) {
        monthlyStreakLog[date] = 'freeze_used';
      }

      // Step 3: (Optional) All other days as "inactive"
      for (int i = 1; i <= daysInMonth; i++) {
        final date = DateTime(now.year, now.month, i);
        final dateStr = date.toIso8601String().substring(0, 10);
        monthlyStreakLog.putIfAbsent(dateStr, () => 'inactive');
      }
    } catch (e) {
      print("❌ Error loading streak data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMonthlyStreakLog() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    final response = await SupabaseHelper.client
        .from('streak_logs')
        .select('date, action')
        .eq('user_id', userId)
        .gte('date', firstDay.toIso8601String())
        .lte('date', lastDay.toIso8601String());

    final Map<String, String> logMap = {};
    for (final log in response) {
      final dateStr = log['date'].toString().substring(0, 10);
      logMap[dateStr] = log['action'];
    }

    monthlyStreakLog = logMap;
  }
}
