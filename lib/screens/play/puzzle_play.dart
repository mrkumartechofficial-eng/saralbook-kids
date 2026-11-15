import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../services/level_engine.dart';

const List<String> _pictures = [
  '🐘', '🦁', '🐯', '🐸', '🦋', '🐠', '🚗', '🚂', '✈️', '🚢', '🍎', '🍌',
  '🍉', '🍓', '🌻', '🐶',
];

const List<Color> _backgrounds = [
  Color(0xFFFFF59D),
  Color(0xFFB3E5FC),
  Color(0xFFC8E6C9),
  Color(0xFFF8BBD0),
  Color(0xFFD1C4E9),
];

/// Puzzle Planet: a picture is cut into pieces and mixed up.
/// Tap two pieces to swap them until the picture is whole again.
class PuzzlePlay extends StatefulWidget {
  const PuzzlePlay({
    super.key,
    required this.level,
    required this.variant,
    required this.onFinish,
  });

  final int level;
  final int variant;
  final void Function(int stars, int correct, int total) onFinish;

  @override
  State<PuzzlePlay> createState() => _PuzzlePlayState();
}

class _PuzzlePlayState extends State<PuzzlePlay> {
  late final int _rows;
  late final int _cols;
  late final String _emoji;
  late final Color _bg;
  late final List<int> _order;
  int? _selected;
  int _swaps = 0;
  bool _done = false;

  bool get _solved {
    for (var i = 0; i < _order.length; i++) {
      if (_order[i] != i) return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    final params = LevelEngine.puzzle(widget.level);
    _rows = params.rows;
    _cols = params.cols;
    final rnd = Random(widget.level * 977 + widget.variant);
    _emoji = _pictures[rnd.nextInt(_pictures.length)];
    _bg = _backgrounds[rnd.nextInt(_backgrounds.length)];
    final n = _rows * _cols;
    _order = List.generate(n, (i) => i);
    for (var k = 0; k < n * 3; k++) {
      final a = rnd.nextInt(n);
      final b = rnd.nextInt(n);
      final t = _order[a];
      _order[a] = _order[b];
      _order[b] = t;
    }
    if (_solved) {
      final t = _order[0];
      _order[0] = _order[1];
      _order[1] = t;
    }
  }

  void _tap(int slot) {
    if (_done) return;
    final sel = _selected;
    if (sel == null) {
      setState(() => _selected = slot);
      return;
    }
    if (sel == slot) {
      setState(() => _selected = null);
      return;
    }
    setState(() {
      final t = _order[sel];
      _order[sel] = _order[slot];
      _order[slot] = t;
      _swaps++;
      _selected = null;
    });
    if (_solved) {
      _done = true;
      final n = _rows * _cols;
      final stars = _swaps <= n * 2 ? 3 : (_swaps <= n * 4 ? 2 : 1);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        widget.onFinish(stars, n, _swaps);
      });
    }
  }

  Widget _picture(double s) {
    return Container(
      width: s,
      height: s,
      color: _bg,
      alignment: Alignment.center,
      child: Text(_emoji, style: TextStyle(fontSize: s * 0.7)),
    );
  }

  Widget _tile(int slot, double s) {
    final p = _order[slot];
    final pr = p ~/ _cols;
    final pc = p % _cols;
    final ax = 2 * pc / (_cols - 1) - 1;
    final ay = 2 * pr / (_rows - 1) - 1;
    final selected = _selected == slot;
    return GestureDetector(
      key: ValueKey('piece_$slot'),
      onTap: () => _tap(slot),
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.orange : Colors.white,
            width: selected ? 5 : 1.5,
          ),
        ),
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment(ax, ay),
            minWidth: s,
            maxWidth: s,
            minHeight: s,
            maxHeight: s,
            child: _picture(s),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().code;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.ink, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _picture(72),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UiText.puzzleTitle.of(code),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink),
                    ),
                    Text(
                      UiText.puzzleTap.of(code),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final s = max(120.0, min(c.maxWidth - 32, c.maxHeight - 16));
              return Center(
                child: SizedBox(
                  width: s,
                  height: s,
                  child: Column(
                    children: [
                      for (var r = 0; r < _rows; r++)
                        Expanded(
                          child: Row(
                            children: [
                              for (var cc = 0; cc < _cols; cc++)
                                Expanded(child: _tile(r * _cols + cc, s)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
