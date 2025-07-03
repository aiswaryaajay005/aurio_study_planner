import 'package:aurio/features/journal/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JournalController()..fetchEntries(),
      child: const _JournalBody(),
    );
  }
}

class _JournalBody extends StatelessWidget {
  const _JournalBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<JournalController>();
    final TextEditingController noteCtrl = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Journal"),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDark
                                    ? Colors.black26
                                    : Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: noteCtrl,
                        maxLines: 5,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: "Reflect on your day...",
                          hintStyle: TextStyle(
                            color: theme.hintColor.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.9),
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                        ),
                        onPressed: () {
                          if (noteCtrl.text.trim().isNotEmpty) {
                            ctrl.addEntry(noteCtrl.text.trim());
                            noteCtrl.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                        icon: const Icon(Icons.edit_note),
                        label: const Text("Save Journal Entry"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        ctrl.entries.isEmpty
                            ? const Center(
                              child: Text(
                                "No entries yet. Start journaling 📝",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: ctrl.entries.length,
                              itemBuilder: (context, index) {
                                final entry = ctrl.entries[index];
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry['content'],
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            entry['created_at']
                                                .toString()
                                                .substring(0, 16),
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color:
                                                      theme
                                                          .textTheme
                                                          .bodySmall
                                                          ?.color,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
