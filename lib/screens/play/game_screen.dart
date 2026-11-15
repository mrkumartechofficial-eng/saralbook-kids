import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/audio/speech_service.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/confetti.dart';
import '../../core/widgets/game_id_ui.dart';
import '../../core/widgets/gigi_mascot.dart';
import '../../models/game_id.dart';
import '../../models/level_info.dart';
import '../../services/progress_service.dart';
import 'memory_play.dart';
import 'puzzle_play.dart';
import 'quiz_play.dart';

/// Plays one level of one game, then shows the celebration screen.
class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.game,
    required this.level,
    this.variant,
  });

  final GameId game;
  final int level;

  /// Changes the random questions (used by tests to be repeatable).
  final int? variant;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _variant;
  Key _playKey = UniqueKey();
  bool _finished = false;
  int _stars = 1;

  @override
  void initState() {
    super.initState();
    _variant = widget.variant ?? Random().nextInt(1000000);
    final progress = context.read<ProgressService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      progress.setLast(widget.game);
    });
  }

  Future<void> _done(int stars, int correct, int total) async {
    final progress = context.read<ProgressService>();
    final code = context.read<LanguageProvider>().code;
    final speech = context.read<SpeechService>();
    await progress.completeLevel(
      widget.game,
      widget.level,
      stars: stars,
      correct: correct,
      total: total,
      lang: code,
    );
    if (!mounted) return;
    final praise = UiText.praise[stars % UiText.praise.length];
    speech.speak(praise.of(code), code);
    setState(() {
      _finished = true;
      _stars = stars;
    });
  }

  void _again() {
    setState(() {
      _finished = false;
      _variant = Random().nextInt(1000000);
      _playKey = UniqueKey();
    });
  }

  void _nextLevel() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameScreen(game: widget.game, level: widget.level + 1),
      ),
    );
  }

  Widget _play() {
    switch (widget.game) {
      case GameId.memory:
        return MemoryPlay(
            key: _playKey,
            level: widget.level,
            variant: _variant,
            onFinish: _done);
      case GameId.puzzles:
        return PuzzlePlay(
            key: _playKey,
            level: widget.level,
            variant: _variant,
            onFinish: _done);
      default:
        return QuizPlay(
            key: _playKey,
            game: widget.game,
            level: widget.level,
            variant: _variant,
            onFinish: _done);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = context.watch<LanguageProvider>();
    final code = lang.code;
    final difficulty = LevelInfo(widget.level).difficulty;
    final diffText = switch (difficulty) {
      Difficulty.easy => UiText.easy,
      Difficulty.medium => UiText.medium,
      Difficulty.hard => UiText.hard,
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.game.color,
        title: Text('${widget.game.emoji} ${UiText.level(widget.level).of(code)}'),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(diffText.of(code),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: AppColors.ink)),
            ),
          ),
          TextButton(
            onPressed: () => lang.toggle(),
            child: Text(l.switchLanguage,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: AppColors.ink)),
          ),
        ],
      ),
      body: SafeArea(
        child: _finished
            ? _LevelComplete(
                game: widget.game,
                level: widget.level,
                stars: _stars,
                code: code,
                onNext: _nextLevel,
                onAgain: _again,
                onBack: () => Navigator.of(context).pop(),
              )
            : _play(),
      ),
    );
  }
}

class _LevelComplete extends StatelessWidget {
  const _LevelComplete({
    required this.game,
    required this.level,
    required this.stars,
    required this.code,
    required this.onNext,
    required this.onAgain,
    required this.onBack,
  });

  final GameId game;
  final int level;
  final int stars;
  final String code;
  final VoidCallback onNext;
  final VoidCallback onAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: Confetti()),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GigiMascot(size: 120),
                const SizedBox(height: 8),
                Text(
                  UiText.levelComplete(level).of(code),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  UiText.praise[stars % UiText.praise.length].of(code),
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 3; i++)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 500 + i * 300),
                        curve: Curves.elasticOut,
                        builder: (context, v, child) =>
                            Transform.scale(scale: v, child: child),
                        child: Icon(
                          Icons.star_rounded,
                          size: 72,
                          color: i < stars
                              ? AppColors.yellow
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 320,
                  height: 58,
                  child: FilledButton.icon(
                    key: const ValueKey('next_level_button'),
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(UiText.nextLevel.of(code)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 320,
                  height: 52,
                  child: FilledButton.tonalIcon(
                    onPressed: onAgain,
                    icon: const Icon(Icons.replay_rounded),
                    label: Text(UiText.playAgain.of(code)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onBack,
                  child: Text(UiText.allLevels.of(code),
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
