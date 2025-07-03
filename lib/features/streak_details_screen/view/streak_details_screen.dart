import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurio/features/streak_details_screen/controller/streak_controller.dart';

class StreakDetailsScreen extends StatelessWidget {
  const StreakDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final ctrl = StreakController();
        ctrl.loadStreakData();
        return ctrl;
      },
      child: const _StreakBody(),
    );
  }
}

class _StreakBody extends StatelessWidget {
  const _StreakBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<StreakController>();

    if (ctrl.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🔥 My Streak"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoCard(
              icon: Icons.local_fire_department,
              title: "Current Streak",
              value: "${ctrl.currentStreak ?? 0} days",
              color: Colors.deepOrange,
            ),
            _infoCard(
              icon: Icons.emoji_events,
              title: "Longest Streak",
              value: "${ctrl.longestStreak ?? 0} days",
              color: Colors.amber.shade700,
            ),
            _infoCard(
              icon: Icons.ac_unit,
              title: "Freezes Used",
              value: "${ctrl.totalFreezesUsed}",
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            if (ctrl.freezeDates.isNotEmpty) ...[
              Text(
                "❄️ Freeze Dates",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...ctrl.freezeDates.map(
                (date) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(date ?? ""),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              "📅 Monthly Streak",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildMonthlyGrid(context, ctrl),
            const SizedBox(height: 20),
            _legendRow(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyGrid(BuildContext context, StreakController ctrl) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;
        final date = DateTime(now.year, now.month, day);
        final dateStr = date.toIso8601String().substring(0, 10);
        final action = ctrl.monthlyStreakLog[dateStr];

        Color bgColor;
        IconData icon;
        switch (action) {
          case 'continued':
            bgColor = Colors.orange;
            icon = Icons.local_fire_department;
            break;
          case 'freeze_used':
            bgColor = Colors.blue;
            icon = Icons.ac_unit;
            break;
          case 'reset':
            bgColor = Colors.red;
            icon = Icons.close;
            break;
          default:
            bgColor = Colors.grey.shade300;
            icon = Icons.remove;
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(height: 4),
                Text(
                  "$day",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _legendRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _legendBox("🔥", "Studied", Colors.orange),
        _legendBox("❄️", "Freeze", Colors.blue),
        _legendBox("❌", "Missed", Colors.red),
        _legendBox("▫", "Inactive", Colors.grey.shade300),
      ],
    );
  }

  Widget _legendBox(String emoji, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          color: color,
          margin: const EdgeInsets.only(right: 4),
        ),
        Text("$emoji $label", style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
