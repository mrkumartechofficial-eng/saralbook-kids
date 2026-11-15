import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../services/progress_service.dart';
import '../../services/reward_service.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().code;
    final p = context.watch<ProgressService>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppColors.yellow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 56, color: AppColors.orange),
                const SizedBox(width: 10),
                Text(
                  '${UiText.myStars.of(code)}: ${p.totalStars}',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          UiText.myBadges.of(code),
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ink),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: [
            for (final b in allBadges)
              _BadgeCard(
                emoji: b.emoji,
                title: b.title.of(code),
                how: b.how.of(code),
                earned: b.test(p),
              ),
          ],
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.emoji,
    required this.title,
    required this.how,
    required this.earned,
  });

  final String emoji;
  final String title;
  final String how;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: earned ? Colors.white : Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
            color: earned ? AppColors.orange : Colors.grey.shade400, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: earned ? 1 : 0.3,
              child: Text(emoji, style: const TextStyle(fontSize: 42)),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink),
            ),
            const SizedBox(height: 2),
            Text(
              earned ? '✅' : how,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
