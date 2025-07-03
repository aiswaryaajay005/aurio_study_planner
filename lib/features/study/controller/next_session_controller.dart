import 'package:flutter/material.dart';
import 'package:aurio/features/study/controller/daily_plan_controller.dart';

class NextSessionController {
  final DailyPlanController dailyCtrl;

  NextSessionController({required this.dailyCtrl});

  Map<String, dynamic>? getNextSession() {
    final task = dailyCtrl.getNextPendingTask();
    if (task == null || task.isEmpty) return null;

    return {
      'subject': task['subject'],
      'duration_minutes': task['duration_minutes'],
      'timeRange': _calculateTimeRange(task['duration_minutes']),
    };
  }

  String _calculateTimeRange(int duration) {
    final now = DateTime.now();
    final end = now.add(Duration(minutes: duration));
    return "${_formatTime(now)} – ${_formatTime(end)}";
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final ampm = time.hour < 12 ? "a.m." : "p.m.";
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $ampm";
  }
}
