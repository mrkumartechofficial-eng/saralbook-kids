import 'package:flutter_test/flutter_test.dart';
import 'package:kids/content/numbers.dart';
import 'package:kids/models/game_id.dart';
import 'package:kids/models/level_info.dart';
import 'package:kids/services/level_engine.dart';
import 'package:kids/services/question_validator.dart';

void main() {
  const levels = [1, 10, 100, 1000, 10000];

  test('every question game builds valid levels at 1, 10, 100, 1000, 10000',
      () {
    for (final g in GameId.values) {
      if (!LevelEngine.isQuestionGame(g)) continue;
      for (final lang in ['en', 'hi']) {
        for (final lv in levels) {
          final qs = LevelEngine.build(g, lv, lang: lang);
          expect(qs.length, inInclusiveRange(6, 10), reason: '${g.name} L$lv');
          for (final q in qs) {
            expect(QuestionValidator.isValid(q), isTrue,
                reason: '${g.name} L$lv ${q.instruction.en}');
            expect(LevelEngine.isFallback(q), isFalse,
                reason: 'fallback used in ${g.name} L$lv');
          }
        }
      }
    }
  });

  test('there is no maximum level', () {
    for (final lv in [50000, 1000000]) {
      final qs = LevelEngine.build(GameId.maths, lv);
      expect(qs, isNotEmpty);
      expect(LevelInfo(lv).difficulty, Difficulty.hard);
    }
    expect(LevelEngine.memory(10000).pairs, 12);
    expect(LevelEngine.puzzle(10000).rows, greaterThanOrEqualTo(2));
  });

  test('difficulty rises gradually', () {
    expect(LevelInfo(1).difficulty, Difficulty.easy);
    expect(LevelInfo(30).difficulty, Difficulty.medium);
    expect(LevelInfo(100).difficulty, Difficulty.hard);
    expect(LevelInfo(1).tier < LevelInfo(30).tier, isTrue);
  });

  test('questions are random but repeatable for the same seed', () {
    String sig(int v) => LevelEngine.build(GameId.numbers, 50, variant: v)
        .map((q) => q.signature)
        .join('|');
    expect(sig(1), sig(1));
    expect(sig(1) == sig(2), isFalse);
  });

  test('answer positions are randomised', () {
    final positions = <int>{};
    for (var v = 0; v < 5; v++) {
      for (final q in LevelEngine.build(GameId.quiz, 20, variant: v)) {
        positions.add(q.answer);
      }
    }
    expect(positions.length, greaterThan(1));
  });

  test('maths answers are correct', () {
    final re = RegExp(r'^(\d+) ([+\-×]) (\d+) = \?$');
    var checked = 0;
    for (final lv in [1, 5, 20, 60, 200, 5000]) {
      for (var v = 0; v < 5; v++) {
        for (final q in LevelEngine.build(GameId.maths, lv, variant: v)) {
          final m = re.firstMatch(q.stage?.text?.en ?? '');
          if (m == null) continue;
          final a = int.parse(m.group(1)!);
          final b = int.parse(m.group(3)!);
          final op = m.group(2);
          final expected = op == '+' ? a + b : (op == '-' ? a - b : a * b);
          expect(q.choices[q.answer].label!.en, '$expected');
          checked++;
        }
      }
    }
    expect(checked, greaterThan(20));
  });

  test('number names in both languages', () {
    expect(hindiNumberNames.length, 101);
    expect(numName(21).hi, 'इक्कीस');
    expect(numName(45).en, 'Forty-Five');
    expect(numeral(123).hi, '१२३');
  });
}
