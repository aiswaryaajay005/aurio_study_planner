import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class CalendarSyncScreen extends StatelessWidget {
  const CalendarSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Calendar Sync")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Google Calendar Integration",
              style: TextStyle(color: ColorConstants.TextColor, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // trigger calendar sync
              },
              child: const Text("Sync Now"),
            ),
          ],
        ),
      ),
    );
  }
}
