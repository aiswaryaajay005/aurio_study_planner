import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class StreakFreezeScreen extends StatelessWidget {
  const StreakFreezeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Missed a Day?")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: ColorConstants.accentColor,
            ),
            const SizedBox(height: 20),
            Text(
              "Missed your streak?\nUse freeze to save it!",
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorConstants.TextColor, fontSize: 18),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Use Freeze"),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
