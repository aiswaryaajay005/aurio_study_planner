import 'package:aurio/core/services/local_notification_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../view/notifications_screen/view_model/notification_helper.dart';

class NotificationScheduler {
  static final _client = Supabase.instance.client;

  /// Call this once per day for each user (e.g., after login or via cron)
  static Future<void> runDailyChecks(String userId) async {
    await _sendWelcomeMotivation(userId);
    await _notifyPendingTasks(userId);
    await _checkMissedStreak(userId);
    await _sendMotivationalIfNoStudy(userId);
    await _notifyUpcomingExams(userId);
    await _notifyPendingExamTasks(userId);
    await _notifyLeaderboardDrop(userId);
  }

  /// 1. Notify tasks due today or overdue
  static Future<void> _notifyPendingTasks(String userId) async {
    final today = DateTime.now();
    final res = await _client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('is_completed', false)
        .lte('due_date', today.toIso8601String());

    if (res.isNotEmpty) {
      final title = "⏰ ${res.length} pending tasks";
      final message = "Complete your tasks before the day ends!";

      await NotificationHelper.sendNotification(
        userId: userId,
        title: title,
        message: message,
        type: 'reminder',
      );

      await LocalNotificationHelper.showNotification(
        title: title,
        body: message,
      );
    }
  }

  /// 2. Notify if user missed streak yesterday
  static Future<void> _checkMissedStreak(String userId) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final res = await _client
        .from('streak_logs')
        .select()
        .eq('user_id', userId)
        .eq('date', yesterday.toIso8601String());

    if (res.isNotEmpty && res[0]['status'] == 'missed') {
      const title = "⚠️ Missed your streak!";
      const message = "Don’t give up! Restart your streak today 💪";

      await NotificationHelper.sendNotification(
        userId: userId,
        title: title,
        message: message,
        type: 'warning',
      );

      await LocalNotificationHelper.showNotification(
        title: title,
        body: message,
      );
    }
  }

  /// 3. No study session yet today
  static Future<void> _sendMotivationalIfNoStudy(String userId) async {
    final todayStart = DateTime.now();
    final startOfDay = DateTime(
      todayStart.year,
      todayStart.month,
      todayStart.day,
    );
    final res = await _client
        .from('study_sessions')
        .select()
        .eq('user_id', userId)
        .gte('date', startOfDay.toIso8601String());

    if (res.isEmpty) {
      const title = "👊 Let’s get started!";
      const message = "Even 15 minutes of study makes a difference today.";

      await NotificationHelper.sendNotification(
        userId: userId,
        title: title,
        message: message,
        type: 'motivation',
      );

      await LocalNotificationHelper.showNotification(
        title: title,
        body: message,
      );
    }
  }

  /// 4. Upcoming exams in 3 days or less
  static Future<void> _notifyUpcomingExams(String userId) async {
    final now = DateTime.now();
    final res = await _client
        .from('exam_plans')
        .select()
        .eq('user_id', userId)
        .gte('exam_date', now.toIso8601String())
        .lte('exam_date', now.add(const Duration(days: 3)).toIso8601String());

    for (final exam in res) {
      final daysLeft = DateTime.parse(exam['exam_date']).difference(now).inDays;
      final title = "📚 Upcoming Exam: ${exam['subject']}";
      final message = "Only $daysLeft day(s) left!";

      await NotificationHelper.sendNotification(
        userId: userId,
        title: title,
        message: message,
        type: 'exam',
      );

      await LocalNotificationHelper.showNotification(
        title: title,
        body: message,
      );
    }
  }

  /// 5. Notify if exam tasks are pending
  static Future<void> _notifyPendingExamTasks(String userId) async {
    final res = await _client
        .from('exam_tasks')
        .select()
        .eq('user_id', userId)
        .eq('is_done', false);

    if (res.isNotEmpty) {
      final title = "📋 ${res.length} exam tasks pending";
      final message = "Review your exam prep checklist now!";

      await NotificationHelper.sendNotification(
        userId: userId,
        title: title,
        message: message,
        type: 'reminder',
      );

      await LocalNotificationHelper.showNotification(
        title: title,
        body: message,
      );
    }
  }

  /// 6. Notify leaderboard drop if user left top 5
  static Future<void> _notifyLeaderboardDrop(String userId) async {
    final leaderboard = await _client
        .from('user_rewards')
        .select('user_id, total_xp')
        .order('total_xp', ascending: false)
        .limit(10);

    final currentIndex = leaderboard.indexWhere((e) => e['user_id'] == userId);

    if (currentIndex != -1 && currentIndex >= 5) {
      final title = "📉 You dropped to rank #${currentIndex + 1}";
      const message = "Time to level up your XP and climb back!";

      await NotificationHelper.sendNotification(
        userId: userId,
        title: title,
        message: message,
        type: 'alert',
      );

      await LocalNotificationHelper.showNotification(
        title: title,
        body: message,
      );
    }
  }

  /// 7. Send welcome motivational message (once per login/day)
  static Future<void> _sendWelcomeMotivation(String userId) async {
    final messages = [
      "✨ New day, new possibilities. Let's grow!",
      "💪 You’re stronger than you think.",
      "📚 One chapter at a time. You got this!",
      "🎯 Stay focused. Small steps lead to big goals.",
      "🔥 Let’s crush today’s plan!",
    ];
    final message = (messages..shuffle()).first;
    const title = "Welcome back 👋";

    await NotificationHelper.sendNotification(
      userId: userId,
      title: title,
      message: message,
      type: 'motivation',
    );

    await LocalNotificationHelper.showNotification(title: title, body: message);
  }

  /// 8. Send motivational ping 30 minutes after login
  static Future<void> schedulePostLoginMotivation(String userId) async {
    await Future.delayed(
      const Duration(minutes: 30),
    ); // Use seconds for testing

    final messages = [
      "🚀 Let’s keep up the momentum!",
      "💡 Done something productive yet?",
      "⏳ 30 minutes passed — time to check your goals!",
      "📖 Have you reviewed your notes today?",
    ];
    final message = (messages..shuffle()).first;
    const title = "Quick Check-In";

    await NotificationHelper.sendNotification(
      userId: userId,
      title: title,
      message: message,
      type: 'motivation',
    );

    await LocalNotificationHelper.showNotification(title: title, body: message);
  }
}
