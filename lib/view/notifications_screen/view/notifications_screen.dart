import 'package:aurio/view/missed_tasks_screen/view/missed_tasks_screen.dart';
import 'package:aurio/view/notifications_screen/view_model/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final notifications = await NotificationHelper.fetchNotifications(userId);
    setState(() {
      _notifications = notifications;
      _loading = false;
    });

    // Optionally: mark all as read
    await NotificationHelper.markAllAsRead(userId);
  }

  Icon _getIconForType(String type) {
    switch (type) {
      case 'reminder':
        return const Icon(Icons.notifications_active, color: Colors.blueAccent);
      case 'warning':
        return const Icon(Icons.warning_amber, color: Colors.orange);
      case 'exam':
        return const Icon(Icons.school, color: Colors.purple);
      case 'motivation':
        return const Icon(Icons.flash_on, color: Colors.green);
      case 'alert':
        return const Icon(Icons.trending_down, color: Colors.redAccent);
      default:
        return const Icon(Icons.notifications, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Notifications")),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _notifications.isEmpty
              ? const Center(child: Text("No notifications yet"))
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return ListTile(
                    leading: _getIconForType(notif['type']),
                    title: Text(
                      notif['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      notif['message'],
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                    trailing:
                        notif['is_read']
                            ? null
                            : const Icon(
                              Icons.fiber_manual_record,
                              color: Colors.red,
                              size: 10,
                            ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MissedTasksScreen(),
              ),
            );
          },
          icon: const Icon(Icons.pending_actions),
          label: const Text("View Missed Tasks"),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
