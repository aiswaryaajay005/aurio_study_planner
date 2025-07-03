import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> updateUserStreak() async {
  final client = Supabase.instance.client;
  final user = client.auth.currentUser;
  if (user == null) return;

  final userId = user.id;
  final today = DateTime.now();
  final todayStr = today.toIso8601String().substring(0, 10); // YYYY-MM-DD

  try {
    final userData =
        await client
            .from('users')
            .select(
              'current_streak, last_streak_date, freezes_used, freeze_dates',
            )
            .eq('id', userId)
            .maybeSingle();

    if (userData == null) return;

    final lastDateStr = userData['last_streak_date'];
    final lastDate =
        lastDateStr != null ? DateTime.tryParse(lastDateStr) : null;

    final currentStreak = userData['current_streak'] ?? 0;

    int updatedStreak = currentStreak;
    String message = '';

    if (lastDate == null) {
      updatedStreak = 1;
      message = "🎉 Streak started! Day 1!";
    } else {
      final daysDiff = today.difference(lastDate).inDays;

      if (daysDiff == 0) {
        message = "✅ Already logged today. Keep going!";
      } else if (daysDiff == 1) {
        updatedStreak += 1;
        message = "🔥 You're on a $updatedStreak-day streak!";
      } else if (daysDiff > 1) {
        // TODO: Handle freeze logic here (optional)
        updatedStreak = 1;
        message = "😓 Streak broken. Starting over from Day 1!";
      }
    }

    await client
        .from('users')
        .update({'current_streak': updatedStreak, 'last_streak_date': todayStr})
        .eq('id', userId);

    debugPrint(message);
  } catch (e) {
    debugPrint("❌ Error updating streak: $e");
  }
}
