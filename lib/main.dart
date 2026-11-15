import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/audio/speech_service.dart';
import 'core/localization/language_provider.dart';
import 'core/storage/prefs_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await PrefsStore.create();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider(store)),
        ChangeNotifierProvider(create: (_) => SpeechService(store)),
      ],
      child: const SaralBookKidsApp(),
    ),
  );
}
