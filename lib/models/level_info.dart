import 'dart:math';

enum Difficulty { easy, medium, hard }

/// Everything about a level that depends only on its number.
/// There is NO maximum level: the number is just an int.
class LevelInfo {
  const LevelInfo(this.level);

  final int level;

  /// 0.0 (very easy) climbing smoothly towards 1.0. Every 5th level is a
  /// slightly easier "breather" level.
  double get tier {
    if (level <= 1) return 0.0;
    final base = 1 - exp(-(level - 1) / 40.0);
    final t = level % 5 == 0 ? base - 0.08 : base;
    return t < 0 ? 0.0 : t;
  }

  Difficulty get difficulty {
    final t = tier;
    if (t < 0.34) return Difficulty.easy;
    if (t < 0.67) return Difficulty.medium;
    return Difficulty.hard;
  }

  int get questionCount => 6 + (tier * 4).round();

  int get choiceCount => tier < 0.34 ? 3 : 4;
}
