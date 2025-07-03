import 'package:aurio/features/manage_subject_screen/controller/subject_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageSubjectsScreen extends StatelessWidget {
  const ManageSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = SubjectController();
        controller.fetchSubjects();
        return controller;
      },
      child: const _SubjectListView(),
    );
  }
}

class _SubjectListView extends StatelessWidget {
  const _SubjectListView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<SubjectController>();
    final activeSubjects =
        ctrl.subjects.where((s) => s['active'] == true).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Subjects")),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : activeSubjects.isEmpty
              ? const Center(child: Text("No subjects yet. Tap + to add."))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activeSubjects.length,
                itemBuilder: (context, index) {
                  final subject = activeSubjects[index];
                  return Dismissible(
                    key: Key(subject['subject']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ctrl.deleteSubject(index, context);
                    },
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          subject['subject'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "Difficulty: ${subject['difficulty']}",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                _showEditDialog(
                                  context,
                                  index,
                                  subject['subject'],
                                  subject['difficulty'],
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                context.read<SubjectController>().deleteSubject(
                                  index,
                                  context,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    String difficulty = 'Medium';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Add Subject"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Subject"),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: difficulty,
                  decoration: const InputDecoration(labelText: "Difficulty"),
                  items:
                      ['Easy', 'Medium', 'Hard']
                          .map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          )
                          .toList(),
                  onChanged: (val) => difficulty = val!,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    context.read<SubjectController>().addSubject(
                      nameCtrl.text.trim(),
                      difficulty,
                      context,
                    );
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    int index,
    String name,
    String difficulty,
  ) {
    final nameCtrl = TextEditingController(text: name);
    String updatedDifficulty = difficulty;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("Edit Subject"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Subject"),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: updatedDifficulty,
                  decoration: const InputDecoration(labelText: "Difficulty"),
                  items:
                      ['Easy', 'Medium', 'Hard']
                          .map(
                            (d) => DropdownMenuItem(value: d, child: Text(d)),
                          )
                          .toList(),
                  onChanged: (val) => updatedDifficulty = val!,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    await context.read<SubjectController>().editSubject(
                      context,
                      index,
                      nameCtrl.text.trim(),
                      updatedDifficulty,
                    );

                    // ✅ Important: Make sure this is inside `showDialog`, and context is mounted
                    if (context.mounted) Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }
}
