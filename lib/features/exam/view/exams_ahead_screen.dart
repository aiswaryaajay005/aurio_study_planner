import 'dart:developer';

import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/exam/view/excam_prep_plan_list_Screen.dart';
import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:aurio/features/exam/view/add_exam_screen.dart';
import 'package:flutter/material.dart';

class ExamsAheadScreen extends StatefulWidget {
  const ExamsAheadScreen({super.key});

  @override
  State<ExamsAheadScreen> createState() => _ExamsAheadScreenState();
}

class _ExamsAheadScreenState extends State<ExamsAheadScreen> {
  Map<String, dynamic>? upcomingExam;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUpcomingExam();
  }

  Future<void> fetchUpcomingExam() async {
    final userId = SupabaseHelper.getCurrentUserId();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final data =
        await SupabaseHelper.client
            .from('exam_plans')
            .select()
            .eq('user_id', userId!) // Get only exams for logged-in user
            .gte('exam_date', today) // Only future exams
            .order('exam_date', ascending: true) // Ensure earliest comes first
            .limit(1) // Only get the earliest one
            .maybeSingle();
    log("Fetched: $data");

    setState(() {
      upcomingExam = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Exams Coming Up",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : upcomingExam == null
              ? const Center(child: Text("No upcoming exams."))
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${upcomingExam!['subject']} exam in ${_daysLeft(upcomingExam!['exam_date'])} days!",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ExamPrepPlanListScreen(
                                  examId: upcomingExam!['id'],
                                  subject: upcomingExam!['subject'],
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Start Extra Prep",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddExamScreen(),
                          ),
                        );
                        await fetchUpcomingExam();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Add New Exam",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExamScreen()),
          );
          fetchUpcomingExam(); // Refresh after adding
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  int _daysLeft(String examDate) {
    final exam = DateTime.parse(examDate);
    final now = DateTime.now();
    return exam.difference(now).inDays;
  }
}
