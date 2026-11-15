import 'dart:math';

import '../../content/habits_quiz.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';
import 'gen_maths.dart';
import 'gen_nature.dart';
import 'gen_numbers.dart';
import 'gen_shapes_colors.dart';

Choice _habit(Habit h) => Choice(visual: Visual(emoji: h.emoji), label: h.title);

Question genHabits(Random r, LevelInfo info, String lang) {
  if (r.nextInt(3) == 0) {
    final s = pick(r, scenarios);
    return makeQuestion(
      r,
      info,
      instruction: s.question,
      correct: _habit(s.correct),
      wrong: s.wrong.map(_habit).toList(),
      hint: const Bi('Think about what keeps us safe and healthy.',
          'सोचो क्या हमें सुरक्षित और स्वस्थ रखता है।'),
    );
  }
  final good = pick(r, goodHabits);
  return makeQuestion(
    r,
    info,
    instruction: const Bi('Which is a good habit?', 'कौन-सी अच्छी आदत है?'),
    correct: _habit(good),
    wrong: badHabits.map(_habit).toList(),
    hint: const Bi('A good habit keeps us healthy and kind.',
        'अच्छी आदत हमें स्वस्थ और दयालु बनाती है।'),
  );
}

final List<QuestionGenerator> _mixers = [
  genAnimals,
  genFruits,
  genColors,
  genShapes,
  genNumbers,
  genMaths,
];

/// Half of the questions come from the verified question bank, the rest are
/// fresh variations from the other games - so levels never run out.
Question genQuiz(Random r, LevelInfo info, String lang) {
  if (r.nextInt(2) == 0) return pick(r, _mixers)(r, info, lang);
  final q = pick(r, quizBank);
  return makeQuestion(
    r,
    info,
    instruction: q.q,
    stage: q.emoji == null ? null : Visual(emoji: q.emoji),
    correct: Choice(label: q.correct),
    wrong: q.wrong.map((w) => Choice(label: w)).toList(),
  );
}
