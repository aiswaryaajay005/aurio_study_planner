import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class RewardDetailsController with ChangeNotifier {
  List<Map<String, dynamic>> rewardHistory = [];
  bool isLoading = true;

  Future<void> fetchRewardHistory() async {
    final userId = SupabaseHelper.getCurrentUserId();
    if (userId == null) return;

    try {
      isLoading = true;
      notifyListeners();

      final data = await SupabaseHelper.client
          .from('reward_history')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      rewardHistory = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("Error fetching reward history: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
