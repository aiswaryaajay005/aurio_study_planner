// view/daily_plan_screen.dart

import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/next_session_screen/next_session_screen.dart';
import 'package:flutter/material.dart';

class DailyPlanScreen extends StatelessWidget {
  const DailyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tasks = [
      {"subject": "Math", "task": "Revise Algebra", "done": true},
      {"subject": "Science", "task": "Read Chapter 5", "done": false},
      {"subject": "History", "task": "Notes on WWII", "done": true},
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.backgroundColor,
        title: const Text("Today's Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  color: ColorConstants.primaryColor.withOpacity(0.2),
                  child: ListTile(
                    title: Text(
                      "${task['subject']}: ${task['task']}",
                      style: TextStyle(
                        color: ColorConstants.TextColor,
                        decoration:
                            task['done'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Icon(
                      task['done']
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          task['done']
                              ? Colors.green
                              : ColorConstants.accentColor,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NextSessionScreen(),
                  ),
                );
              },
              child: Text("Start"),
            ),
          ],
        ),
      ),
    );
  }
}
