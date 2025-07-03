import 'package:flutter/material.dart';

class ExamPrepOverviewScreen extends StatelessWidget {
  final Map<String, dynamic> exam;

  const ExamPrepOverviewScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final String subject = exam['subject'];
    final DateTime examDate = DateTime.parse(exam['exam_date']);
    final DateTime today = DateTime.now();
    final int daysLeft = examDate.difference(today).inDays;

    final todayTask = "Revise Chapter 3 - Thermodynamics";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Prep"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$subject Exam",
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "📅 Exam Date: ${examDate.toLocal().toString().split(" ")[0]}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "⏳ $daysLeft day${daysLeft != 1 ? 's' : ''} left to prepare",
              style: TextStyle(
                fontSize: 16,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "📌 Today's Task:",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.book_outlined),
                title: Text(
                  todayTask,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task marked as done!")),
                    );
                  },
                  child: const Text("Done"),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text("View Full Plan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
