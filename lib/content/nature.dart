import '../models/bi.dart';
import '../models/question.dart';

class Item {
  const Item(this.id, this.en, this.hi, this.emoji, [this.group = '']);
  final String id;
  final String en;
  final String hi;
  final String emoji;
  final String group;
  Bi get name => Bi(en, hi);
}

const List<Item> fruits = [
  Item('apple', 'Apple', 'सेब', '🍎', 'fruit'),
  Item('banana', 'Banana', 'केला', '🍌', 'fruit'),
  Item('mango', 'Mango', 'आम', '🥭', 'fruit'),
  Item('orange', 'Orange', 'संतरा', '🍊', 'fruit'),
  Item('grapes', 'Grapes', 'अंगूर', '🍇', 'fruit'),
  Item('watermelon', 'Watermelon', 'तरबूज़', '🍉', 'fruit'),
  Item('strawberry', 'Strawberry', 'स्ट्रॉबेरी', '🍓', 'fruit'),
  Item('pineapple', 'Pineapple', 'अनानास', '🍍', 'fruit'),
  Item('cherry', 'Cherries', 'चेरी', '🍒', 'fruit'),
  Item('peach', 'Peach', 'आड़ू', '🍑', 'fruit'),
  Item('pear', 'Pear', 'नाशपाती', '🍐', 'fruit'),
  Item('lemon', 'Lemon', 'नींबू', '🍋', 'fruit'),
  Item('coconut', 'Coconut', 'नारियल', '🥥', 'fruit'),
  Item('kiwi', 'Kiwi', 'कीवी', '🥝', 'fruit'),
];

const List<Item> vegetables = [
  Item('carrot', 'Carrot', 'गाजर', '🥕', 'veg'),
  Item('tomato', 'Tomato', 'टमाटर', '🍅', 'veg'),
  Item('potato', 'Potato', 'आलू', '🥔', 'veg'),
  Item('corn', 'Corn', 'मक्का', '🌽', 'veg'),
  Item('broccoli', 'Broccoli', 'ब्रोकली', '🥦', 'veg'),
  Item('brinjal', 'Brinjal', 'बैंगन', '🍆', 'veg'),
  Item('cucumber', 'Cucumber', 'खीरा', '🥒', 'veg'),
  Item('chilli', 'Chilli', 'मिर्च', '🌶️', 'veg'),
];

/// Only items that are clearly a fruit / clearly a vegetable for children.
const List<String> clearFruitIds = [
  'apple', 'banana', 'mango', 'orange', 'grapes', 'watermelon', 'strawberry',
  'pineapple',
];
const List<String> clearVegIds = ['carrot', 'potato', 'broccoli'];

const List<Item> junkFood = [
  Item('candy', 'Candy', 'टॉफ़ी', '🍬'),
  Item('fries', 'French fries', 'फ़्रेंच फ़्राइज़', '🍟'),
  Item('donut', 'Doughnut', 'डोनट', '🍩'),
  Item('icecream', 'Ice cream', 'आइसक्रीम', '🍦'),
  Item('burger', 'Burger', 'बर्गर', '🍔'),
];

const List<Item> animals = [
  // pets and farm animals
  Item('dog', 'Dog', 'कुत्ता', '🐶', 'domestic'),
  Item('cat', 'Cat', 'बिल्ली', '🐱', 'domestic'),
  Item('cow', 'Cow', 'गाय', '🐮', 'domestic'),
  Item('horse', 'Horse', 'घोड़ा', '🐴', 'domestic'),
  Item('sheep', 'Sheep', 'भेड़', '🐑', 'domestic'),
  Item('goat', 'Goat', 'बकरी', '🐐', 'domestic'),
  Item('pig', 'Pig', 'सूअर', '🐷', 'domestic'),
  Item('rabbit', 'Rabbit', 'खरगोश', '🐰', 'domestic'),
  // wild animals
  Item('lion', 'Lion', 'शेर', '🦁', 'wild'),
  Item('tiger', 'Tiger', 'बाघ', '🐯', 'wild'),
  Item('elephant', 'Elephant', 'हाथी', '🐘', 'wild'),
  Item('monkey', 'Monkey', 'बंदर', '🐵', 'wild'),
  Item('bear', 'Bear', 'भालू', '🐻', 'wild'),
  Item('giraffe', 'Giraffe', 'जिराफ़', '🦒', 'wild'),
  Item('zebra', 'Zebra', 'ज़ेबरा', '🦓', 'wild'),
  Item('wolf', 'Wolf', 'भेड़िया', '🐺', 'wild'),
  Item('fox', 'Fox', 'लोमड़ी', '🦊', 'wild'),
  Item('deer', 'Deer', 'हिरण', '🦌', 'wild'),
  // birds
  Item('parrot', 'Parrot', 'तोता', '🦜', 'bird'),
  Item('peacock', 'Peacock', 'मोर', '🦚', 'bird'),
  Item('owl', 'Owl', 'उल्लू', '🦉', 'bird'),
  Item('eagle', 'Eagle', 'बाज़', '🦅', 'bird'),
  Item('penguin', 'Penguin', 'पेंगुइन', '🐧', 'bird'),
  Item('swan', 'Swan', 'हंस', '🦢', 'bird'),
  Item('hen', 'Hen', 'मुर्गी', '🐔', 'bird'),
  Item('duck', 'Duck', 'बत्तख', '🦆', 'bird'),
  // sea animals
  Item('fish', 'Fish', 'मछली', '🐟', 'sea'),
  Item('whale', 'Whale', 'व्हेल', '🐳', 'sea'),
  Item('dolphin', 'Dolphin', 'डॉल्फ़िन', '🐬', 'sea'),
  Item('octopus', 'Octopus', 'ऑक्टोपस', '🐙', 'sea'),
  Item('crab', 'Crab', 'केकड़ा', '🦀', 'sea'),
  Item('turtle', 'Turtle', 'कछुआ', '🐢', 'sea'),
  Item('shark', 'Shark', 'शार्क', '🦈', 'sea'),
  // insects
  Item('butterfly', 'Butterfly', 'तितली', '🦋', 'insect'),
  Item('bee', 'Bee', 'मधुमक्खी', '🐝', 'insect'),
  Item('ant', 'Ant', 'चींटी', '🐜', 'insect'),
  Item('ladybird', 'Ladybird', 'लेडीबर्ड', '🐞', 'insect'),
  Item('mosquito', 'Mosquito', 'मच्छर', '🦟', 'insect'),
];

const Map<String, Bi> animalGroupNames = {
  'domestic': Bi('a pet or farm animal', 'पालतू जानवर'),
  'wild': Bi('a wild animal of the jungle', 'जंगल का जानवर'),
  'bird': Bi('a bird', 'पक्षी'),
  'sea': Bi('a sea animal', 'समुद्र का जीव'),
  'insect': Bi('an insect', 'कीट'),
};

/// Which groups may appear as WRONG answers for a category question,
/// so that a wrong answer is never secretly also correct.
const Map<String, List<String>> categoryDistractors = {
  'domestic': ['wild', 'sea', 'insect'],
  'wild': ['domestic'],
  'bird': ['domestic', 'wild', 'sea', 'insect'],
  'sea': ['domestic', 'wild', 'insect'],
  'insect': ['domestic', 'wild', 'sea', 'bird'],
};

class AnimalSound {
  const AnimalSound(this.animalId, this.sound);
  final String animalId;
  final Bi sound;
}

const List<AnimalSound> animalSounds = [
  AnimalSound('dog', Bi('Woof woof', 'भौं भौं')),
  AnimalSound('cat', Bi('Meow', 'म्याऊँ')),
  AnimalSound('cow', Bi('Moo', 'मूँ मूँ')),
  AnimalSound('duck', Bi('Quack', 'क्वैक क्वैक')),
  AnimalSound('lion', Bi('Roar', 'दहाड़')),
  AnimalSound('sheep', Bi('Baa', 'में में')),
  AnimalSound('pig', Bi('Oink', 'ऑइंक')),
  AnimalSound('horse', Bi('Neigh', 'हिन-हिन')),
  AnimalSound('hen', Bi('Cluck', 'कुड़-कुड़')),
  AnimalSound('bee', Bi('Buzz', 'भिन-भिन')),
];

const List<Item> habitats = [
  Item('water', 'Water', 'पानी', '🌊'),
  Item('forest', 'Forest', 'जंगल', '🌳'),
  Item('farm', 'Farm', 'खेत', '🚜'),
  Item('home', 'Home', 'घर', '🏠'),
];

const Map<String, String> animalHabitat = {
  'dog': 'home', 'cat': 'home',
  'cow': 'farm', 'horse': 'farm', 'sheep': 'farm', 'goat': 'farm',
  'pig': 'farm', 'hen': 'farm',
  'lion': 'forest', 'tiger': 'forest', 'elephant': 'forest',
  'monkey': 'forest', 'bear': 'forest', 'deer': 'forest', 'wolf': 'forest',
  'fox': 'forest',
  'fish': 'water', 'whale': 'water', 'dolphin': 'water', 'octopus': 'water',
  'crab': 'water', 'turtle': 'water', 'shark': 'water',
};

Item itemById(List<Item> list, String id) =>
    list.firstWhere((e) => e.id == id);

// ---- colours ----

class ColorItem {
  const ColorItem(this.id, this.en, this.hi, this.argb);
  final String id;
  final String en;
  final String hi;
  final int argb;
  Bi get name => Bi(en, hi);
}

const List<ColorItem> colorItems = [
  ColorItem('red', 'Red', 'लाल', 0xFFE53935),
  ColorItem('blue', 'Blue', 'नीला', 0xFF1E88E5),
  ColorItem('yellow', 'Yellow', 'पीला', 0xFFFDD835),
  ColorItem('green', 'Green', 'हरा', 0xFF43A047),
  ColorItem('orange', 'Orange', 'नारंगी', 0xFFFB8C00),
  ColorItem('pink', 'Pink', 'गुलाबी', 0xFFF06292),
  ColorItem('purple', 'Purple', 'बैंगनी', 0xFF8E24AA),
  ColorItem('brown', 'Brown', 'भूरा', 0xFF795548),
  ColorItem('black', 'Black', 'काला', 0xFF212121),
  ColorItem('white', 'White', 'सफ़ेद', 0xFFFFFFFF),
];

class ColoredObject {
  const ColoredObject(this.emoji, this.en, this.hi, this.colorId);
  final String emoji;
  final String en;
  final String hi;
  final String colorId;
  Bi get name => Bi(en, hi);
}

const List<ColoredObject> coloredObjects = [
  ColoredObject('🍌', 'Banana', 'केला', 'yellow'),
  ColoredObject('🍎', 'Apple', 'सेब', 'red'),
  ColoredObject('🥕', 'Carrot', 'गाजर', 'orange'),
  ColoredObject('🍇', 'Grapes', 'अंगूर', 'purple'),
  ColoredObject('🍓', 'Strawberry', 'स्ट्रॉबेरी', 'red'),
  ColoredObject('🌿', 'Leaf', 'पत्ता', 'green'),
  ColoredObject('🍆', 'Brinjal', 'बैंगन', 'purple'),
  ColoredObject('🍊', 'Orange', 'संतरा', 'orange'),
  ColoredObject('🍅', 'Tomato', 'टमाटर', 'red'),
  ColoredObject('🥒', 'Cucumber', 'खीरा', 'green'),
];

// ---- shapes ----

class ShapeItem {
  const ShapeItem(this.kind, this.en, this.hi);
  final ShapeKind kind;
  final String en;
  final String hi;
  Bi get name => Bi(en, hi);
}

const List<ShapeItem> shapeItems = [
  ShapeItem(ShapeKind.circle, 'Circle', 'वृत्त'),
  ShapeItem(ShapeKind.square, 'Square', 'वर्ग'),
  ShapeItem(ShapeKind.triangle, 'Triangle', 'त्रिभुज'),
  ShapeItem(ShapeKind.rectangle, 'Rectangle', 'आयत'),
  ShapeItem(ShapeKind.star, 'Star', 'तारा'),
  ShapeItem(ShapeKind.heart, 'Heart', 'दिल'),
  ShapeItem(ShapeKind.oval, 'Oval', 'अंडाकार'),
  ShapeItem(ShapeKind.diamond, 'Diamond', 'हीरा'),
];

class ShapeObject {
  const ShapeObject(this.emoji, this.en, this.hi, this.kind);
  final String emoji;
  final String en;
  final String hi;
  final ShapeKind kind;
  Bi get name => Bi(en, hi);
}

const List<ShapeObject> shapeObjects = [
  ShapeObject('⚽', 'Ball', 'गेंद', ShapeKind.circle),
  ShapeObject('🎲', 'Dice', 'पासा', ShapeKind.square),
  ShapeObject('🍕', 'Pizza slice', 'पिज़्ज़ा का टुकड़ा', ShapeKind.triangle),
  ShapeObject('📕', 'Book', 'किताब', ShapeKind.rectangle),
  ShapeObject('🥚', 'Egg', 'अंडा', ShapeKind.oval),
  ShapeObject('💎', 'Gem', 'रत्न', ShapeKind.diamond),
];
