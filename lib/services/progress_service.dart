import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/storage/prefs_store.dart';
import '../models/game_id.dart';

/// Saves levels, stars and accuracy on the device. No personal data.
/// There is no maximum level: completing level N unlocks level N+1, forever.
class ProgressService extends ChangeNotifier {
  ProgressService(this._store) {
    for (final g in GameId.values) {
      _stars[g] = _decode(_store.getString('stars_${g.name}'));
      _correct[g] = _store.getInt('correct_${g.name}') ?? 0;
      _attempts[g] = _store.getInt('attempts_${g.name}') ?? 0;
      _maxDone[g] = _stars[g]!.keys.fold<int>(0, max);
    }
    _correctEn = _store.getInt('lang_correct_en') ?? 0;
    _correctHi = _store.getInt('lang_correct_hi') ?? 0;
    final last = _store.getString('last_game');
    for (final g in GameId.values) {
      if (g.name == last) lastPlayed = g;
    }
  }

  final PrefsStore _store;
  final Map<GameId, Map<int, int>> _stars = {};
  final Map<GameId, int> _correct = {};
  final Map<GameId, int> _attempts = {};
  final Map<GameId, int> _maxDone = {};
  int _correctEn = 0;
  int _correctHi = 0;
  GameId? lastPlayed;

  static Map<int, int> _decode(String? s) {
    final m = <int, int>{};
    if (s == null || s.isEmpty) return m;
    for (final part in s.split(',')) {
      final kv = part.split(':');
      if (kv.length != 2) continue;
      final l = int.tryParse(kv[0]);
      final st = int.tryParse(kv[1]);
      if (l != null && st != null) m[l] = st;
    }
    return m;
  }

  static String _encode(Map<int, int> m) =>
      m.entries.map((e) => '${e.key}:${e.value}').join(',');

  /// The level the child should play next (highest completed + 1).
  int highestUnlocked(GameId g) => _maxDone[g]! + 1;

  int starsFor(GameId g, int level) => _stars[g]![level] ?? 0;
  int starsInGame(GameId g) => _stars[g]!.values.fold(0, (a, b) => a + b);
  int completedLevels(GameId g) => _stars[g]!.length;
  int get totalStars =>
      GameId.values.fold(0, (sum, g) => sum + starsInGame(g));
  int get correctEnglish => _correctEn;
  int get correctHindi => _correctHi;

  /// Accuracy 0..100 (first-try correct answers / questions).
  int accuracy(GameId g) {
    final a = _attempts[g]!;
    if (a == 0) return 0;
    return ((_correct[g]! * 100) / a).round().clamp(0, 100);
  }

  Future<void> setLast(GameId g) async {
    lastPlayed = g;
    notifyListeners();
    await _store.setString('last_game', g.name);
  }

  Future<void> completeLevel(
    GameId g,
    int level, {
    required int stars,
    required int correct,
    required int total,
    required String lang,
  }) async {
    final s = stars.clamp(1, 3);
    final map = _stars[g]!;
    if ((map[level] ?? 0) < s) map[level] = s;
    _maxDone[g] = max(_maxDone[g]!, level);
    _correct[g] = _correct[g]! + correct;
    _attempts[g] = _attempts[g]! + total;
    if (lang == 'hi') {
      _correctHi += correct;
    } else {
      _correctEn += correct;
    }
    notifyListeners();
    await _store.setString('stars_${g.name}', _encode(map));
    await _store.setInt('correct_${g.name}', _correct[g]!);
    await _store.setInt('attempts_${g.name}', _attempts[g]!);
    await _store.setInt('lang_correct_en', _correctEn);
    await _store.setInt('lang_correct_hi', _correctHi);
  }

  Future<void> resetAll() async {
    for (final g in GameId.values) {
      _stars[g] = {};
      _correct[g] = 0;
      _attempts[g] = 0;
      _maxDone[g] = 0;
      await _store.remove('stars_${g.name}');
      await _store.remove('correct_${g.name}');
      await _store.remove('attempts_${g.name}');
    }
    _correctEn = 0;
    _correctHi = 0;
    lastPlayed = null;
    await _store.remove('lang_correct_en');
    await _store.remove('lang_correct_hi');
    await _store.remove('last_game');
    notifyListeners();
  }
}

/// Stars for a finished level from first-try accuracy.
int starsFromAccuracy(int firstTryCorrect, int total) {
  if (total <= 0) return 1;
  final ratio = firstTryCorrect / total;
  if (ratio >= 0.9) return 3;
  if (ratio >= 0.6) return 2;
  return 1;
}
