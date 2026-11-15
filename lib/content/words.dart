class EnWord {
  const EnWord(this.word, this.emoji);
  final String word;
  final String emoji;
}

const List<EnWord> enWords = [
  EnWord('CAT', '🐱'), EnWord('DOG', '🐶'), EnWord('SUN', '☀️'),
  EnWord('HAT', '🎩'), EnWord('PIG', '🐷'), EnWord('COW', '🐮'),
  EnWord('BUS', '🚌'), EnWord('CAR', '🚗'), EnWord('BED', '🛏️'),
  EnWord('EGG', '🥚'), EnWord('FOX', '🦊'), EnWord('HEN', '🐔'),
  EnWord('BEE', '🐝'), EnWord('BAT', '🦇'),
  EnWord('BALL', '⚽'), EnWord('FISH', '🐟'), EnWord('DUCK', '🦆'),
  EnWord('FROG', '🐸'), EnWord('STAR', '⭐'), EnWord('MOON', '🌙'),
  EnWord('TREE', '🌳'), EnWord('BOOK', '📕'), EnWord('CAKE', '🎂'),
  EnWord('LION', '🦁'), EnWord('BIRD', '🐦'),
  EnWord('APPLE', '🍎'), EnWord('MANGO', '🥭'), EnWord('TIGER', '🐯'),
  EnWord('ZEBRA', '🦓'), EnWord('HORSE', '🐴'), EnWord('PIZZA', '🍕'),
  EnWord('SHEEP', '🐑'), EnWord('TRAIN', '🚂'), EnWord('PLANE', '✈️'),
  EnWord('BANANA', '🍌'), EnWord('ORANGE', '🍊'), EnWord('MONKEY', '🐵'),
  EnWord('ROCKET', '🚀'), EnWord('FLOWER', '🌸'), EnWord('TURTLE', '🐢'),
  EnWord('PARROT', '🦜'), EnWord('GRAPES', '🍇'),
];

/// A Hindi word split into the pieces a child can pick from.
class HiWord {
  const HiWord(this.units, this.emoji);
  final List<String> units;
  final String emoji;
  String get word => units.join();
}

const List<HiWord> hiWords = [
  HiWord(['आ', 'म'], '🥭'),
  HiWord(['के', 'ला'], '🍌'),
  HiWord(['से', 'ब'], '🍎'),
  HiWord(['म', 'छ', 'ली'], '🐟'),
  HiWord(['हा', 'थी'], '🐘'),
  HiWord(['शे', 'र'], '🦁'),
  HiWord(['ब', 'त', 'ख'], '🦆'),
  HiWord(['घ', 'र'], '🏠'),
  HiWord(['फू', 'ल'], '🌸'),
  HiWord(['पे', 'ड़'], '🌳'),
  HiWord(['चाँ', 'द'], '🌙'),
  HiWord(['ता', 'रा'], '⭐'),
  HiWord(['सू', 'र', 'ज'], '☀️'),
  HiWord(['गा', 'य'], '🐮'),
  HiWord(['तो', 'ता'], '🦜'),
  HiWord(['मो', 'र'], '🦚'),
  HiWord(['घ', 'ड़ी'], '⏰'),
  HiWord(['कि', 'ता', 'ब'], '📕'),
  HiWord(['गें', 'द'], '⚽'),
  HiWord(['ब', 'स'], '🚌'),
  HiWord(['का', 'र'], '🚗'),
];
