import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class RewardDetailsScreen extends StatelessWidget {
  const RewardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = [
      {"date": "2024-05-18", "reward": "+5 Diamonds"},
      {"date": "2024-05-17", "reward": "+10 Coins"},
      {"date": "2024-05-16", "reward": "+7 Diamonds"},
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.appBarColor,
        title: Text(
          "My Rewards",
          style: TextStyle(color: ColorConstants.textColor),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          return Card(
            color: ColorConstants.primaryColor.withOpacity(0.2),
            child: ListTile(
              leading: const Icon(Icons.stars, color: Colors.amber),
              title: Text(
                reward['reward']!,
                style: TextStyle(color: ColorConstants.textColor),
              ),
              subtitle: Text(
                reward['date']!,
                style: TextStyle(color: ColorConstants.accentColor),
              ),
            ),
          );
        },
      ),
    );
  }
}
