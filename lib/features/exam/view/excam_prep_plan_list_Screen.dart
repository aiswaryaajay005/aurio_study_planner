import 'package:aurio/core/services/supabase_helper.dart';
import 'package:flutter/material.dart';

class ExamPrepPlanListScreen extends StatefulWidget {
  final int examId; // 👈 this was missing!
  final String subject;

  const ExamPrepPlanListScreen({
    super.key,
    required this.examId,
    required this.subject,
  });

  @override
  State<ExamPrepPlanListScreen> createState() => _ExamPrepPlanListScreenState();
}

class _ExamPrepPlanListScreenState extends State<ExamPrepPlanListScreen> {
  List<Map<String, dynamic>> plan = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final userId = SupabaseHelper.getCurrentUserId();

      final data = await SupabaseHelper.client
          .from('exam_tasks')
          .select()
          .eq('user_id', userId!)
          .eq('exam_plan_id', widget.examId);

      setState(() {
        plan = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading tasks: $e");
    }
  }

  Future<void> toggleTask(int index) async {
    final task = plan[index];
    final newStatus = !(task['is_done'] ?? false);

    await SupabaseHelper.client
        .from('exam_tasks')
        .update({'is_done': newStatus})
        .eq('id', task['id']);

    setState(() {
      plan[index]['is_done'] = newStatus;
    });
  }

  void showAddTaskDialog() {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (taskContext) => AlertDialog(
            title: const Text("Add Task"),
            content: TextField(controller: ctrl),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(taskContext),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (ctrl.text.trim().isNotEmpty) {
                    await SupabaseHelper.client.from('exam_tasks').insert({
                      'user_id': SupabaseHelper.getCurrentUserId(),
                      'exam_plan_id': widget.examId,
                      'task': ctrl.text.trim(),
                    });
                    Navigator.pop(taskContext);
                    await loadTasks();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void showEditTaskDialog(Map task, int index) {
    final ctrl = TextEditingController(text: task['task']);

    showDialog(
      context: context,
      builder:
          (dailogContext) => AlertDialog(
            title: const Text("Edit Task"),
            content: TextField(controller: ctrl),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dailogContext),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if (ctrl.text.trim().isNotEmpty) {
                    await SupabaseHelper.client
                        .from('exam_tasks')
                        .update({'task': ctrl.text.trim()})
                        .eq('id', task['id']);
                    Navigator.pop(dailogContext);
                    await loadTasks();
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subject} Prep Plan"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : plan.isEmpty
              ? const Center(child: Text("No preparation tasks added yet."))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: plan.length,
                itemBuilder: (context, index) {
                  final task = plan[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: ListTile(
                      leading: Icon(
                        task['is_done'] == true
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color:
                            task['is_done'] == true
                                ? Colors.green
                                : Colors.grey,
                      ),
                      title: Text(
                        task['task'] ?? 'Untitled Task',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          decoration:
                              task['is_done'] == true
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      onTap: () => toggleTask(index),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => showEditTaskDialog(task, index),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
