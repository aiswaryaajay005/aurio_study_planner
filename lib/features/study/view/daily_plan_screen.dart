// --- DailyPlanScreen.dart (Feedback logic removed) ---

import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/study/view/active_session_screen.dart';
import 'package:aurio/features/adjusted_schedule_screen/view/adjusted_schedule_screen.dart';
import 'package:aurio/features/study/view/next_session_screen.dart';
import 'package:aurio/features/study/controller/daily_plan_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DailyPlanController>().loadPlanForToday();
  }

  @override
  Widget build(BuildContext context) {
    final dailyCtrl = context.watch<DailyPlanController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Today's Plan",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      body:
          dailyCtrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : dailyCtrl.todayTasks.isEmpty
              ? const Center(child: Text("No tasks for today."))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: dailyCtrl.todayTasks.length,
                        itemBuilder: (context, index) {
                          final task = dailyCtrl.todayTasks[index];
                          return Card(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                            child: ListTile(
                              title: Text(
                                "${task['subject']}: ${task['duration_minutes']} min",
                                style: TextStyle(
                                  decoration:
                                      (task['done'] ?? false)
                                          ? TextDecoration.lineThrough
                                          : null,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  (task['done'] ?? false)
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                ),
                                onPressed: () => dailyCtrl.toggleTask(index),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ActiveSessionScreen(
                                          sessionData: {
                                            'subject': task['subject'],
                                            'duration_minutes':
                                                task['duration_minutes'],
                                          },
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NextSessionScreen(),
                          ),
                        );
                      },
                      child: const Text("Start"),
                    ),
                    const SizedBox(height: 10),
                    Tooltip(
                      message:
                          dailyCtrl.todayTasks.every(
                                (task) => task['done'] == true,
                              )
                              ? "All tasks are completed. Cannot adjust schedule."
                              : "Adjust your schedule for today.",
                      child: ElevatedButton(
                        onPressed:
                            dailyCtrl.todayTasks.every(
                                  (task) => task['done'] == true,
                                )
                                ? null
                                : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => AdjustedScheduleScreen(
                                            originalPlan: dailyCtrl.todayTasks,
                                          ),
                                    ),
                                  );
                                },
                        child: const Text("Adjust Schedule"),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
