import 'package:aurio/features/study/controller/daily_plan_controller.dart';
import 'package:aurio/features/study/controller/next_session_controller.dart';
import 'package:aurio/features/study/view/active_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextSessionScreen extends StatelessWidget {
  const NextSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyCtrl = context.watch<DailyPlanController>();
    final nextCtrl = NextSessionController(dailyCtrl: dailyCtrl);
    final session = nextCtrl.getNextSession();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Next Session",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      body: Center(
        child:
            session == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.celebration,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "All tasks completed! 🎉",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Back to Daily Plan"),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 80,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${session['subject']}\n${session['timeRange']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    ActiveSessionScreen(sessionData: session),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(
                        "Start Now",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        final index = dailyCtrl.todayTasks.indexWhere(
                          (t) => !(t['done'] ?? false),
                        );
                        if (index != -1) {
                          dailyCtrl.markTaskAsDone(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Marked as done ✅")),
                          );
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("Mark as Done"),
                    ),
                  ],
                ),
      ),
    );
  }
}
