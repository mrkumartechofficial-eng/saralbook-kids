import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/audio/speech_service.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/game_id_ui.dart';
import '../../models/game_id.dart';
import '../../services/progress_service.dart';
import '../play/game_screen.dart';

/// Shows levels 20 at a time. The pages go on forever (no last level).
class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key, required this.game});

  final GameId game;

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen> {
  static const int perPage = 20;
  late int _page;

  @override
  void initState() {
    super.initState();
    final unlocked = context.read<ProgressService>().highestUnlocked(widget.game);
    _page = (unlocked - 1) ~/ perPage;
  }

  void _open(int level) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(game: widget.game, level: level),
      ),
    );
  }

  void _goPage(int delta) {
    setState(() {
      final p = _page + delta;
      _page = p < 0 ? 0 : p;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = context.watch<LanguageProvider>();
    final code = lang.code;
    final progress = context.watch<ProgressService>();
    final game = widget.game;
    final unlocked = progress.highestUnlocked(game);
    final first = _page * perPage + 1;
    final last = first + perPage - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: game.color,
        title: Text('${game.emoji} ${game.nameBi.of(code)}'),
        actions: [
          TextButton(
            onPressed: () => lang.toggle(),
            child: Text(l.switchLanguage,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: AppColors.ink)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: game.color.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(game.emoji, style: const TextStyle(fontSize: 44)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(UiText.howToPlay.of(code),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink)),
                        Text(game.howTo.of(code),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink)),
                      ],
                    ),
                  ),
                  IconButton(
                    iconSize: 32,
                    onPressed: () => context
                        .read<SpeechService>()
                        .speak(game.howTo.of(code), code),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: FilledButton.icon(
              onPressed: () => _open(unlocked),
              icon: const Icon(Icons.play_arrow_rounded, size: 34),
              label: Text(UiText.playLevel(unlocked).of(code),
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => _goPage(-10),
                  icon: const Icon(Icons.keyboard_double_arrow_left_rounded)),
              IconButton(
                  onPressed: () => _goPage(-1),
                  icon: const Icon(Icons.chevron_left_rounded)),
              Expanded(
                child: Text(
                  UiText.levelsRange(first, last).of(code),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink),
                ),
              ),
              IconButton(
                  onPressed: () => _goPage(1),
                  icon: const Icon(Icons.chevron_right_rounded)),
              IconButton(
                  onPressed: () => _goPage(10),
                  icon: const Icon(Icons.keyboard_double_arrow_right_rounded)),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              for (var n = first; n <= last; n++)
                _LevelTile(
                  level: n,
                  locked: n > unlocked,
                  current: n == unlocked,
                  stars: progress.starsFor(game, n),
                  color: game.color,
                  onTap: () => _open(n),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.level,
    required this.locked,
    required this.current,
    required this.stars,
    required this.color,
    required this.onTap,
  });

  final int level;
  final bool locked;
  final bool current;
  final int stars;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = locked ? Colors.grey.shade300 : (current ? color : Colors.white);
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
            color: current ? AppColors.ink : color, width: current ? 3 : 2),
      ),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onTap: locked ? null : onTap,
        child: Center(
          child: locked
              ? const Icon(Icons.lock_rounded, color: Colors.grey)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text('$level',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.ink)),
                      ),
                    ),
                    Text(
                      stars == 0 ? ' ' : '★' * stars,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.orange),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
