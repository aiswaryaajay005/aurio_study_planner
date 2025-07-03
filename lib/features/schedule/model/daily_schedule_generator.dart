Future<List<Map<String, dynamic>>> generateDailySchedule({
  required List<Map<String, dynamic>> subjects,
  required int dailyHours,
  bool shuffle = false,
  Map<String, double>? performanceScores,
  bool useAI = false,
}) async {
  if (subjects.isEmpty || dailyHours <= 0) return [];

  if (shuffle) {
    subjects.shuffle();
  }

  final difficultyWeight = {"Easy": 1, "Medium": 2, "Hard": 3};
  final adjustedSubjects =
      subjects.map((subject) {
        final baseWeight = difficultyWeight[subject['difficulty']] ?? 1;

        if (useAI && performanceScores != null) {
          final performance = performanceScores[subject['subject']] ?? 0.8;
          final adjustmentFactor = 1.5 - performance;
          return {...subject, "adjustedWeight": baseWeight * adjustmentFactor};
        } else {
          return {...subject, "adjustedWeight": baseWeight.toDouble()};
        }
      }).toList();

  final totalWeight = adjustedSubjects.fold<double>(
    0,
    (sum, s) => sum + (s['adjustedWeight'] as double),
  );

  final totalMinutes = dailyHours * 60;
  List<Map<String, dynamic>> schedule = [];

  for (var subject in adjustedSubjects) {
    final weight = subject['adjustedWeight'] as double;
    final minutes = ((weight / totalWeight) * totalMinutes).round();

    schedule.add({
      "subject": subject['subject'],
      "difficulty": subject['difficulty'],
      "duration_minutes": minutes,
      "done": false,
    });
  }

  return schedule;
}
