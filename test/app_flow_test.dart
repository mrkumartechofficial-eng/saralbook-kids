import 'package:flutter_test/flutter_test.dart';
import 'package:kids/app.dart';
import 'package:kids/core/audio/speech_service.dart';
import 'package:kids/core/localization/language_provider.dart';
import 'package:kids/core/storage/prefs_store.dart';
import 'package:kids/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('first launch: choose Hindi, then switch to English instantly',
      (tester) async {
    SharedPreferences.setMockInitialValues({'voice_on': false});
    final store = await PrefsStore.create();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider(store)),
          ChangeNotifierProvider(create: (_) => SpeechService(store)),
          ChangeNotifierProvider(create: (_) => ProgressService(store)),
        ],
        child: const SaralBookKidsApp(),
      ),
    );

    // Splash -> language screen
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Choose your language'), findsOneWidget);

    // Pick Hindi -> home screen in Hindi
    await tester.tap(find.text('हिंदी'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('खेलने के लिए चित्र छुओ!'), findsOneWidget);

    // Switch back to English without restarting
    await tester.tap(find.text('English'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Tap a picture to play!'), findsOneWidget);
  });
}
