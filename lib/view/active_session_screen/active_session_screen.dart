// view/active_session_screen.dart

import 'dart:async';
import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/daily_summary_screen/daily_summary_screen.dart';
import 'package:flutter/material.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  int secondsRemaining = 1500; // 25 minutes = 1500 seconds
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => countdown());
  }

  void countdown() {
    if (secondsRemaining > 0) {
      setState(() => secondsRemaining--);
    } else {
      timer.cancel();
      // Session finished
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Session Complete!"),
              content: const Text(
                "Well done, you finished your study session.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailySummaryScreen(),
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTime =
        "${(secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.backgroundColor,
        title: const Text("Active Session"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Math",
              style: TextStyle(fontSize: 22, color: ColorConstants.textColor),
            ),
            const SizedBox(height: 20),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: ColorConstants.accentColor,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
              ),
              onPressed: () {
                timer.cancel();
                Navigator.pop(context);
              },
              child: const Text("Pause / Stop"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
              ),
              onPressed: () {
                timer.cancel();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DailySummaryScreen()),
                );
              },
              child: const Text("Completed"),
            ),
          ],
        ),
      ),
    );
  }
}
