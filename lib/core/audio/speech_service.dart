import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../storage/prefs_store.dart';

/// Speaks text aloud using the phone's built-in text-to-speech voices.
/// Works offline if the voice is installed on the phone. Never crashes the
/// app: if speech is not possible it simply stays silent.
class SpeechService extends ChangeNotifier {
  SpeechService(this._store)
      : _enabled = _store.getBool(PrefsKeys.voiceOn) ?? true;

  final PrefsStore _store;
  FlutterTts? _tts;
  bool _enabled;

  bool get enabled => _enabled;

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();
    await _store.setBool(PrefsKeys.voiceOn, value);
    if (!value) {
      try {
        await _tts?.stop();
      } catch (_) {}
    }
  }

  static String _tag(String languageCode) =>
      languageCode == 'hi' ? 'hi-IN' : 'en-US';

  Future<FlutterTts> _engine() async {
    final existing = _tts;
    if (existing != null) return existing;
    final tts = FlutterTts();
    await tts.setSpeechRate(0.4); // slow and clear for children
    await tts.setPitch(1.1);
    await tts.setVolume(1.0);
    _tts = tts;
    return tts;
  }

  /// Is a voice for this language installed on the phone?
  Future<bool> isLanguageAvailable(String languageCode) async {
    try {
      final tts = await _engine();
      final result = await tts.isLanguageAvailable(_tag(languageCode));
      return result == true || result == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> speak(String text, String languageCode) async {
    if (!_enabled || text.trim().isEmpty) return;
    try {
      final tts = await _engine();
      await tts.stop();
      await tts.setLanguage(_tag(languageCode));
      await tts.speak(text);
    } catch (_) {
      // Stay silent rather than crash.
    }
  }

  Future<void> stop() async {
    try {
      await _tts?.stop();
    } catch (_) {}
  }
}
