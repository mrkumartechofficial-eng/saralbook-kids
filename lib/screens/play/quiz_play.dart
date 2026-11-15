import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/audio/speech_service.dart';
import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gigi_mascot.dart';
import '../../core/widgets/visual_view.dart';
import '../../models/bi.dart';
import '../../models/game_id.dart';
import '../../models/question.dart';
import '../../services/level_engine.dart';
import '../../services/progress_service.dart';

/// Plays a level made of "pick the right answer" questions.
/// Used by 10 of the 12 games.
class QuizPlay extends StatefulWidget {
  const QuizPlay({
    super.key,
    required this.game,
    required this.level,
    required this.variant,
    required this.onFinish,
  });

  final GameId game;
  final int level;
  final int variant;
  final void Function(int stars, int correct, int total) onFinish;

  @override
  State<QuizPlay> createState() => _QuizPlayState();
}

class _QuizPlayState extends State<QuizPlay> {
  late final List<Question> _questions;
  int _index = 0;
  int _wrongTaps = 0;
  int _firstTry = 0;
  bool _answered = false;
  bool _revealed = false;
  final Set<int> _wrong = {};
  Bi? _message;
  bool _messageGood = false;

  @override
  void initState() {
    super.initState();
    final code = context.read<LanguageProvider>().code;
    _questions = LevelEngine.build(widget.game, widget.level,
        variant: widget.variant, lang: code);
  }

  void _tap(int i) {
    if (_answered) return;
    final q = _questions[_index];
    final speech = context.read<SpeechService>();
    final code = context.read<LanguageProvider>().code;
    if (i == q.answer) {
      final praise = UiText.praise[(_index + _firstTry) % UiText.praise.length];
      setState(() {
        _answered = true;
        if (_wrongTaps == 0) _firstTry++;
        _message = praise;
        _messageGood = true;
      });
      speech.speak(praise.of(code), code);
    } else {
      setState(() {
        _wrongTaps++;
        _wrong.add(i);
        _message = UiText.tryAgain;
        _messageGood = false;
        if (_wrongTaps >= 3) {
          _answered = true;
          _revealed = true;
        }
      });
      speech.speak(UiText.tryAgain.of(code), code);
    }
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      widget.onFinish(
        starsFromAccuracy(_firstTry, _questions.length),
        _firstTry,
        _questions.length,
      );
      return;
    }
    setState(() {
      _index++;
      _wrongTaps = 0;
      _answered = false;
      _revealed = false;
      _wrong.clear();
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().code;
    final q = _questions[_index];
    final isLast = _index + 1 >= _questions.length;
    final showHint = _wrongTaps >= 2 && !_answered;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: (_index + (_answered ? 1 : 0)) / _questions.length,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        q.instruction.of(code),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('speak_button'),
                      iconSize: 34,
                      onPressed: () => context
                          .read<SpeechService>()
                          .speak(q.speak.of(code), code),
                      icon: const Icon(Icons.volume_up_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _Stage(q: q, code: code),
                const SizedBox(height: 18),
                LayoutBuilder(
                  builder: (context, c) {
                    final w = (min(c.maxWidth, 560.0) - 14) / 2;
                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        for (var i = 0; i < q.choices.length; i++)
                          _ChoiceTile(
                            key: ValueKey('choice_$i'),
                            choice: q.choices[i],
                            width: w,
                            lang: code,
                            state: (_answered && i == q.answer)
                                ? (_revealed ? 3 : 1)
                                : (_wrong.contains(i) ? 2 : 0),
                            onTap: () => _tap(i),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 14),
                if (_message != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GigiMascot(size: 52, animate: false),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _message!.of(code),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: _messageGood
                                ? Colors.green.shade700
                                : Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (showHint)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '💡 ${q.hint.of(code)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
              key: const ValueKey('next_button'),
              onPressed: _answered ? _next : null,
              child: Text((isLast ? UiText.finish : UiText.next).of(code)),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({required this.q, required this.code});

  final Question q;
  final String code;

  @override
  Widget build(BuildContext context) {
    final seq = q.stageSeq;
    if (seq != null) {
      return Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final v in seq) VisualView(v, size: 56, lang: code),
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.ink, width: 3),
            ),
            child: const Text('?',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink)),
          ),
        ],
      );
    }
    if (q.stage != null) {
      return VisualView(q.stage!, size: 110, lang: code);
    }
    return const SizedBox.shrink();
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    super.key,
    required this.choice,
    required this.width,
    required this.lang,
    required this.state,
    required this.onTap,
  });

  final Choice choice;
  final double width;
  final String lang;

  /// 0 normal, 1 correct, 2 wrong, 3 revealed correct
  final int state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg = switch (state) {
      1 || 3 => const Color(0xFFB9F6CA),
      2 => const Color(0xFFFFE0B2),
      _ => Colors.white,
    };
    final Color border = switch (state) {
      1 || 3 => Colors.green,
      2 => Colors.deepOrange,
      _ => AppColors.purple,
    };
    final label = choice.label?.of(lang);
    final hasVisual = choice.visual != null;
    final fontSize = hasVisual ? 17.0 : ((label?.length ?? 0) > 10 ? 20.0 : 30.0);

    return SizedBox(
      width: width,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: border, width: 3),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 110),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasVisual)
                    VisualView(choice.visual!, size: 56, lang: lang),
                  if (label != null)
                    Padding(
                      padding: EdgeInsets.only(top: hasVisual ? 4 : 0),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
