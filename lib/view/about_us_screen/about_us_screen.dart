import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("About Aurio")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 50,
              backgroundColor: ColorConstants.primaryColor,
              child: Icon(Icons.school_outlined, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              "Aurio Study Planner",
              style: TextStyle(
                fontSize: 24,
                color: ColorConstants.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Version 1.0.0",
              style: TextStyle(color: ColorConstants.TextColor),
            ),
            const SizedBox(height: 30),
            Text(
              "Aurio is a smart AI-powered study planning app designed to help students organize their tasks, manage their exams, and stay motivated with rewards and streaks. Plan smarter, study lighter!",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConstants.TextColor, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Text(
              "Developed with ❤️ by the Aurio Team.",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConstants.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
