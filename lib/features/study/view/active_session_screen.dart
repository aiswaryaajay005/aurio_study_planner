import 'package:aurio/features/study/controller/active_session_controller.dart';
import 'package:aurio/features/study/view/daily_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:aurio/features/study/controller/daily_plan_controller.dart';
import 'package:provider/provider.dart';

class ActiveSessionScreen extends StatelessWidget {
  final Map<String, dynamic> sessionData;
  const ActiveSessionScreen({super.key, required this.sessionData});

  @override
  Widget build(BuildContext context) {
    final dailyCtrl = context.read<DailyPlanController>();

    return ChangeNotifierProvider(
      create: (_) {
        final ctrl = ActiveSessionController(
          sessionData: sessionData,
          dailyCtrl: dailyCtrl,
        );
        ctrl.startTimer();
        return ctrl;
      },
      child: const _ActiveSessionBody(),
    );
  }
}

class _ActiveSessionBody extends StatelessWidget {
  const _ActiveSessionBody();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ActiveSessionController>();
    final String subject = ctrl.sessionData['subject'] ?? 'Subject';
    final int total = (ctrl.sessionData['duration_minutes'] ?? 0) * 60;
    final int remaining = ctrl.secondsRemaining;
    final double progress = total > 0 ? (total - remaining) / total : 0;
    final String formattedTime =
        "${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}";

    return WillPopScope(
      onWillPop: () async {
        final time = ctrl.timeSpent.inMinutes;
        final confirm = await _showConfirmDialog(
          context,
          "Pause Session",
          "You've studied for $time minute${time == 1 ? '' : 's'}.",
        );
        if (confirm) ctrl.pauseOrStop();
        return confirm;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Active Session"),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        // Replace the body in _ActiveSessionBody with this:
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                subject,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              if (ctrl.isPaused) ...[
                const SizedBox(height: 16),
                const Text(
                  "Session Paused",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.orange,
                  ),
                ),
              ],
              const SizedBox(height: 40),
              _actionButtonsRow1(context, ctrl),
              const SizedBox(height: 24),
              _actionButtonsRow2(context, ctrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButtonsRow1(
    BuildContext context,
    ActiveSessionController ctrl,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _sessionButton(
          context,
          icon: ctrl.isPaused ? Icons.play_arrow : Icons.pause,
          label: ctrl.isPaused ? "Resume" : "Pause",
          color: Colors.orange,
          onTap: ctrl.togglePause,
        ),
        _sessionButton(
          context,
          icon: Icons.stop,
          label: "Stop",
          color: Colors.redAccent,
          onTap: () async {
            final confirm = await _showConfirmDialog(
              context,
              "Stop Session",
              "Stop this session now? You’ll get minimal rewards.",
            );
            if (confirm) {
              await ctrl.stopSession();
              _goToSummary(context);
            }
          },
        ),
      ],
    );
  }

  Widget _actionButtonsRow2(
    BuildContext context,
    ActiveSessionController ctrl,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _sessionButton(
          context,
          icon: Icons.check_circle,
          label: "Complete",
          color: Colors.green,
          onTap: () async {
            final confirm = await _showConfirmDialog(
              context,
              "Complete Session",
              "Mark this session as completed?",
            );
            if (confirm) {
              await ctrl.completeSession();
              _goToSummary(context);
            }
          },
        ),
        _sessionButton(
          context,
          icon: Icons.add_alarm,
          label: "Extend",
          color: Colors.purple,
          onTap: () {
            ctrl.extendSessionByFiveMinutes();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("\u23F1\uFE0F Session extended by 5 minutes!"),
              ),
            );
          },
        ),
        _sessionButton(
          context,
          icon: Icons.skip_next,
          label: "Skip",
          color: Colors.blueGrey,
          onTap: () async {
            final confirm = await _showConfirmDialog(
              context,
              "Skip Session",
              "Are you sure you want to skip without any rewards?",
            );
            if (confirm) {
              await ctrl.skipSession();
              _goToSummary(context);
            }
          },
        ),
      ],
    );
  }

  void _goToSummary(BuildContext context) {
    final tasks = context.read<DailyPlanController>().todayTasks;
    final ctrl = context.read<ActiveSessionController>();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => DailySummaryScreen(
              todayTasks: tasks,
              timeSpent: ctrl.timeSpent,
            ),
      ),
    );
  }

  Widget _sessionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = Theme.of(context).colorScheme.surfaceVariant;
    final iconColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        PhysicalModel(
          color: baseColor,
          shadowColor: Colors.black.withOpacity(0.15),
          elevation: 8,
          borderRadius: BorderRadius.circular(40),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(40),
            splashColor: color.withOpacity(0.2),
            highlightColor: Colors.transparent,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.25)
                            : Colors.grey.withOpacity(0.2),
                    offset: const Offset(2, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: iconColor,
          ),
        ),
      ],
    );
  }

  Future<bool> _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
