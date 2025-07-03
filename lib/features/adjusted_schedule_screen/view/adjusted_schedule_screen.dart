import 'package:aurio/features/adjusted_schedule_screen/controller/adjusted_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdjustedScheduleScreen extends StatelessWidget {
  final List<Map<String, dynamic>> originalPlan;

  const AdjustedScheduleScreen({super.key, required this.originalPlan});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdjustedScheduleController()..loadPlan(originalPlan),
      child: const _AdjustedScheduleView(),
    );
  }
}

class _AdjustedScheduleView extends StatelessWidget {
  const _AdjustedScheduleView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AdjustedScheduleController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Adjust Schedule"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            ctrl.adjustedPlan.isEmpty
                ? const Center(child: Text("No plan to adjust."))
                : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: ctrl.adjustedPlan.length,
                        itemBuilder: (context, index) {
                          final task = ctrl.adjustedPlan[index];
                          return ListTile(
                            title: Text(
                              task['subject'],
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Row(
                              children: [
                                const Text("Duration: "),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue:
                                        task['duration_minutes'].toString(),
                                    keyboardType: TextInputType.number,
                                    enabled:
                                        task['done'] !=
                                        true, // ❌ Disable if done
                                    onChanged: (val) {
                                      final newDuration = int.tryParse(val);
                                      if (newDuration != null) {
                                        ctrl.updateDuration(index, newDuration);
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      suffixText: "min",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed:
                              ctrl.isSaving
                                  ? null
                                  : () async {
                                    await ctrl.saveAdjustedPlan();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Plan updated successfully!",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                          icon: const Icon(Icons.save),
                          label: const Text("Save"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            ctrl.revertToOriginal(ctrl.adjustedPlan);
                          },
                          child: const Text("Revert"),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
