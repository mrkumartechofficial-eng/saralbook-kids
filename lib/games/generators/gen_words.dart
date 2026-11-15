import 'dart:math';

import '../../content/words.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';

const String _az = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

Choice _text(String s) => Choice(label: Bi.same(s));

Question genSpelling(Random r, LevelInfo info, String lang) =>
    lang == 'hi' ? _hindi(r, info) : _english(r, info);

Question _english(Random r, LevelInfo info) {
  final maxLen = min(8, 3 + (info.level - 1) ~/ 4);
  final pool = enWords.where((w) => w.word.length <= maxLen).toList();
  final w = pick(r, pool);
  final sameLen = enWords.where((x) => x.word.length == w.word.length && x.word != w.word).toList();
  final types = <int>[0, 1];
  if (info.tier >= 0.3) types.add(2);
  var t = pick(r, types);
  if (t != 0 && sameLen.length < 2) t = 0;

  if (t == 1) {
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which word matches the picture?', 'कौन-सा शब्द चित्र से मेल खाता है?'),
      stage: Visual(emoji: w.emoji),
      correct: _text(w.word),
      wrong: sameLen.map((x) => _text(x.word)).toList(),
      speak: Bi.same(w.word),
    );
  }
  if (t == 2 && w.word.length >= 4) {
    final a = r.nextInt(w.word.length);
    var b = r.nextInt(w.word.length);
    if (b == a) b = (a + 1) % w.word.length;
    final shown = [for (var i = 0; i < w.word.length; i++) (i == a || i == b) ? '_' : w.word[i]].join(' ');
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Pick the word that fits', 'सही शब्द चुनो'),
      stage: Visual(emoji: w.emoji, text: Bi.same(shown)),
      correct: _text(w.word),
      wrong: sameLen.map((x) => _text(x.word)).toList(),
    );
  }
  final idx = r.nextInt(w.word.length);
  final missing = w.word[idx];
  final shown = [for (var i = 0; i < w.word.length; i++) i == idx ? '_' : w.word[i]].join(' ');
  final wrongLetters = _az.split('').where((c) => c != missing).toList();
  return makeQuestion(
    r,
    info,
    instruction: const Bi('Which letter is missing?', 'कौन-सा अक्षर छूट गया है?'),
    stage: Visual(emoji: w.emoji, text: Bi.same(shown)),
    correct: Choice(visual: Visual(text: Bi.same(missing))),
    wrong: wrongLetters.map((c) => Choice(visual: Visual(text: Bi.same(c)))).toList(),
    speak: Bi.same(w.word),
  );
}

Question _hindi(Random r, LevelInfo info) {
  final maxUnits = min(3, 2 + (info.level - 1) ~/ 6);
  final pool = hiWords.where((w) => w.units.length <= maxUnits).toList();
  final w = pick(r, pool);
  final others = hiWords.where((x) => x.word != w.word).toList();
  final t = r.nextInt(info.tier >= 0.1 ? 2 : 1);

  if (t == 1) {
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which word matches the picture?', 'कौन-सा शब्द चित्र से मेल खाता है?'),
      stage: Visual(emoji: w.emoji),
      correct: _text(w.word),
      wrong: others.map((x) => _text(x.word)).toList(),
      speak: Bi.same(w.word),
    );
  }
  final idx = r.nextInt(w.units.length);
  final missing = w.units[idx];
  final shown = [for (var i = 0; i < w.units.length; i++) i == idx ? '_' : w.units[i]].join(' ');
  final allUnits = {for (final x in hiWords) ...x.units}.where((u) => u != missing).toList();
  return makeQuestion(
    r,
    info,
    instruction: const Bi('Which part is missing?', 'कौन-सा हिस्सा छूट गया है?'),
    stage: Visual(emoji: w.emoji, text: Bi.same(shown)),
    correct: Choice(visual: Visual(text: Bi.same(missing))),
    wrong: allUnits.map((u) => Choice(visual: Visual(text: Bi.same(u)))).toList(),
    speak: Bi.same(w.word),
  );
}
