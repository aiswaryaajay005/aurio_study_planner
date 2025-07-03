import 'dart:math';
import 'package:aurio/features/ai_tips/model/ai_tips_model.dart';
import 'package:flutter/material.dart';

class AiTipsScreen extends StatelessWidget {
  const AiTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final shuffled = List<String>.from(aiTipsList)..shuffle(random);
    final dailyTips = shuffled.take(5).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("AI Study Tips")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: dailyTips.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            child: ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.amber),
              title: Text(
                dailyTips[index],
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
