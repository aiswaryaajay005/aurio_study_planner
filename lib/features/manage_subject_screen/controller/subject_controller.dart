import 'package:aurio/core/services/supabase_helper.dart';
import 'package:flutter/material.dart';

class SubjectController with ChangeNotifier {
  List<Map<String, dynamic>> subjects = [];
  bool isLoading = true;

  Future<void> fetchSubjects() async {
    isLoading = true;
    notifyListeners();

    final userId = SupabaseHelper.getCurrentUserId();
    final response =
        await SupabaseHelper.client
            .from('users')
            .select('subjects')
            .eq('id', userId!)
            .maybeSingle();

    final raw = response?['subjects'] as List<dynamic>? ?? [];
    subjects =
        raw
            .map(
              (e) => {
                'subject': e['subject'],
                'difficulty': e['difficulty'],
                'active': e['active'] ?? true,
              },
            )
            .toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addSubject(
    String name,
    String difficulty,
    BuildContext context,
  ) async {
    final userId = SupabaseHelper.getCurrentUserId();
    subjects.add({'subject': name, 'difficulty': difficulty, 'active': true});

    await SupabaseHelper.client
        .from('users')
        .update({'subjects': subjects})
        .eq('id', userId!);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Subject added")));
    notifyListeners();
  }

  Future<void> editSubject(
    BuildContext context,
    int index,
    String name,
    String difficulty,
  ) async {
    final userId = SupabaseHelper.getCurrentUserId();
    final previousSubject = Map<String, dynamic>.from(subjects[index]);

    subjects[index] = {
      'subject': name,
      'difficulty': difficulty,
      'active': true,
    };

    await SupabaseHelper.client
        .from('users')
        .update({'subjects': subjects})
        .eq('id', userId!);

    notifyListeners();

    // Show a snackbar with Undo
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Subject updated. Changes will reflect from tomorrow.",
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              subjects[index] = previousSubject;
              await SupabaseHelper.client
                  .from('users')
                  .update({'subjects': subjects})
                  .eq('id', userId);
              notifyListeners();
            },
          ),
        ),
      );
    }
  }

  Future<void> deleteSubject(int index, BuildContext context) async {
    final userId = SupabaseHelper.getCurrentUserId();
    subjects[index]['active'] = false;

    await SupabaseHelper.client
        .from('users')
        .update({'subjects': subjects})
        .eq('id', userId!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Subject removed. Changes will reflect from tomorrow."),
        duration: Duration(seconds: 3),
      ),
    );

    notifyListeners();
  }
}
