import 'package:aurio/view/missed_tasks_screen/controller/missed_tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissedTasksScreen extends StatefulWidget {
  const MissedTasksScreen({super.key});

  @override
  State<MissedTasksScreen> createState() => _MissedTasksScreenState();
}

class _MissedTasksScreenState extends State<MissedTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissedTasksController>().loadMissedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MissedTasksController>();
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "📌 Missed Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.missedTasks.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "🎉 No missed tasks yesterday!",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor?.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                )
                : ListView.separated(
                  itemCount: controller.missedTasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = controller.missedTasks[index];
                    final taskTitle = "${task['subject']}: ${task['task']}";

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              taskTitle,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  content: const Text(
                                    "Reschedule feature coming soon!",
                                  ),
                                ),
                              );
                            },
                            child: const Text("Reschedule"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
