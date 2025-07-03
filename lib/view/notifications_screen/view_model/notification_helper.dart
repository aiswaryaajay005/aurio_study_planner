import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationHelper {
  static final _client = Supabase.instance.client;

  static Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
  }) async {
    await _client.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
    });
  }

  static Future<List<Map<String, dynamic>>> fetchNotifications(
    String userId,
  ) async {
    return await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  static Future<void> markAllAsRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId);
  }
}
