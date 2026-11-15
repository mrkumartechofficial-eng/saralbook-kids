import 'package:flutter/material.dart';

import '../core/localization/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';

/// The 12 games. Each game's code will live in lib/games/<name>/.
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

  IconData get icon => switch (this) {
        GameId.alphabet => Icons.abc_rounded,
        GameId.numbers => Icons.pin_rounded,
        GameId.shapes => Icons.category_rounded,
        GameId.colors => Icons.palette_rounded,
        GameId.animals => Icons.pets_rounded,
        GameId.fruits => Icons.eco_rounded,
        GameId.maths => Icons.calculate_rounded,
        GameId.spelling => Icons.spellcheck_rounded,
        GameId.memory => Icons.style_rounded,
        GameId.puzzles => Icons.extension_rounded,
        GameId.habits => Icons.clean_hands_rounded,
        GameId.quiz => Icons.quiz_rounded,
      };

  Color get color => const [
        AppColors.sky,
        AppColors.yellow,
        AppColors.pink,
        AppColors.mint,
        AppColors.orange,
        AppColors.purple,
      ][index % 6];

  String title(AppLocalizations l) => switch (this) {
        GameId.alphabet => l.gameAlphabet,
        GameId.numbers => l.gameNumbers,
        GameId.shapes => l.gameShapes,
        GameId.colors => l.gameColors,
        GameId.animals => l.gameAnimals,
        GameId.fruits => l.gameFruits,
        GameId.maths => l.gameMaths,
        GameId.spelling => l.gameSpelling,
        GameId.memory => l.gameMemory,
        GameId.puzzles => l.gamePuzzles,
        GameId.habits => l.gameHabits,
        GameId.quiz => l.gameQuiz,
      };
}
