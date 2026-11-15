import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/localization/language_provider.dart';
import 'package:kids/core/storage/prefs_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('defaults to English and has not chosen yet', () async {
    final provider = LanguageProvider(await PrefsStore.create());
    expect(provider.hasChosen, isFalse);
    expect(provider.code, 'en');
  });

  test('switching language is saved and survives a restart', () async {
    final first = LanguageProvider(await PrefsStore.create());
    await first.setLanguage('hi');
    expect(first.isHindi, isTrue);

    // Simulate closing and re-opening the app.
    final second = LanguageProvider(await PrefsStore.create());
    expect(second.hasChosen, isTrue);
    expect(second.code, 'hi');
  });

  test('toggle flips between English and Hindi', () async {
    final provider = LanguageProvider(await PrefsStore.create());
    await provider.toggle();
    expect(provider.code, 'hi');
    await provider.toggle();
    expect(provider.code, 'en');
  });

  test('ignores unsupported language codes', () async {
    final provider = LanguageProvider(await PrefsStore.create());
    await provider.setLanguage('fr');
    expect(provider.hasChosen, isFalse);
  });
}
