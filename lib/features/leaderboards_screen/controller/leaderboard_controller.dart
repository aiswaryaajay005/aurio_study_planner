import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardController with ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  List<Map<String, dynamic>> leaderboard = [];

  Future<void> loadLeaderboard() async {
    try {
      isLoading = true;
      notifyListeners();

      final realUsers = await _getRealUsers();
      log("✅ Real users fetched: ${realUsers.length}");

      final dummyUsers = [
        {
          "id": "dummy_1",
          "full_name": "Ava",
          "total_xp": 980,
          "weekly_xp": 85,
          "badge": _getBadge(85),
          "isReal": false,
        },
        {
          "id": "dummy_2",
          "full_name": "Leo",
          "total_xp": 750,
          "weekly_xp": 60,
          "badge": _getBadge(60),
          "isReal": false,
        },
        {
          "id": "dummy_3",
          "full_name": "Zara",
          "total_xp": 600,
          "weekly_xp": 45,
          "badge": _getBadge(45),
          "isReal": false,
        },
        {
          "id": "dummy_4",
          "full_name": "Kian",
          "total_xp": 400,
          "weekly_xp": 25,
          "badge": _getBadge(25),
          "isReal": false,
        },
      ];

      leaderboard = [...realUsers, ...dummyUsers];
      leaderboard.sort(
        (a, b) => (b['weekly_xp'] as int).compareTo(a['weekly_xp'] as int),
      );

      isLoading = false;
      notifyListeners();
    } catch (e, stack) {
      isLoading = false;
      notifyListeners();
      log("❌ Error loading leaderboard: $e", stackTrace: stack);
    }
  }

  Future<List<Map<String, dynamic>>> _getRealUsers() async {
    final response = await supabase
        .from('user_rewards')
        .select('user_id, total_xp');

    log("📦 Raw user_rewards: $response");

    List<Map<String, dynamic>> real = [];

    for (final row in response) {
      log("🔁 Looping user: ${row['user_id']}");
      final userId = row['user_id'];

      if (userId == null) {
        log("⚠️ Skipping null user_id");
        continue;
      }

      final user =
          await supabase
              .from('users')
              .select('full_name')
              .eq('id', userId)
              .maybeSingle();

      log("🧾 User fetched from users table: $user");

      final name =
          user != null ? user['full_name'] ?? "Student" : "Unknown User";
      final weeklyXp = await _getWeeklyXP(userId);

      log("👤 $name - Weekly XP: $weeklyXp | Total XP: ${row['total_xp']}");

      real.add({
        "id": userId,
        "full_name": name,
        "total_xp": row['total_xp'] ?? 0,
        "weekly_xp": weeklyXp,
        "badge": _getBadge(weeklyXp),
        "isReal": true,
      });
    }

    log("✅ Real users fetched: ${real.length}");
    return real;
  }

  Future<int> _getWeeklyXP(String userId) async {
    final now = DateTime.now();
    final lastSunday = now.subtract(Duration(days: now.weekday % 7));
    final startOfWeek = DateTime(
      lastSunday.year,
      lastSunday.month,
      lastSunday.day,
    );

    final rewards = await supabase
        .from('reward_history')
        .select('amount')
        .eq('user_id', userId)
        .eq('reward_type', 'xp')
        .gte('created_at', startOfWeek.toIso8601String());

    int weeklyXp = 0;
    for (final reward in rewards) {
      final amount = reward['amount'];
      if (amount is int) {
        weeklyXp += amount;
      }
    }
    return weeklyXp;
  }

  String _getBadge(int xp) {
    if (xp >= 50) return "🥇 Gold";
    if (xp >= 30) return "🥈 Silver";
    if (xp >= 10) return "🥉 Bronze";
    return "";
  }
}
