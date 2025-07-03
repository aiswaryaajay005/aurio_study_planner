import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class AnalyticsController with ChangeNotifier {
  List<double> dailyStudyMinutes = [];
  bool isLoading = true;
  String selectedMonth = "${DateTime.now().month}".padLeft(2, '0');
  String selectedViewMode = "Weekly";
  DateTime weekStartDate = DateTime.now();
  List<double> weeklyStudyMinutes = [];
  List<double> monthlyStudyMinutes = [];
  List<double> overallStudyMinutes = [];

  AnalyticsController() {
    log(
      "🟢 AnalyticsController initialized with viewMode: $selectedViewMode, selectedMonth: $selectedMonth",
    );
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    log("🔍 Starting loadAnalytics for viewMode: $selectedViewMode");
    isLoading = true;
    notifyListeners();

    try {
      switch (selectedViewMode) {
        case 'Weekly':
          await fetchWeeklyStudyMinutes();
          break;
        case 'Monthly':
          await fetchMonthlyStudyByWeek();
          break;
        case 'Overall':
          await fetchOverallStudyByWeek();
          break;
      }
      log(
        "🟢 Successfully loaded analytics for $selectedViewMode view. Daily study minutes: $dailyStudyMinutes",
      );
    } catch (e) {
      log("🔴 Error loading analytics for $selectedViewMode view: $e");
    }

    isLoading = false;
    notifyListeners();
    log("🔍 Finished loadAnalytics for viewMode: $selectedViewMode");
  }

  void setMonth(String month) {
    log("🔍 Setting month to $month from $selectedMonth");
    selectedMonth = month;
    loadAnalytics();
  }

  Future<void> fetchWeeklyStudyMinutes() async {
    final userId = SupabaseHelper.client.auth.currentUser?.id;
    if (userId == null) {
      log("🔴 No user ID found, aborting fetchWeeklyStudyMinutes");
      return;
    }
    log("🔍 Fetching weekly study minutes for userId: $userId");

    final now = DateTime.now();
    final weekday = now.weekday;
    final startDate = now.subtract(Duration(days: weekday - 1));
    weekStartDate = startDate;
    log(
      "🔍 Week start date: ${startDate.toIso8601String()}, end date: ${startDate.add(const Duration(days: 6)).toIso8601String()}",
    );

    List<double> minutes = List.filled(7, 0.0);

    try {
      final sessions = await SupabaseHelper.client
          .from('study_sessions')
          .select('duration_minutes, date')
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String())
          .lte(
            'date',
            startDate.add(const Duration(days: 6)).toIso8601String(),
          );

      log("🔍 Retrieved ${sessions.length} sessions for weekly view");

      for (final session in sessions) {
        final date = DateTime.parse(session['date']);
        final index = date.difference(startDate).inDays;
        if (index >= 0 && index < 7) {
          final duration = (session['duration_minutes'] ?? 0).toDouble();
          minutes[index] += duration;
          log(
            "🔍 Adding $duration minutes to day $index (${date.day}/${date.month})",
          );
        }
      }
    } catch (e) {
      log("🔴 Error fetching weekly study minutes: $e");
    }

    dailyStudyMinutes = minutes;
    log("🟢 Weekly study minutes calculated: $dailyStudyMinutes");
  }

  Future<void> fetchMonthlyStudyByWeek() async {
    final userId = SupabaseHelper.client.auth.currentUser?.id;
    if (userId == null) {
      log("🔴 No user ID found, aborting fetchMonthlyStudyByWeek");
      return;
    }
    log(
      "🔍 Fetching monthly study minutes for userId: $userId, month: $selectedMonth",
    );

    final year = DateTime.now().year;
    final month = int.tryParse(selectedMonth) ?? DateTime.now().month;
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    final totalDays = endDate.day;
    final weeks = (totalDays / 7).ceil();
    List<double> weekTotals = List.filled(weeks, 0.0);
    log(
      "🔍 Month start date: ${startDate.toIso8601String()}, end date: ${endDate.toIso8601String()}, total weeks: $weeks",
    );

    try {
      final sessions = await SupabaseHelper.client
          .from('study_sessions')
          .select('duration_minutes, date')
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String());

      log("🔍 Retrieved ${sessions.length} sessions for monthly view");

      for (final session in sessions) {
        final date = DateTime.parse(session['date']);
        if (date.month != month || date.year != year) {
          log(
            "🔍 Skipping session outside selected month: ${date.toIso8601String()}",
          );
          continue;
        }
        final weekIndex = ((date.day - 1) / 7).floor();
        if (weekIndex >= 0 && weekIndex < weeks) {
          final duration = (session['duration_minutes'] ?? 0).toDouble();
          weekTotals[weekIndex] += duration;
          log(
            "🔍 Adding $duration minutes to week $weekIndex for date ${date.day}/${date.month}",
          );
        }
      }
    } catch (e) {
      log("🔴 Error fetching monthly study minutes: $e");
    }

    dailyStudyMinutes = weekTotals;
    log("🟢 Monthly study minutes by week calculated: $dailyStudyMinutes");
  }

  Future<void> fetchOverallStudyByWeek() async {
    final userId = SupabaseHelper.client.auth.currentUser?.id;
    if (userId == null) {
      log("🔴 No user ID found, aborting fetchOverallStudyByWeek");
      return;
    }
    log("🔍 Fetching overall study minutes for userId: $userId");

    try {
      final sessions = await SupabaseHelper.client
          .from('study_sessions')
          .select('duration_minutes, date')
          .eq('user_id', userId)
          .order('date');

      if (sessions.isEmpty) {
        log("🔍 No sessions found for overall view");
        dailyStudyMinutes = [];
        return;
      }

      log("🔍 Retrieved ${sessions.length} sessions for overall view");

      final firstDate = DateTime.parse(sessions.first['date']);
      final now = DateTime.now();
      final totalWeeks = (now.difference(firstDate).inDays / 7).ceil();
      List<double> weekly = List.filled(totalWeeks, 0.0);
      log(
        "🔍 Total weeks: $totalWeeks, from ${firstDate.toIso8601String()} to ${now.toIso8601String()}",
      );

      for (final session in sessions) {
        final date = DateTime.parse(session['date']);
        final weekIndex = (date.difference(firstDate).inDays / 7).floor();
        if (weekIndex >= 0 && weekIndex < totalWeeks) {
          final duration = (session['duration_minutes'] ?? 0).toDouble();
          weekly[weekIndex] += duration;
          log(
            "🔍 Adding $duration minutes to week $weekIndex for date ${date.day}/${date.month}/${date.year}",
          );
        }
      }

      dailyStudyMinutes = weekly;
      log("🟢 Overall study minutes by week calculated: $dailyStudyMinutes");
    } catch (e) {
      log("🔴 Error fetching overall study minutes: $e");
    }
  }

  num getTotalMinutes(String mode) {
    switch (mode) {
      case 'Weekly':
        return dailyStudyMinutes.fold(0, (sum, m) => sum + m);
      case 'Monthly':
        return monthlyStudyMinutes.fold(0, (sum, m) => sum + m);
      case 'Overall':
        return overallStudyMinutes.fold(0, (sum, m) => sum + m);
      default:
        return 0;
    }
  }
}
