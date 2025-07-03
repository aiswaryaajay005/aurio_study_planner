import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Terms of Service"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            """
By accessing or using the Aurio app, you agree to the following terms designed to support your learning journey:

• 🎓 **Educational Purpose**  
Aurio is a study planning and productivity tool intended to help students organize, focus, and grow academically. It does not provide certified academic counseling or professional advice.

• 📅 **Responsible Use**  
Users agree to use the platform respectfully and honestly — including task management, reward systems, and AI tools — for their personal academic benefit.

• 🔁 **No Abuse of AI Tools**  
Aurio may provide AI-powered suggestions and insights. These are intended to support study habits, not to replace personal effort or original thinking.

• 💡 **Community Trust**  
Aurio is built on trust and progress. Any misuse of the platform to game the reward system, falsify data, or impersonate other users may result in limited access or removal.

• ⚖️ **Changes to Terms**  
These terms may be updated as the app evolves. Continued use implies acceptance of future updates.

We’re here to support your goals with motivation, structure, and care. Let’s grow, one task at a time.

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
