import 'package:aurio/shared/constants/color/color_constants.dart';
import 'package:aurio/features/home_screen/view/home_screen.dart';
import 'package:aurio/core/services/supabase_helper.dart';
import 'package:flutter/material.dart';

class StreakFreezeScreen extends StatefulWidget {
  const StreakFreezeScreen({super.key});

  @override
  State<StreakFreezeScreen> createState() => _StreakFreezeScreenState();
}

class _StreakFreezeScreenState extends State<StreakFreezeScreen> {
  int availableFreezes = 0;
  int coins = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    final user =
        await SupabaseHelper.client
            .from('user_rewards')
            .select('total_freezes_available, coins')
            .eq('user_id', userId)
            .maybeSingle();

    setState(() {
      availableFreezes = user?['total_freezes_available'] ?? 0;
      coins = user?['coins'] ?? 0;
      isLoading = false;
    });
  }

  Future<void> _useFreeze() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null || availableFreezes <= 0) return;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    await SupabaseHelper.client
        .from('users')
        .update({
          'last_streak_date': today,
          'total_freezes_available': availableFreezes - 1,
        })
        .eq('id', userId);

    await SupabaseHelper.client.from('streak_logs').insert({
      'user_id': userId,
      'date': today,
      'action': 'freeze_used',
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❄️ Freeze used! Streak saved.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _buyFreeze() async {
    if (coins < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Not enough coins! (Need 10)")),
      );
      return;
    }

    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    await SupabaseHelper.client
        .from('user_rewards')
        .update({
          'total_freezes_available': availableFreezes + 1,
          'coins': coins - 10,
        })
        .eq('user_id', userId);

    setState(() {
      availableFreezes += 1;
      coins -= 10;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("✅ Freeze purchased!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Missed a Day?")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Missed your streak?\nUse a freeze to save it!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "❄️ Available Freezes: $availableFreezes",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "💰 Coins: $coins",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: availableFreezes > 0 ? _useFreeze : null,
                          icon: const Icon(Icons.ac_unit),
                          label: const Text("Use Freeze"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                            );
                          },
                          child: const Text("Skip"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: coins >= 10 ? _buyFreeze : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade600,
                      ),
                      child: const Text("Buy Freeze (10 coins)"),
                    ),
                  ],
                ),
              ),
    );
  }
}
