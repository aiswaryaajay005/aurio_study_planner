// view/study_plan_screen.dart

import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.backgroundColor,
        title: const Text("Your Study Plan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "Math - 10 tasks",
                style: TextStyle(color: ColorConstants.TextColor),
              ),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            ListTile(
              title: Text(
                "Science - 5 tasks",
                style: TextStyle(color: ColorConstants.TextColor),
              ),
              trailing: Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ),
            ListTile(
              title: Text(
                "History - 8 tasks",
                style: TextStyle(color: ColorConstants.TextColor),
              ),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
            // Add more dummy subjects
          ],
        ),
      ),
    );
  }
}
