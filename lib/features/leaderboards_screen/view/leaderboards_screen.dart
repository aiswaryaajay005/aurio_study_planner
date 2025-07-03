import 'package:aurio/core/services/supabase_helper.dart' show SupabaseHelper;
import 'package:aurio/features/leaderboards_screen/controller/leaderboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeaderboardController>(
        context,
        listen: false,
      ).loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LeaderboardController>();
    final leaderboard = controller.leaderboard;
    final currentUserId = SupabaseHelper.getCurrentUserId();

    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        backgroundColor: primary,
        foregroundColor: textColor,
      ),
      body:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : leaderboard.isEmpty
              ? const Center(child: Text("No leaderboard data"))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final user = leaderboard[index];
                  final isCurrentUser = user['id'] == currentUserId;
                  final isTop3 = index < 3;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            isCurrentUser
                                ? theme.colorScheme.tertiary.withOpacity(
                                  0.15,
                                ) // Light highlight
                                : isTop3
                                ? _getTop3Color(index, theme)
                                : theme.cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              isCurrentUser
                                  ? theme.colorScheme.tertiary
                                  : theme.primaryColor,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        title: Text(
                          isCurrentUser
                              ? "You"
                              : (user['full_name'] ?? "Anonymous"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                isCurrentUser
                                    ? theme.colorScheme.tertiary
                                    : theme.textTheme.bodyLarge?.color,
                          ),
                        ),

                        subtitle: Text(
                          "Total XP: ${user['total_xp']}",
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${user['weekly_xp']} XP",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            Text(
                              user['badge'],
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Color _getTop3Color(int index, ThemeData theme) {
    switch (index) {
      case 0:
        return theme.colorScheme.primary.withOpacity(0.85);
      case 1:
        return theme.colorScheme.secondary.withOpacity(0.75);
      case 2:
        return theme.primaryColorLight.withOpacity(0.7);
      default:
        return theme.cardColor;
    }
  }
}
