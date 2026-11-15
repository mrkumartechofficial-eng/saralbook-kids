import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/localization/generated/app_localizations.dart';
import 'core/localization/language_provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class SaralBookKidsApp extends StatelessWidget {
  const SaralBookKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return MaterialApp(
      title: 'SaralBook Kids',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: lang.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
