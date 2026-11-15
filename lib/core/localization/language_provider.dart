import 'package:flutter/material.dart';

import '../storage/prefs_store.dart';

/// Holds the chosen language (English / Hindi) and saves it on the device.
/// Changing it rebuilds the whole app instantly - no restart needed.
class LanguageProvider extends ChangeNotifier {
  LanguageProvider(this._store) {
    final code = _store.getString(PrefsKeys.language);
    if (code == 'en' || code == 'hi') {
      _locale = Locale(code!);
    }
  }

  final PrefsStore _store;
  Locale? _locale;

  /// True once the child/parent has picked a language on first launch.
  bool get hasChosen => _locale != null;

  Locale get locale => _locale ?? const Locale('en');
  String get code => locale.languageCode;
  bool get isHindi => code == 'hi';

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'hi') return;
    _locale = Locale(languageCode);
    notifyListeners();
    await _store.setString(PrefsKeys.language, languageCode);
  }

  Future<void> toggle() => setLanguage(isHindi ? 'en' : 'hi');
}
