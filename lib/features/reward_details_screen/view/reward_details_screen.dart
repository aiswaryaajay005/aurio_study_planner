import 'package:aurio/features/reward_details_screen/controller/reward_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RewardDetailsScreen extends StatelessWidget {
  const RewardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RewardDetailsController()..fetchRewardHistory(),
      child: const _RewardHistoryView(),
    );
  }
}

class _RewardHistoryView extends StatelessWidget {
  const _RewardHistoryView();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<RewardDetailsController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "🎁 My Rewards",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body:
          ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ctrl.rewardHistory.isEmpty
              ? const Center(
                child: Text(
                  "You haven't earned any rewards yet!",
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ctrl.rewardHistory.length,
                itemBuilder: (context, index) {
                  final reward = ctrl.rewardHistory[index];

                  final isCoin = reward['reward_type'] == 'coins';
                  final icon = isCoin ? Icons.attach_money : Icons.bolt;
                  final amountText =
                      '${reward['amount']} ${isCoin ? "Coins" : "XP"}';
                  final rewardDate =
                      reward['created_at']?.toString().split('T').first ??
                      'Unknown Date';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          child: Icon(
                            icon,
                            color: isCoin ? Colors.amber : Colors.lightBlue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reward['source'] ?? 'Unknown Reward',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rewardDate,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          amountText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
