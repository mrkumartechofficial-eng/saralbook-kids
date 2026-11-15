import 'dart:math';

import '../../content/numbers.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';

Choice numChoice(int n) => Choice(label: numeral(n));

/// Numbers near [n] inside [lo]..[hi] (never n itself).
List<int> nearNumbers(Random r, int n, int lo, int hi) {
  final s = <int>{};
  for (final d in const [1, -1, 2, -2, 3, -3, 10, -10]) {
    final v = n + d;
    if (v >= lo && v <= hi && v != n) s.add(v);
  }
  var guard = 0;
  while (s.length < 5 && guard++ < 60) {
    final v = lo + r.nextInt(hi - lo + 1);
    if (v != n) s.add(v);
  }
  return s.toList();
}

const List<String> _countEmoji = ['🍎', '⭐', '🐟', '🎈', '🚗', '🌸', '🐥', '⚽'];

Question genNumbers(Random r, LevelInfo info, String lang) {
  final maxN = min(1000, 5 + info.level * 2);
  final types = <int>[0, 1, 2];
  if (info.tier >= 0.15) types.add(3);
  if (info.level >= 2) types.add(4);
  if (info.tier >= 0.34) types.add(5);
  final t = pick(r, types);

  if (t == 0) {
    final countMax = min(20, 3 + info.level ~/ 2);
    final n = 1 + r.nextInt(countMax);
    final e = pick(r, _countEmoji);
    return makeQuestion(
      r,
      info,
      instruction: const Bi('How many are there?', 'कितने हैं?'),
      stage: Visual(emoji: repeatEmoji(e, n)),
      correct: numChoice(n),
      wrong: nearNumbers(r, n, 1, max(countMax + 2, 6)).map(numChoice).toList(),
      hint: const Bi('Count one by one with your finger.', 'उँगली से एक-एक करके गिनो।'),
    );
  }
  if (t == 1) {
    final n = 1 + r.nextInt(min(maxN, 100));
    final nm = numName(n);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Find the number ${nm.en}', 'संख्या ${nm.hi} खोजो'),
      correct: numChoice(n),
      wrong: nearNumbers(r, n, 1, max(maxN, 8)).map(numChoice).toList(),
    );
  }
  if (t == 2) {
    var step = 1;
    if (info.tier >= 0.34) step = pick(r, const [1, 2, 5, 10]);
    if (maxN < 1 + 3 * step) step = 1;
    final start = 1 + r.nextInt(max(1, maxN - 3 * step));
    final seq = [for (var i = 0; i < 4; i++) start + i * step];
    final m = r.nextInt(4);
    final shown = [for (var i = 0; i < 4; i++) i == m ? '_' : '${seq[i]}'].join(',  ');
    final ans = seq[m];
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which number is missing?', 'कौन-सी संख्या छूट गई है?'),
      stage: Visual(text: Bi.same(shown)),
      correct: numChoice(ans),
      wrong: nearNumbers(r, ans, 1, max(maxN + 3 * step, 10)).map(numChoice).toList(),
      hint: Bi('The numbers go up by $step.', 'संख्याएँ हर बार $step बढ़ती हैं।'),
    );
  }
  if (t == 3) {
    final k = info.choiceCount;
    final s = <int>{};
    while (s.length < k) {
      s.add(1 + r.nextInt(maxN));
    }
    final list = s.toList();
    final bigger = r.nextBool();
    final target = bigger ? list.reduce(max) : list.reduce(min);
    return makeQuestion(
      r,
      info,
      instruction: Bi(
        bigger ? 'Which number is the biggest?' : 'Which number is the smallest?',
        bigger ? 'सबसे बड़ी संख्या कौन-सी है?' : 'सबसे छोटी संख्या कौन-सी है?',
      ),
      correct: numChoice(target),
      wrong: list.where((x) => x != target).map(numChoice).toList(),
      count: k,
    );
  }
  if (t == 4) {
    final n = 1 + r.nextInt(min(10, maxN));
    final e = pick(r, _countEmoji);
    Choice group(int k) => Choice(visual: Visual(emoji: repeatEmoji(e, k)));
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which group matches this number?',
          'कौन-सा समूह इस संख्या से मेल खाता है?'),
      stage: Visual(text: numeral(n)),
      correct: group(n),
      wrong: nearNumbers(r, n, 1, 10).map(group).toList(),
    );
  }
  // t == 5: what comes after / before
  final after = r.nextBool();
  final n = after ? 1 + r.nextInt(maxN - 1) : 2 + r.nextInt(maxN - 1);
  final ans = after ? n + 1 : n - 1;
  return makeQuestion(
    r,
    info,
    instruction: Bi(
      after ? 'What comes after $n?' : 'What comes before $n?',
      after ? '$n के बाद कौन-सी संख्या आती है?' : '$n से पहले कौन-सी संख्या आती है?',
    ),
    correct: numChoice(ans),
    wrong: nearNumbers(r, ans, 1, maxN + 2).map(numChoice).toList(),
  );
}
