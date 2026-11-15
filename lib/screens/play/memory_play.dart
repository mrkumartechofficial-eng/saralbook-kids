import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../services/level_engine.dart';

const List<List<String>> _themes = [
  ['🐶', '🐱', '🐮', '🐴', '🐑', '🐷', '🐰', '🦁', '🐯', '🐘', '🐵', '🐻', '🦒', '🦓'],
  ['🍎', '🍌', '🥭', '🍊', '🍇', '🍉', '🍓', '🍍', '🍒', '🍑', '🍐', '🍋'],
  ['🌸', '🌻', '🌳', '🌙', '☀️', '⭐', '🌈', '🍀', '🌵', '🌷', '⛄', '🌊'],
  ['🚗', '🚌', '🚲', '🚂', '✈️', '🚢', '🚁', '🚜', '🚒', '🚑', '🚕', '🛵'],
];

/// Memory Master: flip cards and find the pairs. More pairs on higher levels.
class MemoryPlay extends StatefulWidget {
  const MemoryPlay({
    super.key,
    required this.level,
    required this.variant,
    required this.onFinish,
  });

  final int level;
  final int variant;
  final void Function(int stars, int correct, int total) onFinish;

  @override
  State<MemoryPlay> createState() => _MemoryPlayState();
}

class _MemoryPlayState extends State<MemoryPlay> {
  late final int _pairs;
  late final List<String> _faces;
  late final List<bool> _up;
  late final List<bool> _matched;
  int? _first;
  bool _busy = false;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    final params = LevelEngine.memory(widget.level, variant: widget.variant);
    _pairs = params.pairs;
    final rnd = Random(widget.level * 131 + widget.variant);
    final pool = [..._themes[params.theme]]..shuffle(rnd);
    final chosen = pool.take(_pairs).toList();
    _faces = [...chosen, ...chosen]..shuffle(rnd);
    _up = List.filled(_faces.length, false);
    _matched = List.filled(_faces.length, false);
  }

  void _tap(int i) {
    if (_busy || _up[i] || _matched[i]) return;
    setState(() => _up[i] = true);
    final f = _first;
    if (f == null) {
      _first = i;
      return;
    }
    _moves++;
    if (_faces[f] == _faces[i]) {
      setState(() {
        _matched[f] = true;
        _matched[i] = true;
      });
      _first = null;
      if (_matched.every((m) => m)) _finish();
    } else {
      _busy = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _up[f] = false;
          _up[i] = false;
          _busy = false;
        });
        _first = null;
      });
    }
  }

  void _finish() {
    final stars = _moves <= (_pairs * 1.6).ceil()
        ? 3
        : (_moves <= (_pairs * 2.6).ceil() ? 2 : 1);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      widget.onFinish(stars, _pairs, _moves);
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().code;
    final total = _faces.length;
    final cols = total <= 6 ? 3 : (total <= 12 ? 4 : (total <= 20 ? 5 : 6));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  UiText.findPairs.of(code),
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink),
                ),
              ),
              Text(
                '${UiText.moves.of(code)}: $_moves',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: cols,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.9,
            children: [
              for (var i = 0; i < total; i++)
                GestureDetector(
                  key: ValueKey('card_$i'),
                  onTap: () => _tap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _matched[i]
                          ? AppColors.mint
                          : (_up[i] ? Colors.white : AppColors.purple),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.ink, width: 2),
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            (_up[i] || _matched[i]) ? _faces[i] : '?',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: (_up[i] || _matched[i])
                                  ? AppColors.ink
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
