import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/game_id_ui.dart';
import '../../models/game_id.dart';
import '../../services/progress_service.dart';

/// Child-friendly progress: level and stars per game.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().code;
    final p = context.watch<ProgressService>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          UiText.myProgress.of(code),
          style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.ink),
        ),
        const SizedBox(height: 10),
        for (final g in GameId.values)
          Card(
            color: g.color.withValues(alpha: 0.3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(g.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.nameBi.of(code),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.ink),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            minHeight: 10,
                            value: (p.completedLevels(g) % 10) / 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(UiText.level(p.highestUnlocked(g)).of(code),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      Text('★ ${p.starsInGame(g)}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.orange)),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
