import 'dart:math';

import '../../content/alphabet.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';

Question genAlphabet(Random r, LevelInfo info, String lang) =>
    lang == 'hi' ? _hindi(r, info) : _english(r, info);

Choice _letter(String s) => Choice(visual: Visual(text: Bi.same(s)));

Choice _pic(String emoji, String word) =>
    Choice(visual: Visual(emoji: emoji), label: Bi.same(word));

Question _english(Random r, LevelInfo info) {
  final size = min(enLetters.length, 6 + (info.level - 1) * 2);
  final pool = enLetters.sublist(0, size);
  final pics = pool.where((e) => e.emoji != null).toList();
  final types = <int>[0, 1];
  if (info.tier >= 0.2) types.add(2);
  if (info.tier >= 0.34) types.add(3);
  var t = pick(r, types);
  if ((t == 1 || t == 2) && pics.length < 3) t = 0;

  if (t == 1) {
    final e = pick(r, pics);
    return makeQuestion(
      r,
      info,
      instruction: Bi('${e.word} starts with which letter?',
          '${e.word} किस अक्षर से शुरू होता है?'),
      stage: Visual(emoji: e.emoji, text: Bi.same(e.word!)),
      correct: _letter(e.letter),
      wrong: pool.where((x) => x.letter != e.letter).map((x) => _letter(x.letter)).toList(),
    );
  }
  if (t == 2) {
    final e = pick(r, pics);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Which picture starts with ${e.letter}?',
          '${e.letter} से शुरू होने वाला चित्र कौन-सा है?'),
      stage: Visual(text: Bi.same(e.letter)),
      correct: _pic(e.emoji!, e.word!),
      wrong: pics.where((x) => x.letter != e.letter).map((x) => _pic(x.emoji!, x.word!)).toList(),
    );
  }
  if (t == 3) {
    final start = r.nextInt(size - 3);
    final seq = pool.sublist(start, start + 4);
    final m = r.nextInt(4);
    final shown = [for (var i = 0; i < 4; i++) i == m ? '_' : seq[i].letter].join('  ');
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which letter is missing?', 'कौन-सा अक्षर छूट गया है?'),
      stage: Visual(text: Bi.same(shown)),
      correct: _letter(seq[m].letter),
      wrong: pool.where((x) => x.letter != seq[m].letter).map((x) => _letter(x.letter)).toList(),
      hint: const Bi('Sing the ABC song!', 'ABC गाना गाओ!'),
    );
  }
  final target = pick(r, pool);
  return makeQuestion(
    r,
    info,
    instruction: Bi('Find the letter ${target.letter}', 'अक्षर ${target.letter} को खोजो'),
    correct: _letter(target.letter),
    wrong: pool.where((x) => x.letter != target.letter).map((x) => _letter(x.letter)).toList(),
  );
}

Question _hindi(Random r, LevelInfo info) {
  final size = min(hiLetters.length, 6 + (info.level - 1) * 2);
  final pool = hiLetters.sublist(0, size);
  final pics = pool.where((e) => e.emoji != null).toList();
  final types = <int>[0, 1];
  if (info.tier >= 0.2) types.add(2);
  if (info.tier >= 0.34) types.add(3);
  var t = pick(r, types);
  if ((t == 1 || t == 2) && pics.length < 3) t = 0;

  if (t == 1) {
    final e = pick(r, pics);
    return makeQuestion(
      r,
      info,
      instruction: Bi('${e.word} starts with which letter?',
          '${e.word} किस अक्षर से शुरू होता है?'),
      stage: Visual(emoji: e.emoji, text: Bi.same(e.word!)),
      correct: _letter(e.letter),
      wrong: pool.where((x) => x.letter != e.letter).map((x) => _letter(x.letter)).toList(),
    );
  }
  if (t == 2) {
    final e = pick(r, pics);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Which picture starts with ${e.letter}?',
          '${e.letter} से शुरू होने वाला चित्र कौन-सा है?'),
      stage: Visual(text: Bi.same(e.letter)),
      correct: _pic(e.emoji!, e.word!),
      wrong: pics.where((x) => x.letter != e.letter).map((x) => _pic(x.emoji!, x.word!)).toList(),
    );
  }
  if (t == 3) {
    final start = r.nextInt(size - 3);
    final seq = pool.sublist(start, start + 4);
    final m = r.nextInt(4);
    final shown = [for (var i = 0; i < 4; i++) i == m ? '_' : seq[i].letter].join('  ');
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which letter is missing?', 'कौन-सा अक्षर छूट गया है?'),
      stage: Visual(text: Bi.same(shown)),
      correct: _letter(seq[m].letter),
      wrong: pool.where((x) => x.letter != seq[m].letter).map((x) => _letter(x.letter)).toList(),
    );
  }
  final target = pick(r, pool);
  return makeQuestion(
    r,
    info,
    instruction: Bi('Find the letter ${target.letter}', 'अक्षर ${target.letter} को खोजो'),
    correct: _letter(target.letter),
    wrong: pool.where((x) => x.letter != target.letter).map((x) => _letter(x.letter)).toList(),
  );
}
