import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelper {
  static final SupabaseClient _client = Supabase.instance.client;
  static SupabaseClient get client => _client;

  static Future<AuthResponse?> signUp(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception("Email and password cannot be empty.");
    }

    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );
      return response;
    } catch (e) {
      print("Sign Up Error: $e");
      throw Exception("Signup failed");
    }
  }

  static Future<void> insertUserProfile({
    required String userId,
    required String name,
    required String email,
    required String grade,
  }) async {
    try {
      await _client.from('users').insert({
        'id': userId,
        'full_name': name,
        'email': email,
        'grade': grade,
      });
    } catch (e) {
      print("Insert User Profile Error: $e");
      throw Exception("User profile saving failed");
    }
  }

  static Future<AuthResponse?> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print("Login Error: $e");
      throw Exception("Login failed");
    }
  }

  static Future<void> updateUserRewards({
    required String userId,
    required int sessionXP,
    required int sessionCoins,
  }) async {
    final existing =
        await client
            .from('user_rewards')
            .select('total_xp, total_coins')
            .eq('user_id', userId)
            .maybeSingle();

    final now = DateTime.now().toIso8601String();

    if (existing != null) {
      final updatedXP = (existing['total_xp'] ?? 0) + sessionXP;
      final updatedCoins = (existing['total_coins'] ?? 0) + sessionCoins;

      await client
          .from('user_rewards')
          .update({
            'total_xp': updatedXP,
            'total_coins': updatedCoins,
            'updated_at': now,
          })
          .eq('user_id', userId);
    } else {
      await client.from('user_rewards').insert({
        'user_id': userId,
        'total_xp': sessionXP,
        'total_coins': sessionCoins,
        'updated_at': now,
      });
    }

    final List<Map<String, dynamic>> historyEntries = [];

    if (sessionXP > 0) {
      historyEntries.add({
        'user_id': userId,
        'source': 'Session',
        'reward_type': 'xp',
        'amount': sessionXP,
        'created_at': now,
      });
    }

    if (sessionCoins > 0) {
      historyEntries.add({
        'user_id': userId,
        'source': 'Session',
        'reward_type': 'coins',
        'amount': sessionCoins,
        'created_at': now,
      });
    }

    if (historyEntries.isNotEmpty) {
      await client.from('reward_history').insert(historyEntries);
    }
  }

  static Future<Map<String, dynamic>> processPostSessionSummary({
    required String userId,
    required int completedTasks,
    required int totalTasks,
  }) async {
    final today = DateTime.now();
    final todayStr = today.toIso8601String().substring(0, 10);

    final performanceResults = await client
        .from('user_subject_performance')
        .select()
        .eq('user_id', userId)
        .eq('date', todayStr);

    final Map<String, Map<String, dynamic>> subjectPerformance = {};
    for (final item in performanceResults) {
      final subject = item['subject'];
      subjectPerformance[subject] = {
        'status': item['status'],
        'score': item['score'],
      };
    }

    List<double> weeklyMinutes = [];
    try {
      final weekData = await client.rpc(
        'get_weekly_minutes',
        params: {'user_id': userId},
      );
      weeklyMinutes = List<double>.from(weekData ?? []);
    } catch (e) {
      log("⚠️ Error fetching weekly minutes: $e");
    }

    return {
      'subjectPerformanceSummary': subjectPerformance,
      'weeklyMinutes': weeklyMinutes,
    };
  }

  static String? getCurrentUserId() {
    log(_client.auth.currentUser!.id.toString());
    return _client.auth.currentUser?.id;
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static Future<bool> updateStreakAfterTaskCompletion(String userId) async {
    final today = DateTime.now();
    final todayStr = today.toIso8601String().substring(0, 10);

    final userData =
        await client
            .from('users')
            .select('current_streak, longest_streak, last_streak_date')
            .eq('id', userId)
            .maybeSingle();

    int currentStreak = userData?['current_streak'] ?? 0;
    int longestStreak = userData?['longest_streak'] ?? 0;
    String? lastDateStr = userData?['last_streak_date'];
    DateTime? lastDate =
        lastDateStr != null ? DateTime.parse(lastDateStr) : null;

    bool updated = false;
    bool increased = false;

    if (lastDate == null || !_isSameDay(lastDate, today)) {
      if (lastDate != null && today.difference(lastDate).inDays == 1) {
        currentStreak += 1;
        increased = true;
      } else {
        currentStreak = 1;
        increased = true;
      }

      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }

      updated = true;
    }

    log("⚙️ Should update streak log: $updated");

    if (updated) {
      await client
          .from('users')
          .update({
            'current_streak': currentStreak,
            'longest_streak': longestStreak,
            'last_streak_date': todayStr,
          })
          .eq('id', userId);

      // ✅ Add streak log entry
      await client.from('streak_logs').upsert({
        'user_id': userId,
        'date': todayStr,
        'status': 'continued',
        'action': 'worked',
      });

      log("📝 streak_logs entry added.");
    }

    return increased;
  }

  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "U";
  }
}
