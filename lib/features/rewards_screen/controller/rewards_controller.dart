import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class RewardsController with ChangeNotifier {
  int coins = 0;
  bool isLoading = true;

  Future<void> fetchUserCoins() async {
    final userId = SupabaseHelper.getCurrentUserId();
    try {
      final data =
          await SupabaseHelper.client
              .from('user_rewards')
              .select('coins')
              .eq('user_id', userId!)
              .maybeSingle();

      coins = data?['coins'] ?? 0;
    } catch (e) {
      print("Error fetching coins: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> claimStreakFreeze() async {
    if (coins < 10) return false;

    final userId = SupabaseHelper.getCurrentUserId();
    coins -= 10;

    try {
      await SupabaseHelper.client
          .from('user_rewards')
          .update({'coins': coins})
          .eq('user_id', userId!);

      notifyListeners();
      return true;
    } catch (e) {
      print("Claim error: $e");
      return false;
    }
  }

  int xp = 0;
  List<Map<String, dynamic>> rewardHistory = [];

  Future<void> fetchUserStats() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    final data =
        await SupabaseHelper.client
            .from('user_rewards')
            .select('coins, total_xp')
            .eq('user_id', userId)
            .maybeSingle();

    coins = data?['coins'] ?? 0;
    xp = data?['total_xp'] ?? 0;
    notifyListeners();
  }

  Future<void> fetchRewardHistory() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    final logs = await SupabaseHelper.client
        .from('reward_history')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);

    rewardHistory = List<Map<String, dynamic>>.from(logs);
    notifyListeners();
  }
}
