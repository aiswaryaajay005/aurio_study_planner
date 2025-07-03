import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class CalendarSyncScreen extends StatelessWidget {
  const CalendarSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Calendar Sync")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                "Google Calendar Integration",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Functionality not implemented yet!"),
                    ),
                  );
                },
                child: const Text("Sync Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
