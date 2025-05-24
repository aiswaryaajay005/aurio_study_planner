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
        backgroundColor: ColorConstants.appBarColor,
        title: Text(
          "Today's Plan",
          style: TextStyle(color: ColorConstants.textColor),
        ),
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
                        color: ColorConstants.textColor,
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
                              ? Colors.indigo
                              : ColorConstants.accentColor,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NextSessionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
              ),
              child: Text(
                "Start",
                style: TextStyle(color: ColorConstants.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
