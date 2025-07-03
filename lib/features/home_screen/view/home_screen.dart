import 'package:aurio/core/services/theme_service.dart';
import 'package:aurio/shared/widgets/home_carousel.dart';
import 'package:aurio/view/missed_tasks_screen/view/missed_tasks_screen.dart';
import 'package:aurio/features/analytics_screen/view/analytics_screen.dart';
import 'package:aurio/features/calender_sync_screen/view/calender_sync_screen.dart';
import 'package:aurio/features/adaptive_update_screen/view/adaptive_update_screen.dart';
import 'package:aurio/features/ai_tips/view/ai_tips.dart';
import 'package:aurio/features/study/view/daily_plan_screen.dart';
import 'package:aurio/features/exam/view/exams_ahead_screen.dart';
import 'package:aurio/features/leaderboards_screen/view/leaderboards_screen.dart';
import 'package:aurio/view/notifications_screen/view/notifications_screen.dart';
import 'package:aurio/features/journal/view/journal_Screen.dart';
import 'package:aurio/features/resurce_links/view/resource_links.dart';
import 'package:aurio/features/reward_details_screen/view/reward_details_screen.dart';
import 'package:aurio/features/streak_details_screen/view/streak_details_screen.dart';
import 'package:aurio/features/home_screen/controller/home_screen_controller.dart';
import 'package:aurio/features/task_planner_screen/view/task_planner_screen.dart';
import 'package:aurio/features/weekly_insights_screen/view/weekly_insights_screen.dart';
import 'package:aurio/core/theme/theme_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<HomeScreenController>();
      ctrl.loadSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeCtrl = context.watch<HomeScreenController>();

    final todayTasks = homeCtrl.todaySchedule.length;
    final daysUntilExam = 3;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "AURIO",
          style: GoogleFonts.italiana(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentTheme, _) {
              return IconButton(
                icon: Icon(
                  currentTheme == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  context.read<ThemeService>().toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            homeCtrl.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      homeCarousel(homeCtrl: homeCtrl),
                      const SizedBox(height: 20),

                      // ✅ Removed: _streakCard
                      _todayPlanCard(context, todayTasks),
                      const SizedBox(height: 20),

                      _examCard(context, daysUntilExam),
                      ListTile(
                        leading: const Icon(Icons.auto_fix_high),
                        title: const Text("Adaptive Suggestions"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdaptiveUpdateScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                      Text(
                        "Quick Access",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _quickButton(
                            context,
                            "Missed",
                            Icons.list_alt,
                            const MissedTasksScreen(),
                          ),
                          _quickButton(
                            context,
                            "Sreak",
                            Icons.calendar_today,
                            const StreakDetailsScreen(),
                          ),
                          _quickButton(
                            context,
                            "Rewards",
                            Icons.emoji_events,
                            const RewardDetailsScreen(),
                          ),
                          _quickButton(
                            context,
                            "Stats",
                            Icons.bar_chart,
                            const AnalyticsScreen(),
                          ),
                          _quickButton(
                            context,
                            "Leaderboard",
                            Icons.leaderboard_rounded,
                            const LeaderboardScreen(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _quickButton(
                            context,
                            "Tasks",
                            Icons.task_sharp,
                            const TaskPlannerScreen(),
                          ),
                          _quickButton(
                            context,
                            "Journal",
                            Icons.edit_note,
                            const JournalScreen(),
                          ),
                          _quickButton(
                            context,
                            "AI Tips",
                            Icons.lightbulb,
                            const AiTipsScreen(),
                          ),
                          _quickButton(
                            context,
                            "Insights",
                            Icons.insights,
                            const WeeklyInsightsScreen(),
                          ),
                          _quickButton(
                            context,
                            "Resources",
                            Icons.settings,
                            const ResourceLinksScreen(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _streakCard(BuildContext context, int streakDays) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.orange,
            size: 30,
          ),
          const SizedBox(width: 10),
          Text(
            "$streakDays-day streak!",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StreakDetailsScreen()),
              );
            },
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  Widget _todayPlanCard(BuildContext context, int todayTasks) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          "$todayTasks Tasks for Today",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DailyPlanScreen()),
          );
        },
      ),
    );
  }

  Widget _examCard(BuildContext context, int daysUntilExam) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          "Next Exam in $daysUntilExam Days",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExamsAheadScreen()),
          );
        },
      ),
    );
  }

  Widget _quickButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget targetScreen,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => targetScreen),
              ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,

            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
