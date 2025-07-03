import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """
At Aurio, your privacy and trust are our top priorities. We are committed to providing a secure and transparent experience that supports your learning journey.

• 🔒 **Data Security**: All your data — including study sessions, daily plans, streaks, rewards, and journal entries — is securely stored. Only you have access to it.

• 📊 **No Third-Party Sharing**: We do not sell or share your personal or academic data with advertisers or external organizations.

• ✏️ **User-Controlled Experience**: Your preferences, tasks, and sessions remain fully customizable and under your control. You can edit or delete your data at any time.

• 🤖 **AI Assistance with Responsibility**: AI-generated insights or suggestions are designed to support your growth and are never used to profile or track you beyond the app’s learning features.

• 📆 **Daily Logs & Rewards**: Task completions, XP, coins, and reward logs are stored only for your personal progress and motivation.

By using Aurio, you’re in charge of your data. We’re here to help you grow — not track you.

For any questions, feel free to contact us via the Help & Support section.

– Team Aurio
            """,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
