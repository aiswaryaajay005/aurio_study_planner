// view/next_session_screen.dart

import 'package:aurio/view/active_session_screen/active_session_screen.dart';
import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class NextSessionScreen extends StatelessWidget {
  const NextSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String subject = "Math";
    final String timeRange = "9:00 – 10:00 a.m.";

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.backgroundColor,
        title: const Text("Next Session"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 80, color: ColorConstants.accentColor),
            const SizedBox(height: 20),
            Text(
              "$subject\n$timeRange",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstants.TextColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActiveSessionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start Now"),
            ),
          ],
        ),
      ),
    );
  }
}
