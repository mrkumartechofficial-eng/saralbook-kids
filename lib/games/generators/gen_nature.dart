import 'dart:math';

import '../../content/nature.dart';
import '../../models/bi.dart';
import '../../models/level_info.dart';
import '../../models/question.dart';
import 'common.dart';

// Fixed shuffles so early levels mix different kinds of animals/fruits.
final List<Item> _animalOrder = [...animals]..shuffle(Random(7));
final List<Item> _foodOrder = [...fruits, ...vegetables]..shuffle(Random(11));

Choice _namePic(Item i) => Choice(visual: Visual(emoji: i.emoji), label: i.name);
Choice _picOnly(Item i) => Choice(visual: Visual(emoji: i.emoji));
Choice _nameOnly(Item i) => Choice(label: i.name);

Question genAnimals(Random r, LevelInfo info, String lang) {
  final lv = info.level;
  final groups = lv < 6
      ? ['domestic', 'wild']
      : (lv < 15 ? ['domestic', 'wild', 'bird', 'sea'] : ['domestic', 'wild', 'bird', 'sea', 'insect']);
  final all = _animalOrder.where((a) => groups.contains(a.group)).toList();
  final pool = all.take(min(all.length, 6 + lv)).toList();

  final types = <int>[0, 1];
  if (lv >= 3) types.addAll([2, 3]);
  if (lv >= 8) types.add(4);
  final t = pick(r, types);

  if (t == 0) {
    final a = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: const Bi('What animal is this?', 'यह कौन-सा जानवर है?'),
      stage: Visual(emoji: a.emoji),
      correct: _nameOnly(a),
      wrong: pool.where((x) => x.id != a.id).map(_nameOnly).toList(),
      speak: a.name,
    );
  }
  if (t == 1) {
    final a = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Find the ${a.en}', '${a.hi} को खोजो'),
      correct: _picOnly(a),
      wrong: pool.where((x) => x.id != a.id).map(_picOnly).toList(),
    );
  }
  if (t == 2) {
    final cat = pick(r, groups);
    final a = pick(r, pool.where((x) => x.group == cat).toList());
    final wrongGroups = categoryDistractors[cat]!.where(groups.contains).toList();
    final wrong = animals.where((x) => wrongGroups.contains(x.group)).toList();
    final gn = animalGroupNames[cat]!;
    return makeQuestion(
      r,
      info,
      instruction: Bi('Which one is ${gn.en}?', 'इनमें से ${gn.hi} कौन-सा है?'),
      correct: _namePic(a),
      wrong: wrong.map(_namePic).toList(),
    );
  }
  if (t == 3) {
    final s = pick(r, animalSounds);
    final a = itemById(animals, s.animalId);
    final others = animalSounds
        .where((x) => x.animalId != s.animalId)
        .map((x) => _namePic(itemById(animals, x.animalId)))
        .toList();
    return makeQuestion(
      r,
      info,
      instruction: Bi('Who says "${s.sound.en}"?', '"${s.sound.hi}" कौन बोलता है?'),
      correct: _namePic(a),
      wrong: others,
      speak: s.sound,
    );
  }
  final candidates = pool.where((x) => animalHabitat.containsKey(x.id)).toList();
  final a = candidates.isEmpty
      ? itemById(animals, 'cow')
      : pick(r, candidates);
  final hab = itemById(habitats, animalHabitat[a.id]!);
  return makeQuestion(
    r,
    info,
    instruction: Bi('Where does the ${a.en} live?', '${a.hi} का घर कहाँ है?'),
    stage: Visual(emoji: a.emoji),
    correct: _namePic(hab),
    wrong: habitats.where((x) => x.id != hab.id).map(_namePic).toList(),
  );
}

Question genFruits(Random r, LevelInfo info, String lang) {
  final lv = info.level;
  final pool = _foodOrder.take(min(_foodOrder.length, 6 + lv)).toList();
  final types = <int>[0, 1];
  if (lv >= 2) types.add(4);
  if (lv >= 3) types.add(2);
  if (lv >= 5) types.add(3);
  final t = pick(r, types);

  if (t == 0) {
    final a = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: const Bi('What is this?', 'यह क्या है?'),
      stage: Visual(emoji: a.emoji),
      correct: _nameOnly(a),
      wrong: pool.where((x) => x.id != a.id).map(_nameOnly).toList(),
      speak: a.name,
    );
  }
  if (t == 1) {
    final a = pick(r, pool);
    return makeQuestion(
      r,
      info,
      instruction: Bi('Find the ${a.en}', '${a.hi} को खोजो'),
      correct: _picOnly(a),
      wrong: pool.where((x) => x.id != a.id).map(_picOnly).toList(),
    );
  }
  final clearFruits = fruits.where((f) => clearFruitIds.contains(f.id)).toList();
  final clearVeg = vegetables.where((v) => clearVegIds.contains(v.id)).toList();
  if (t == 2) {
    final isFruit = r.nextBool();
    final a = isFruit ? pick(r, clearFruits) : pick(r, clearVeg);
    const fruitChoice = Choice(
        visual: Visual(emoji: '🍎'), label: Bi('Fruit', 'फल'));
    const vegChoice = Choice(
        visual: Visual(emoji: '🥕'), label: Bi('Vegetable', 'सब्ज़ी'));
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Is this a fruit or a vegetable?', 'यह फल है या सब्ज़ी?'),
      stage: Visual(emoji: a.emoji),
      correct: isFruit ? fruitChoice : vegChoice,
      wrong: [isFruit ? vegChoice : fruitChoice],
      count: 2,
    );
  }
  if (t == 3) {
    final healthy = pick(r, [...clearFruits, ...clearVeg]);
    return makeQuestion(
      r,
      info,
      instruction: const Bi('Which food is healthy?', 'कौन-सा खाना सेहतमंद है?'),
      correct: _namePic(healthy),
      wrong: junkFood.map(_namePic).toList(),
      hint: const Bi('Fruits and vegetables help us grow strong.',
          'फल और सब्ज़ियाँ हमें मज़बूत बनाते हैं।'),
    );
  }
  final wantFruit = r.nextBool();
  final correct = wantFruit ? pick(r, clearFruits) : pick(r, clearVeg);
  final wrongPool = wantFruit ? clearVeg : clearFruits;
  return makeQuestion(
    r,
    info,
    instruction: Bi(
      wantFruit ? 'Find the fruit' : 'Find the vegetable',
      wantFruit ? 'फल खोजो' : 'सब्ज़ी खोजो',
    ),
    correct: _namePic(correct),
    wrong: wrongPool.map(_namePic).toList(),
  );
}
