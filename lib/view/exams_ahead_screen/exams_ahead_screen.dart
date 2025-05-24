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
      appBar: AppBar(
        title: Text(
          "Exams Coming Up",
          style: TextStyle(color: ColorConstants.textColor),
        ),
        backgroundColor: ColorConstants.appBarColor,
      ),
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
              style: TextStyle(color: ColorConstants.textColor, fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
              ),
              child: Text(
                "Start Extra Prep",
                style: TextStyle(color: ColorConstants.textColor),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
              ),
              child: Text(
                "Add New Exam",
                style: TextStyle(color: ColorConstants.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
