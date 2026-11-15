import 'dart:math';

import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';

typedef QuestionGenerator = Question Function(
    Random r, LevelInfo info, String lang);

const Bi hintLook = Bi('Look carefully!', 'ध्यान से देखो!');

T pick<T>(Random r, List<T> src) => src[r.nextInt(src.length)];

List<T> sample<T>(Random r, List<T> src, int n) {
  final copy = [...src]..shuffle(r);
  return copy.take(n).toList();
}

String repeatEmoji(String e, int n) => List.filled(n, e).join(' ');

/// Builds a question: puts the correct choice among up to [count] choices at a
/// random position (answer positions are randomised).
Question makeQuestion(
  Random r,
  LevelInfo info, {
  required Bi instruction,
  Visual? stage,
  List<Visual>? stageSeq,
  required Choice correct,
  required List<Choice> wrong,
  Bi hint = hintLook,
  Bi? speak,
  int? count,
}) {
  final n = count ?? info.choiceCount;
  final seen = <String>{correct.key};
  final picked = <Choice>[];
  final shuffled = [...wrong]..shuffle(r);
  for (final w in shuffled) {
    if (picked.length >= n - 1) break;
    if (seen.add(w.key)) picked.add(w);
  }
  final all = [correct, ...picked]..shuffle(r);
  return Question(
    instruction: instruction,
    stage: stage,
    stageSeq: stageSeq,
    choices: all,
    answer: all.indexWhere((c) => c.key == correct.key),
    hint: hint,
    speak: speak ?? instruction,
  );
}
