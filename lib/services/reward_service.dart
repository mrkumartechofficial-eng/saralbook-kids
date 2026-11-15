import '../models/bi.dart';
import '../models/game_id.dart';
import 'progress_service.dart';

class BadgeDef {
  const BadgeDef(this.id, this.emoji, this.title, this.how, this.test);
  final String id;
  final String emoji;
  final Bi title;
  final Bi how;
  final bool Function(ProgressService) test;
}

bool _levels(ProgressService p, GameId g, int n) => p.completedLevels(g) >= n;

/// Badges are earned only by learning progress (no luck, no pressure).
final List<BadgeDef> allBadges = [
  BadgeDef('first_star', '⭐', const Bi('First Star', 'पहला तारा'),
      const Bi('Earn your first star', 'अपना पहला तारा कमाओ'),
      (p) => p.totalStars >= 1),
  BadgeDef('abc', '🔤', const Bi('ABC Star', 'ABC स्टार'),
      const Bi('Finish 5 ABC levels', 'ABC के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.alphabet, 5)),
  BadgeDef('numbers', '🔢', const Bi('Number Champion', 'संख्या चैंपियन'),
      const Bi('Finish 5 Number levels', 'संख्या के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.numbers, 5)),
  BadgeDef('shapes', '🔷', const Bi('Shape Pro', 'आकृति विशेषज्ञ'),
      const Bi('Finish 5 Shape levels', 'आकृति के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.shapes, 5)),
  BadgeDef('colors', '🎨', const Bi('Colour Expert', 'रंग विशेषज्ञ'),
      const Bi('Finish 5 Colour levels', 'रंग के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.colors, 5)),
  BadgeDef('animals', '🦁', const Bi('Animal Explorer', 'जानवर खोजी'),
      const Bi('Finish 5 Animal levels', 'जानवरों के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.animals, 5)),
  BadgeDef('fruits', '🍎', const Bi('Fruit Friend', 'फल मित्र'),
      const Bi('Finish 5 Fruit levels', 'फल के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.fruits, 5)),
  BadgeDef('maths', '➕', const Bi('Maths Whiz', 'गणित जादूगर'),
      const Bi('Finish 5 Maths levels', 'गणित के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.maths, 5)),
  BadgeDef('spelling', '✏️', const Bi('Word Wizard', 'शब्द जादूगर'),
      const Bi('Finish 5 Word levels', 'शब्दों के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.spelling, 5)),
  BadgeDef('memory', '🃏', const Bi('Memory Star', 'याददाश्त स्टार'),
      const Bi('Finish 5 Memory levels', 'याददाश्त के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.memory, 5)),
  BadgeDef('puzzles', '🧩', const Bi('Puzzle Master', 'पहेली मास्टर'),
      const Bi('Finish 5 Puzzle levels', 'पहेली के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.puzzles, 5)),
  BadgeDef('habits', '🦷', const Bi('Habit Hero', 'आदत हीरो'),
      const Bi('Finish 5 Habit levels', 'आदतों के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.habits, 5)),
  BadgeDef('quiz', '🌟', const Bi('Quiz Star', 'क्विज़ स्टार'),
      const Bi('Finish 5 Quiz levels', 'क्विज़ के 5 स्तर पूरे करो'),
      (p) => _levels(p, GameId.quiz, 5)),
  BadgeDef('collector', '🌠', const Bi('Star Collector', 'तारा संग्राहक'),
      const Bi('Collect 25 stars', '25 तारे इकट्ठा करो'),
      (p) => p.totalStars >= 25),
  BadgeDef('super', '🏆', const Bi('Super Learner', 'सुपर लर्नर'),
      const Bi('Collect 100 stars', '100 तारे इकट्ठा करो'),
      (p) => p.totalStars >= 100),
  BadgeDef('hindi', '🏅', const Bi('Hindi Champion', 'हिंदी चैंपियन'),
      const Bi('Answer 100 questions right in Hindi',
          'हिंदी में 100 सवाल सही करो'),
      (p) => p.correctHindi >= 100),
  BadgeDef('english', '🥇', const Bi('English Champion', 'इंग्लिश चैंपियन'),
      const Bi('Answer 100 questions right in English',
          'अंग्रेज़ी में 100 सवाल सही करो'),
      (p) => p.correctEnglish >= 100),
];

class RewardService {
  static List<BadgeDef> earned(ProgressService p) =>
      allBadges.where((b) => b.test(p)).toList();
}
