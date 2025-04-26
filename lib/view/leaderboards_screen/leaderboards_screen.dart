import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {"name": "You", "progress": "100%"},
      {"name": "Alice", "progress": "88%"},
      {"name": "John", "progress": "79%"},
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(title: const Text("Leaderboard")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(
              user['name']!,
              style: TextStyle(color: ColorConstants.TextColor),
            ),
            trailing: Text(
              user['progress']!,
              style: TextStyle(color: ColorConstants.accentColor),
            ),
          );
        },
      ),
    );
  }
}
