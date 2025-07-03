import 'package:aurio/features/adaptive_update_screen/controller/adaptive_controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdaptiveUpdateScreen extends StatelessWidget {
  const AdaptiveUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdaptiveUpdateController()..loadSuggestions(),
      child: const _AdaptiveUpdateView(),
    );
  }
}

class _AdaptiveUpdateView extends StatelessWidget {
  const _AdaptiveUpdateView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AdaptiveUpdateController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Adaptive Update")),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "AI suggests changes based on your past sessions:",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...ctrl.suggestions.map(
                      (item) => ListTile(
                        leading: Icon(
                          Icons.tune,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          item,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed:
                          ctrl.isApplying
                              ? null
                              : () async {
                                await ctrl.applySuggestions();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "✅ Suggestions applied successfully.",
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context); // optional
                                }
                              },
                      child:
                          ctrl.isApplying
                              ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Apply"),
                    ),
                  ],
                ),
              ),
    );
  }
}
