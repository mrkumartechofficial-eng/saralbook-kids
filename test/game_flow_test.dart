import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/audio/speech_service.dart';
import 'package:kids/core/localization/generated/app_localizations.dart';
import 'package:kids/core/localization/language_provider.dart';
import 'package:kids/core/storage/prefs_store.dart';
import 'package:kids/models/game_id.dart';
import 'package:kids/screens/play/game_screen.dart';
import 'package:kids/services/level_engine.dart';
import 'package:kids/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _app(PrefsStore store, ProgressService progress, GameId game) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LanguageProvider(store)),
      ChangeNotifierProvider(create: (_) => SpeechService(store)),
      ChangeNotifierProvider.value(value: progress),
    ],
    child: Consumer<LanguageProvider>(
      builder: (context, lang, _) => MaterialApp(
        locale: lang.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GameScreen(game: game, level: 1, variant: 0),
      ),
    ),
  );
}

void main() {
  testWidgets('play a whole level, earn stars, unlock level 2', (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues(
        {'voice_on': false, 'language_code': 'en'});
    final store = await PrefsStore.create();
    final progress = ProgressService(store);
    final questions =
        LevelEngine.build(GameId.numbers, 1, variant: 0, lang: 'en');

    await tester.pumpWidget(_app(store, progress, GameId.numbers));
    await tester.pump();

    for (final q in questions) {
      final choice = find.byKey(ValueKey('choice_${q.answer}'));
      await tester.ensureVisible(choice);
      await tester.tap(choice);
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('next_button')));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Level 1 complete!'), findsOneWidget);
    expect(progress.highestUnlocked(GameId.numbers), 2);
    expect(progress.starsFor(GameId.numbers, 1), 3);
  });

  testWidgets('language can be switched in the middle of a game',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues(
        {'voice_on': false, 'language_code': 'en'});
    final store = await PrefsStore.create();
    final progress = ProgressService(store);

    await tester.pumpWidget(_app(store, progress, GameId.colors));
    await tester.pump();
    expect(find.textContaining('Level 1'), findsOneWidget);

    await tester.tap(find.text('हिंदी'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('स्तर 1'), findsOneWidget);
  });
}
