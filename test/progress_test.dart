import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/storage/prefs_store.dart';
import 'package:kids/models/game_id.dart';
import 'package:kids/services/progress_service.dart';
import 'package:kids/services/reward_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('completing a level unlocks the next one, forever', () async {
    final p = ProgressService(await PrefsStore.create());
    expect(p.highestUnlocked(GameId.numbers), 1);
    await p.completeLevel(GameId.numbers, 1,
        stars: 2, correct: 5, total: 6, lang: 'en');
    expect(p.highestUnlocked(GameId.numbers), 2);
    await p.completeLevel(GameId.numbers, 10000,
        stars: 3, correct: 6, total: 6, lang: 'hi');
    expect(p.highestUnlocked(GameId.numbers), 10001);
  });

  test('best stars are kept when replaying', () async {
    final p = ProgressService(await PrefsStore.create());
    await p.completeLevel(GameId.shapes, 1,
        stars: 3, correct: 6, total: 6, lang: 'en');
    await p.completeLevel(GameId.shapes, 1,
        stars: 1, correct: 2, total: 6, lang: 'en');
    expect(p.starsFor(GameId.shapes, 1), 3);
    expect(p.highestUnlocked(GameId.shapes), 2);
  });

  test('progress survives closing and re-opening the app', () async {
    final a = ProgressService(await PrefsStore.create());
    await a.completeLevel(GameId.colors, 7,
        stars: 2, correct: 4, total: 6, lang: 'hi');
    final b = ProgressService(await PrefsStore.create());
    expect(b.highestUnlocked(GameId.colors), 8);
    expect(b.totalStars, 2);
    expect(b.correctHindi, 4);
    expect(b.accuracy(GameId.colors), 67);
  });

  test('star calculation', () {
    expect(starsFromAccuracy(6, 6), 3);
    expect(starsFromAccuracy(4, 6), 2);
    expect(starsFromAccuracy(1, 6), 1);
  });

  test('badges unlock from progress', () async {
    final p = ProgressService(await PrefsStore.create());
    expect(RewardService.earned(p), isEmpty);
    for (var l = 1; l <= 5; l++) {
      await p.completeLevel(GameId.alphabet, l,
          stars: 3, correct: 6, total: 6, lang: 'en');
    }
    final ids = RewardService.earned(p).map((b) => b.id).toList();
    expect(ids, contains('first_star'));
    expect(ids, contains('abc'));
  });

  test('reset clears everything', () async {
    final p = ProgressService(await PrefsStore.create());
    await p.completeLevel(GameId.maths, 3,
        stars: 3, correct: 6, total: 6, lang: 'en');
    await p.resetAll();
    expect(p.totalStars, 0);
    expect(p.highestUnlocked(GameId.maths), 1);
  });
}
