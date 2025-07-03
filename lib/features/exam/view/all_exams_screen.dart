// lib/features/exam/view/all_exams_screen.dart

import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class AllExamsScreen extends StatefulWidget {
  const AllExamsScreen({super.key});

  @override
  State<AllExamsScreen> createState() => _AllExamsScreenState();
}

class _AllExamsScreenState extends State<AllExamsScreen> {
  List<Map<String, dynamic>> exams = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllExams();
  }

  Future<void> fetchAllExams() async {
    final userId = SupabaseHelper.getCurrentUserId();

    final data = await SupabaseHelper.client
        .from('exam_plans')
        .select()
        .eq('user_id', userId!)
        .order('exam_date', ascending: false);

    setState(() {
      exams = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Exams")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : exams.isEmpty
              ? const Center(child: Text("No exams found"))
              : ListView.builder(
                itemCount: exams.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  final examDate = DateTime.parse(exam['exam_date']);
                  final isPast = examDate.isBefore(DateTime.now());

                  return Card(
                    color:
                        isPast
                            ? Colors.grey.shade200
                            : Theme.of(context).cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        isPast ? Icons.check_circle : Icons.pending,
                        color: isPast ? Colors.green : Colors.orange,
                      ),
                      title: Text(exam['subject']),
                      subtitle: Text(
                        "Date: ${examDate.toLocal().toString().split(' ')[0]}",
                      ),
                      trailing: Text(isPast ? "Past" : "Upcoming"),
                    ),
                  );
                },
              ),
    );
  }
}
