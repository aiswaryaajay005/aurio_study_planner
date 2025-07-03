import 'package:aurio/features/analytics_screen/controller/analytics_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsController()..loadAnalytics(),
      child: const _AnalyticsView(),
    );
  }
}

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AnalyticsController>();
    final theme = Theme.of(context);

    // Replace with actual logic if needed
    final weeklyMinutes = ctrl.getTotalMinutes('Weekly');
    final monthlyMinutes = ctrl.getTotalMinutes('Monthly');
    final overallMinutes = ctrl.getTotalMinutes('Overall');

    // Targets (you can customize)
    const weeklyTarget = 600; // 10 hours
    const monthlyTarget = 2400; // 40 hours
    const overallTarget = 10000; // e.g. all-time goal

    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Study Analytics"),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCircularIndicator(
                          context,
                          label: "📅 Weekly Study Time",
                          minutes: weeklyMinutes.toInt(),
                          target: weeklyTarget,
                        ),
                        const SizedBox(height: 32),
                        _buildCircularIndicator(
                          context,
                          label: "📆 Monthly Study Time",
                          minutes: monthlyMinutes.toInt(),
                          target: monthlyTarget,
                        ),
                        const SizedBox(height: 32),
                        _buildCircularIndicator(
                          context,
                          label: "📈 Overall Study Time",
                          minutes: overallMinutes.toInt(),
                          target: overallTarget,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildCircularIndicator(
    BuildContext context, {
    required String label,
    required int minutes,
    required int target,
  }) {
    final theme = Theme.of(context);
    final percent = (minutes / target).clamp(0.0, 1.0);
    final hours = (minutes / 60).toStringAsFixed(1);
    final totalHours = (target / 60).toStringAsFixed(1);

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        CircularPercentIndicator(
          radius: 85,
          lineWidth: 14,
          percent: percent,
          animation: true,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: theme.colorScheme.secondary,
          backgroundColor: theme.primaryColorLight.withOpacity(0.3),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(percent * 100).round()}%",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$hours / $totalHours hrs",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
