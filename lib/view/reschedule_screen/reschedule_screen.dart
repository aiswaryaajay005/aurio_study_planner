import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class RescheduleScreen extends StatelessWidget {
  const RescheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String task = "Biology - Chapter 5";

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Reschedule Task")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "New time for: $task",
              style: TextStyle(color: ColorConstants.TextColor),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Choose new time",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Apply Reschedule"),
            ),
          ],
        ),
      ),
    );
  }
}
