import 'package:aurio/core/services/supabase_helper.dart';
import 'package:aurio/features/study/controller/daily_summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DailySummaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> todayTasks;
  final Duration timeSpent;

  const DailySummaryScreen({
    super.key,
    required this.todayTasks,
    required this.timeSpent,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final ctrl = DailySummaryController(
          todayTasks: todayTasks,
          timeSpent: timeSpent,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await ctrl.processRewards(context);
        });
        return ctrl;
      },
      child: const _SummaryView(),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView();

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    final s = duration.inSeconds % 60;
    return '${h}h ${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DailySummaryController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Summary")),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Great job! You completed ${ctrl.tasksDone} task${ctrl.tasksDone == 1 ? '' : 's'} in ${_formatDuration(ctrl.timeSpent)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "🎯 You earned ${ctrl.xp} XP and 💰 ${ctrl.coins} coins!",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 30),

                    if (ctrl.subjectPerformanceSummary.isNotEmpty) ...[
                      const Text(
                        "📚 Subject-wise Performance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...ctrl.subjectPerformanceSummary.entries.map(
                        (entry) => Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(entry.key),
                            subtitle: Text(
                              "${entry.value['status']} - Score: ${(entry.value['score'] as double).toStringAsFixed(2)}",
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    if (ctrl.weeklyMinutes.isNotEmpty) ...[
                      const Text(
                        "🧠 Productivity Graph (Last 7 Days)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  ctrl.weeklyMinutes.length,
                                  (i) => FlSpot(
                                    i.toDouble(),
                                    ctrl.weeklyMinutes[i],
                                  ),
                                ),
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.deepPurple,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.deepPurple.withOpacity(0.3),
                                ),
                                dotData: FlDotData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    if (ctrl.tasksDone == 0)
                      const Text(
                        "Try completing at least 1 task tomorrow for bonus XP! 🎯",
                        style: TextStyle(color: Colors.redAccent),
                      ),

                    const SizedBox(height: 20),

                    // 🎉 Reward Summary Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _duoRewardCard(
                            context,
                            emoji: "⭐",
                            label: "XP Earned",
                            value: "${ctrl.xp}",
                            color: Colors.deepPurpleAccent,
                          ),
                          _duoRewardCard(
                            context,
                            emoji: "💰",
                            label: "Coins",
                            value: "${ctrl.coins}",
                            color: Colors.orange,
                          ),
                          _duoRewardCard(
                            context,
                            emoji: "🔥",
                            label: "Streak",
                            value: "${ctrl.currentStreak} Days",
                            color: Colors.redAccent,
                          ),
                          _duoRewardCard(
                            context,
                            emoji: "📅",
                            label: "Tasks",
                            value: "${ctrl.tasksDone}",
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text(
                        "Back to Dashboard",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _duoRewardCard(
    BuildContext context, {
    required String emoji,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
