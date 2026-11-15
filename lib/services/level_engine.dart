import 'dart:math';

import '../games/generators/common.dart';
import '../games/generators/gen_alphabet.dart';
import '../games/generators/gen_habits_quiz.dart';
import '../games/generators/gen_maths.dart';
import '../games/generators/gen_nature.dart';
import '../games/generators/gen_numbers.dart';
import '../games/generators/gen_shapes_colors.dart';
import '../games/generators/gen_words.dart';
import '../models/bi.dart';
import '../models/game_id.dart';
import '../models/level_info.dart';
import '../models/question.dart';
import 'question_validator.dart';

class MemoryParams {
  const MemoryParams(this.pairs, this.theme);
  final int pairs;
  final int theme;
}

class PuzzleParams {
  const PuzzleParams(this.rows, this.cols);
  final int rows;
  final int cols;
}

/// Builds any level of any game from just (game, level number).
/// Levels are not stored: they are generated, so there is no last level.
class LevelEngine {
  static final Map<GameId, QuestionGenerator> _generators = {
    GameId.alphabet: genAlphabet,
    GameId.numbers: genNumbers,
    GameId.shapes: genShapes,
    GameId.colors: genColors,
    GameId.animals: genAnimals,
    GameId.fruits: genFruits,
    GameId.maths: genMaths,
    GameId.spelling: genSpelling,
    GameId.habits: genHabits,
    GameId.quiz: genQuiz,
  };

  static const Bi fallbackInstruction = Bi('Tap the star', 'तारे को छुओ');

  static bool isQuestionGame(GameId g) => _generators.containsKey(g);

  static int _seed(GameId g, int level, int variant, String lang) =>
      ((g.index + 1) * 1000003) ^
      (level * 7919) ^
      (variant * 104729) ^
      (lang == 'hi' ? 31337 : 0);

  static List<Question> build(GameId game, int level,
      {int variant = 0, String lang = 'en'}) {
    final gen = _generators[game];
    if (gen == null) return const [];
    final info = LevelInfo(level < 1 ? 1 : level);
    final r = Random(_seed(game, info.level, variant, lang));
    final out = <Question>[];
    final seen = <String>{};
    var guard = 0;
    final limit = info.questionCount * 40;

    // Phase 1: avoid repeating the same question inside a level.
    while (out.length < info.questionCount && guard < limit) {
      guard++;
      final q = _try(gen, r, info, lang);
      if (q == null) continue;
      if (!seen.add(q.signature)) continue;
      out.add(q);
    }
    // Phase 2: small content pools: allow repeats rather than fail.
    guard = 0;
    while (out.length < info.questionCount && guard < limit) {
      guard++;
      final q = _try(gen, r, info, lang);
      if (q != null) out.add(q);
    }
    // Safety net so a level is always completable.
    while (out.length < info.questionCount) {
      out.add(fallback());
    }
    return out;
  }

  static Question? _try(
      QuestionGenerator gen, Random r, LevelInfo info, String lang) {
    try {
      final q = gen(r, info, lang);
      return QuestionValidator.isValid(q) ? q : null;
    } catch (_) {
      return null;
    }
  }

  static Question fallback() => const Question(
        instruction: fallbackInstruction,
        stage: Visual(emoji: '⭐'),
        choices: [
          Choice(visual: Visual(emoji: '⭐')),
          Choice(visual: Visual(emoji: '❤️')),
        ],
        answer: 0,
        hint: hintLook,
        speak: fallbackInstruction,
      );

  static bool isFallback(Question q) =>
      q.instruction.en == fallbackInstruction.en;

  static MemoryParams memory(int level, {int variant = 0}) {
    final info = LevelInfo(level < 1 ? 1 : level);
    final pairs = min(12, 3 + (info.level - 1) ~/ 2);
    return MemoryParams(pairs, (info.level + variant) % 4);
  }

  static PuzzleParams puzzle(int level) {
    const sizes = [
      PuzzleParams(2, 2),
      PuzzleParams(2, 3),
      PuzzleParams(3, 3),
      PuzzleParams(3, 4),
      PuzzleParams(4, 4),
    ];
    final idx = min(sizes.length - 1, ((level < 1 ? 1 : level) - 1) ~/ 4);
    return sizes[idx];
  }
}
