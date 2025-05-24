import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class AdjustedScheduleScreen extends StatelessWidget {
  const AdjustedScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> changes = [
      "Math: 2 PM → 4 PM",
      "History: 3 PM → 5 PM",
      "Science: 5 PM → 7 PM",
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Adjusted Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ...changes.map(
              (c) => ListTile(
                title: Text(
                  c,
                  style: TextStyle(color: ColorConstants.textColor),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Accept"),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Revert"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
