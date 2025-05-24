import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/streak_freeze_screen/streak_freeze_screen.dart';
import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int coins = 10;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.appBarColor,
        title: Text(
          "Rewards",
          style: TextStyle(color: ColorConstants.appBarColor),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.military_tech,
              size: 80,
              color: ColorConstants.accentColor,
            ),
            const SizedBox(height: 20),
            Text(
              "💎 $coins Coins",
              style: TextStyle(fontSize: 24, color: ColorConstants.textColor),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StreakFreezeScreen()),
                );
              },
              child: const Text("Claim"),
            ),
          ],
        ),
      ),
    );
  }
}
