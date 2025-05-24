import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {"name": "You", "progress": "100%"},
      {"name": "Niya", "progress": "88%"},
      {"name": "Miya", "progress": "79%"},
    ];

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.appBarColor,
        title: Text(
          "Leaderboard",
          style: TextStyle(color: ColorConstants.textColor),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text("${index + 1}"),
              backgroundColor: ColorConstants.accentColor,
            ),
            title: Text(
              user['name']!,
              style: TextStyle(color: ColorConstants.textColor),
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
