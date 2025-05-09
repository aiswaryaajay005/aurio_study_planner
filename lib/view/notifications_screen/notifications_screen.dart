import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/missed_tasks_screen/missed_tasks_screen.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> reminders = [
      "Math at 9 AM",
      "Science at 11 AM",
      "History at 2 PM",
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Notifications")),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            itemCount: reminders.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(
                    reminders[index],
                    style: TextStyle(color: ColorConstants.TextColor),
                  ),
                ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle button press
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MissedTasksScreen(),
                ),
              );
            },
            child: const Text("Missed Tasks"),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
