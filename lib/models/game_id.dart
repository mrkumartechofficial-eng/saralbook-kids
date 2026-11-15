import 'bi.dart';

/// The 12 games.
enum GameId {
  alphabet,
  numbers,
  shapes,
  colors,
  animals,
  fruits,
  maths,
  spelling,
  memory,
  puzzles,
  habits,
  quiz;

  String get emoji => switch (this) {
        GameId.alphabet => '🔤',
        GameId.numbers => '🔢',
        GameId.shapes => '🔷',
        GameId.colors => '🎨',
        GameId.animals => '🦁',
        GameId.fruits => '🍎',
        GameId.maths => '➕',
        GameId.spelling => '✏️',
        GameId.memory => '🃏',
        GameId.puzzles => '🧩',
        GameId.habits => '🦷',
        GameId.quiz => '🌟',
      };

  Bi get nameBi => switch (this) {
        GameId.alphabet => const Bi('ABC & Varna', 'ABC और वर्णमाला'),
        GameId.numbers => const Bi('Number World', 'संख्या संसार'),
        GameId.shapes => const Bi('Shape Matcher', 'आकृति मिलान'),
        GameId.colors => const Bi('Color Master', 'रंग मास्टर'),
        GameId.animals => const Bi('Animal Kingdom', 'जानवरों की दुनिया'),
        GameId.fruits => const Bi('Fruit & Veggie Fun', 'फल और सब्ज़ी मज़ा'),
        GameId.maths => const Bi('Maths Champion', 'गणित चैंपियन'),
        GameId.spelling => const Bi('Word Builder', 'शब्द निर्माता'),
        GameId.memory => const Bi('Memory Master', 'याददाश्त मास्टर'),
        GameId.puzzles => const Bi('Puzzle Planet', 'पहेली ग्रह'),
        GameId.habits => const Bi('Good Habits', 'अच्छी आदतें'),
        GameId.quiz => const Bi('Little Quiz Star', 'नन्हा क्विज़ स्टार'),
      };

  Bi get howTo => switch (this) {
        GameId.alphabet => const Bi('Tap the right letter or picture.',
            'सही अक्षर या चित्र को छुओ।'),
        GameId.numbers => const Bi(
            'Count, find and match numbers.', 'गिनो, संख्या खोजो और मिलाओ।'),
        GameId.shapes =>
          const Bi('Find the matching shape.', 'सही आकृति खोजो।'),
        GameId.colors => const Bi('Find the right colour.', 'सही रंग खोजो।'),
        GameId.animals => const Bi('Learn animals and their sounds.',
            'जानवरों और उनकी आवाज़ें सीखो।'),
        GameId.fruits => const Bi(
            'Find fruits and vegetables.', 'फल और सब्ज़ियाँ पहचानो।'),
        GameId.maths =>
          const Bi('Solve the number puzzles.', 'गणित के सवाल हल करो।'),
        GameId.spelling => const Bi('Build the word. Pick the missing part.',
            'शब्द बनाओ। छूटा हुआ हिस्सा चुनो।'),
        GameId.memory => const Bi('Flip cards and find matching pairs.',
            'कार्ड पलटो और जोड़ियाँ खोजो।'),
        GameId.puzzles => const Bi(
            'Tap two pieces to swap them. Finish the picture!',
            'दो टुकड़े छूकर बदलो। चित्र पूरा करो!'),
        GameId.habits =>
          const Bi('Choose the good habit.', 'अच्छी आदत चुनो।'),
        GameId.quiz =>
          const Bi('Answer fun questions.', 'मज़ेदार सवालों के जवाब दो।'),
      };
}
