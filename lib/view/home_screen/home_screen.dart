import 'package:aurio/global_constants/color/color_constants.dart';
import 'package:aurio/view/analytics_screen/analytics_screen.dart';
import 'package:aurio/view/calender_screen/calender_screen.dart';
import 'package:aurio/view/calender_sync_screen/calender_sync_screen.dart';
import 'package:aurio/view/daily_plan_screen/daily_plan_screen.dart';
import 'package:aurio/view/exams_ahead_screen/exams_ahead_screen.dart';
import 'package:aurio/view/leaderboards_screen/leaderboards_screen.dart';
import 'package:aurio/view/notifications_screen/notifications_screen.dart';
import 'package:aurio/view/reward_details_screen/reward_details_screen.dart';
import 'package:aurio/view/rewards_screen/rewards_screen.dart';
import 'package:aurio/view/streak_details_screen/streak_details_screen.dart';
import 'package:aurio/view/study_plan_screen/study_plan_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userName = "John";
    final int streakDays = 5;
    final int todayTasks = 2;
    final int daysUntilExam = 3;

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome
              Row(
                children: [
                  Text(
                    "Hi, $userName 👋",
                    style: TextStyle(
                      fontSize: 26,
                      color: ColorConstants.accentColor,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: ColorConstants.accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Streak
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "$streakDays-day streak!",
                      style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StreakDetailsScreen(),
                          ),
                        );
                      },
                      child: const Text("View"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Today's Plan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    "$todayTasks Tasks for Today",
                    style: TextStyle(
                      color: ColorConstants.textColor,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: ColorConstants.accentColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DailyPlanScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Next Exam
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    "Next Exam in $daysUntilExam Days",
                    style: TextStyle(
                      color: ColorConstants.textColor,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: ColorConstants.accentColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExamsAheadScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Quick Access Buttons
              Text(
                "Quick Access",
                style: TextStyle(color: ColorConstants.textColor, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickButton(
                    context,
                    "Plan",
                    Icons.list_alt,
                    const StudyPlanScreen(),
                  ),
                  _quickButton(
                    context,
                    "Calendar",
                    Icons.calendar_today,
                    const CalendarSyncScreen(),
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
                    Icons.leaderboard,

                    const LeaderboardScreen(),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              color: ColorConstants.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: ColorConstants.accentColor),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(color: ColorConstants.textColor, fontSize: 14),
        ),
      ],
    );
  }
}
