import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class AdaptiveUpdateScreen extends StatelessWidget {
  const AdaptiveUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      "Move more time to Science",
      "Reduce History load",
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Adaptive Update")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "AI suggests changes based on your past sessions:",
              style: TextStyle(color: ColorConstants.TextColor, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ...suggestions.map(
              (item) => ListTile(
                leading: Icon(Icons.tune, color: ColorConstants.accentColor),
                title: Text(
                  item,
                  style: TextStyle(color: ColorConstants.TextColor),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }
}
