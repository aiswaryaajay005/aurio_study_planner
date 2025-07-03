import 'package:aurio/features/task_planner_screen/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPlannerScreen extends StatelessWidget {
  const TaskPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskController()..fetchTasks(),
      child: const _TaskBody(),
    );
  }
}

class _TaskBody extends StatelessWidget {
  const _TaskBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TaskController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Planner"),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          ctrl.tasks.isEmpty
                              ? const Center(child: Text("No tasks yet"))
                              : ListView.separated(
                                itemCount: ctrl.tasks.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final task = ctrl.tasks[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 3,
                                    child: CheckboxListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Text(
                                        task['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                              theme.textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      subtitle:
                                          task['due_date'] != null
                                              ? Text(
                                                "Due: ${task['due_date']}",
                                                style: TextStyle(
                                                  color: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.color
                                                      ?.withOpacity(0.7),
                                                ),
                                              )
                                              : null,
                                      secondary: _priorityIcon(
                                        task['priority'],
                                      ),
                                      value: task['is_completed'] ?? false,
                                      onChanged: (val) {
                                        ctrl.toggleCompletion(
                                          task['id'],
                                          val ?? false,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _priorityIcon(String? priority) {
    switch (priority) {
      case 'high':
        return const Icon(Icons.priority_high, color: Colors.red);
      case 'medium':
        return const Icon(Icons.flag, color: Colors.orange);
      case 'low':
        return const Icon(Icons.low_priority, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _filterChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: false, // You can bind this to controller later
      onSelected: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filter "$label" not implemented yet')),
        );
      },
      selectedColor: theme.colorScheme.secondary.withOpacity(0.2),
      side: BorderSide(color: theme.colorScheme.secondary),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final taskCtrl = context.read<TaskController>();
    final titleCtrl = TextEditingController();
    DateTime? dueDate;
    String? selectedPriority = 'medium';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Add New Task"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: "Task Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['low', 'medium', 'high']
                          .map(
                            (level) => DropdownMenuItem(
                              value: level,
                              child: Text(level.toUpperCase()),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => selectedPriority = val,
                  validator:
                      (value) =>
                          value == null ? 'Please select a priority' : null,
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder:
                      (context, setState) => ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              dueDate = picked;
                            });
                          }
                        },
                        label: Text(
                          dueDate == null
                              ? "Pick Due Date"
                              : "Due: ${dueDate!.toLocal().toString().split(' ')[0]}",
                        ),
                      ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (dueDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a due date."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  taskCtrl.addTask(
                    title: titleCtrl.text.trim(),
                    priority: selectedPriority!,
                    dueDate: dueDate,
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        );
      },
    );
  }
}
