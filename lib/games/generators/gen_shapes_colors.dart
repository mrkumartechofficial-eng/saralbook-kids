import 'dart:math';

import '../../content/nature.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';

Choice _shapeChoice(ShapeItem s) => Choice(visual: Visual(shape: s.kind));
Choice _shapeName(ShapeItem s) => Choice(label: s.name);
Choice _colorSwatch(ColorItem c) => Choice(visual: Visual(color: c.argb));
Choice _colorName(ColorItem c) => Choice(label: c.name);

Question genShapes(Random r, LevelInfo info, String lang) {
  final n = min(shapeItems.length, 3 + (info.level - 1) ~/ 2);
  final pool = shapeItems.sublist(0, n);
  final types = <int>[0, 1, 2];
  if (info.tier >= 0.2 && n >= 4) types.add(3);
  var t = pick(r, types);

  final kinds = pool.map((s) => s.kind).toSet();
  final objs = shapeObjects.where((o) => kinds.contains(o.kind)).toList();
  if (t == 2 && objs.isEmpty) t = 0;

  if (t == 0) {
    final s = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: const Bi('What shape is this?', 'यह कौन-सी आकृति है?'),
      stage: Visual(shape: s.kind),
      correct: _shapeName(s),
      wrong: pool.where((x) => x != s).map(_shapeName).toList(),
    );
  }
  if (t == 1) {
    final s = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Find the ${s.en}', '${s.hi} को खोजो'),
      correct: _shapeChoice(s),
      wrong: pool.where((x) => x != s).map(_shapeChoice).toList(),
    );
  }
  if (t == 2) {
    final o = pick(r, objs);
    final s = pool.firstWhere((x) => x.kind == o.kind);
    return makeQuestion(
      r,
      info,
      instruction: Bi('The ${o.en} has which shape?', '${o.hi} किस आकृति का है?'),
      stage: Visual(emoji: o.emoji),
      correct: _shapeChoice(s),
      wrong: pool.where((x) => x != s).map(_shapeChoice).toList(),
    );
  }
  // pattern
  final three = info.tier >= 0.34 && n >= 5;
  final picks = sample(r, pool, three ? 3 : 2);
  const col = 0xFF7E57C2;
  Visual v(ShapeItem s) => Visual(shape: s.kind, color: col);
  final seq = three
      ? [v(picks[0]), v(picks[1]), v(picks[2]), v(picks[0]), v(picks[1])]
      : [v(picks[0]), v(picks[1]), v(picks[0]), v(picks[1])];
  final ans = three ? picks[2] : picks[0];
  return makeQuestion(
    r,
    info,
    instruction: const Bi('Which shape comes next?', 'अगली आकृति कौन-सी है?'),
    stageSeq: seq,
    correct: Choice(visual: v(ans)),
    wrong: pool.where((x) => x != ans).map((s) => Choice(visual: v(s))).toList(),
    hint: const Bi('The shapes repeat again and again.', 'आकृतियाँ बार-बार दोहराई जाती हैं।'),
  );
}

Question genColors(Random r, LevelInfo info, String lang) {
  final n = min(colorItems.length, 4 + (info.level - 1) ~/ 2);
  final pool = colorItems.sublist(0, n);
  final types = <int>[0, 1, 2];
  if (info.tier >= 0.2 && n >= 4) types.add(3);
  var t = pick(r, types);

  final ids = pool.map((c) => c.id).toSet();
  final objs = coloredObjects.where((o) => ids.contains(o.colorId)).toList();
  if (t == 2 && objs.isEmpty) t = 0;

  if (t == 0) {
    final c = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: const Bi('What colour is this?', 'यह कौन-सा रंग है?'),
      stage: Visual(color: c.argb),
      correct: _colorName(c),
      wrong: pool.where((x) => x != c).map(_colorName).toList(),
    );
  }
  if (t == 1) {
    final c = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Find the colour ${c.en}', '${c.hi} रंग खोजो'),
      correct: _colorSwatch(c),
      wrong: pool.where((x) => x != c).map(_colorSwatch).toList(),
    );
  }
  if (t == 2) {
    final o = pick(r, objs);
    final c = colorItems.firstWhere((x) => x.id == o.colorId);
    return makeQuestion(
      r,
      info,
      instruction: Bi('What colour is the ${o.en}?', '${o.hi} का रंग कौन-सा है?'),
      stage: Visual(emoji: o.emoji),
      correct: _colorSwatch(c),
      wrong: pool.where((x) => x != c).map(_colorSwatch).toList(),
    );
  }
  final three = info.tier >= 0.34 && n >= 5;
  final picks = sample(r, pool, three ? 3 : 2);
  final seq = three
      ? [picks[0], picks[1], picks[2], picks[0], picks[1]]
      : [picks[0], picks[1], picks[0], picks[1]];
  final ans = three ? picks[2] : picks[0];
  return makeQuestion(
    r,
    info,
    instruction: const Bi('Which colour comes next?', 'अगला रंग कौन-सा है?'),
    stageSeq: seq.map((c) => Visual(color: c.argb)).toList(),
    correct: _colorSwatch(ans),
    wrong: pool.where((x) => x != ans).map(_colorSwatch).toList(),
    hint: const Bi('The colours repeat again and again.', 'रंग बार-बार दोहराए जाते हैं।'),
  );
}
