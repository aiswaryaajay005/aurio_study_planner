import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/reschedule_screen/reschedule_screen.dart';
import 'package:flutter/material.dart';

class MissedTasksScreen extends StatelessWidget {
  const MissedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final missedTasks = [
      {"subject": "Biology", "task": "Chapter 2"},
      {"subject": "Chemistry", "task": "Formulas Quiz"},
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Missed Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children:
              missedTasks
                  .map(
                    (task) => Card(
                      color: ColorConstants.primaryColor.withOpacity(0.1),
                      child: ListTile(
                        title: Text(
                          "${task['subject']}: ${task['task']}",
                          style: TextStyle(color: ColorConstants.textColor),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RescheduleScreen(),
                              ),
                            );
                          },
                          child: const Text("Reschedule"),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
