// view/build_plan_screen.dart

import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/daily_plan_screen/daily_plan_screen.dart';
import 'package:flutter/material.dart';

class BuildPlanScreen extends StatefulWidget {
  const BuildPlanScreen({super.key});

  @override
  State<BuildPlanScreen> createState() => _BuildPlanScreenState();
}

class _BuildPlanScreenState extends State<BuildPlanScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DailyPlanScreen()),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 80,
                color: ColorConstants.accentColor,
              ),
              const SizedBox(height: 30),
              Text(
                "Analyzing subjects...\nGenerating your personalized study plan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorConstants.TextColor, fontSize: 16),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: ColorConstants.accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
