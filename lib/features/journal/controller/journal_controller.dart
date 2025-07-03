import 'package:flutter/material.dart';
import 'package:aurio/core/services/supabase_helper.dart';

class JournalController with ChangeNotifier {
  List<Map<String, dynamic>> entries = [];
  bool isLoading = true;

  Future<void> fetchEntries() async {
    try {
      isLoading = true;
      notifyListeners();
      final userId = SupabaseHelper.getCurrentUserId();
      final data = await SupabaseHelper.client
          .from('journal_entries')
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: false);

      entries = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("❌ Error loading journal: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(String content) async {
    try {
      final userId = SupabaseHelper.getCurrentUserId();
      await SupabaseHelper.client.from('journal_entries').insert({
        'user_id': userId,
        'content': content,
      });
      await fetchEntries();
    } catch (e) {
      print("❌ Error saving entry: $e");
    }
  }
}
