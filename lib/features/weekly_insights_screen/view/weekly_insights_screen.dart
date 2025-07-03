import 'package:flutter/material.dart';

class WeeklyInsightsScreen extends StatelessWidget {
  const WeeklyInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Weekly Insights")),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _insightCard("Study Hours", "You studied for 14 hrs this week 📚"),
          _insightCard("Consistency", "5 out of 7 days were productive ✅"),
          _insightCard("Focus Area", "You spent the most time on Math 🔢"),
          _insightCard("Suggestions", "Try balancing with more Science ⛏️"),
        ],
      ),
    );
  }

  Widget _insightCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.insights, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }
}
