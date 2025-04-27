import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/add_exam_screen/add_exam_screen.dart';
import 'package:flutter/material.dart';

class ExamsAheadScreen extends StatelessWidget {
  const ExamsAheadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exam = {"subject": "Math", "daysLeft": 3};

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Exams Coming Up")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer_rounded,
              size: 80,
              color: ColorConstants.accentColor,
            ),
            const SizedBox(height: 20),
            Text(
              "${exam['subject']} exam in ${exam['daysLeft']} days!",
              style: TextStyle(color: ColorConstants.TextColor, fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Start Extra Prep"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExamScreen(),
                  ),
                );
              },
              child: const Text("Add New Exam"),
            ),
          ],
        ),
      ),
    );
  }
}
