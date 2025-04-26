import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class StreakDetailsScreen extends StatelessWidget {
  const StreakDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentStreak = 7;
    final int totalFreezesUsed = 2;
    final List<String> freezeDates = ["2024-05-10", "2024-05-15"];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("My Streak")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "🔥 Current Streak: $currentStreak days",
              style: TextStyle(fontSize: 22, color: ColorConstants.accentColor),
            ),
            const SizedBox(height: 30),
            Text(
              "❄️ Freezes Used: $totalFreezesUsed",
              style: TextStyle(fontSize: 18, color: ColorConstants.TextColor),
            ),
            const SizedBox(height: 20),
            Text(
              "Freeze Dates:",
              style: TextStyle(fontSize: 16, color: ColorConstants.TextColor),
            ),
            ...freezeDates.map(
              (date) => ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  date,
                  style: TextStyle(color: ColorConstants.TextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
