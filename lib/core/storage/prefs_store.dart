import 'package:shared_preferences/shared_preferences.dart';

/// Keys used for local storage. Nothing personal is ever stored.
class PrefsKeys {
  static const String language = 'language_code';
  static const String voiceOn = 'voice_on';
}

/// Small wrapper around SharedPreferences (local device storage only).
class PrefsStore {
  PrefsStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsStore> create() async =>
      PrefsStore(await SharedPreferences.getInstance());

  String? getString(String key) => _prefs.getString(key);
  bool? getBool(String key) => _prefs.getBool(key);
  int? getInt(String key) => _prefs.getInt(key);

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
