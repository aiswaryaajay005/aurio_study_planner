import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/rewards_screen/rewards_screen.dart';
import 'package:flutter/material.dart';

class DailySummaryScreen extends StatelessWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int tasksDone = 4;
    final double hours = 1.5;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Daily Summary")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: ColorConstants.accentColor,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              "Great job! You finished $tasksDone tasks.\nTotal study time: $hours hrs",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConstants.TextColor, fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RewardsScreen()),
                );
              },
              child: const Text("Next Day"),
            ),
          ],
        ),
      ),
    );
  }
}
