import 'dart:math';

import '../../content/numbers.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';

Choice _n(int n) => Choice(label: numeral(n));

List<Choice> _around(int ans, {int extra = 0}) {
  final s = <int>{};
  for (final d in [1, -1, 2, -2, 3, 10, -10, extra, -extra]) {
    final v = ans + d;
    if (v >= 0 && v != ans) s.add(v);
  }
  return s.map(_n).toList();
}

const List<String> _objs = ['🍎', '⭐', '🐟', '🎈', '🌸', '🐥'];

Question genMaths(Random r, LevelInfo info, String lang) {
  final bonus = info.level > 60 ? min(900, (info.level - 60) * 5) : 0;
  final maxSum = (5 + info.tier * 95).round() + bonus;
  final types = <String>['add', 'sub', 'compare'];
  if (info.tier >= 0.1) types.add('word');
  if (info.tier >= 0.2) {
    types.add('pattern');
    types.add('mult');
  }
  final t = pick(r, types);
  final e = pick(r, _objs);

  if (t == 'add') {
    final a = 1 + r.nextInt(maxSum - 1);
    final b = 1 + r.nextInt(maxSum - a);
    final ans = a + b;
    final visual = ans <= 10
        ? Visual(emoji: '${repeatEmoji(e, a)} + ${repeatEmoji(e, b)}', text: Bi.same('$a + $b = ?'))
        : Visual(text: Bi.same('$a + $b = ?'));
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Add the numbers', 'जोड़ो'),
      stage: visual,
      correct: _n(ans),
      wrong: _around(ans),
      hint: const Bi('Count everything together.', 'सबको मिलाकर गिनो।'),
    );
  }
  if (t == 'sub') {
    final a = 2 + r.nextInt(maxSum - 1);
    final b = 1 + r.nextInt(a - 1);
    final ans = a - b;
    final visual = a <= 10
        ? Visual(emoji: repeatEmoji(e, a), text: Bi.same('$a - $b = ?'))
        : Visual(text: Bi.same('$a - $b = ?'));
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Take away', 'घटाओ'),
      stage: visual,
      correct: _n(ans),
      wrong: _around(ans),
      hint: const Bi('Cross out some and count what is left.', 'कुछ हटाओ और जो बचे उसे गिनो।'),
    );
  }
  if (t == 'compare') {
    final top = max(8, min(maxSum, 999));
    final x = 1 + r.nextInt(top);
    var y = 1 + r.nextInt(top);
    if (y == x) y = x == top ? x - 1 : x + 1;
    final greater = r.nextBool();
    final target = greater ? max(x, y) : min(x, y);
    final other = greater ? min(x, y) : max(x, y);
    return makeQuestion(
      r,
      info,
      instruction: Bi(
        greater ? 'Which number is greater?' : 'Which number is smaller?',
        greater ? 'कौन-सी संख्या बड़ी है?' : 'कौन-सी संख्या छोटी है?',
      ),
      correct: _n(target),
      wrong: [_n(other)],
      count: 2,
    );
  }
  if (t == 'word') {
    final total = 3 + r.nextInt(max(1, min(maxSum, 20) - 2));
    final taken = 1 + r.nextInt(total - 1);
    final ans = total - taken;
    return makeQuestion(
      r,
      info,
      instruction: Bi(
        'There are $total $e. $taken are taken away. How many are left?',
        'यहाँ $total $e हैं। $taken हटा दिए गए। कितने बचे?',
      ),
      stage: total <= 10 ? Visual(emoji: repeatEmoji(e, total)) : null,
      correct: _n(ans),
      wrong: _around(ans),
    );
  }
  if (t == 'pattern') {
    final hard = info.tier >= 0.34;
    final step = hard ? 2 + r.nextInt(9) : 1 + r.nextInt(3);
    final down = hard && r.nextBool();
    final start = down ? 4 * step + 1 + r.nextInt(10) : 1 + r.nextInt(10);
    final dir = down ? -1 : 1;
    final seq = [for (var i = 0; i < 5; i++) start + dir * i * step];
    final ans = seq[4];
    return makeQuestion(
      r,
      info,
      instruction: const Bi('What comes next?', 'अगली संख्या कौन-सी है?'),
      stage: Visual(text: Bi.same('${seq.sublist(0, 4).join(', ')}, ?')),
      correct: _n(ans),
      wrong: _around(ans, extra: step),
      hint: Bi('Look at how much the numbers change each time.',
          'देखो हर बार संख्या कितनी बदलती है।'),
    );
  }
  // multiplication
  final tables = info.tier < 0.34 ? const [2, 5, 10] : const [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  final a = pick(r, tables);
  final b = 1 + r.nextInt(10);
  final ans = a * b;
  return makeQuestion(
    r,
    info,
    instruction: const Bi('Multiply', 'गुणा करो'),
    stage: Visual(text: Bi.same('$a × $b = ?')),
    correct: _n(ans),
    wrong: _around(ans, extra: a),
    hint: Bi('Add $a, $b times.', '$a को $b बार जोड़ो।'),
  );
}
