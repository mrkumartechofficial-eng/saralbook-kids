import 'dart:io';

/// Prepares android/app/src/main/AndroidManifest.xml:
///  1. sets the app name,
///  2. lets the app find the phone's text-to-speech engine (Android 11+),
///  3. guarantees the app has NO internet permission, even if a library asks.
/// Safe to run many times.
void main() {
  final file = File('android/app/src/main/AndroidManifest.xml');
  if (!file.existsSync()) {
    stderr.writeln(
        'AndroidManifest.xml not found. Run "flutter create" first (see README.md).');
    exit(1);
  }
  var text = file.readAsStringSync();
  final original = text;

  if (!text.contains('android:label="SaralBook Kids"')) {
    text = text.replaceFirst(
        RegExp(r'android:label="[^"]*"'), 'android:label="SaralBook Kids"');
  }

  if (!text.contains('android.intent.action.TTS_SERVICE')) {
    const intent =
        '<intent>\n            <action android:name="android.intent.action.TTS_SERVICE"/>\n        </intent>';
    if (text.contains('<queries>')) {
      text = text.replaceFirst('<queries>', '<queries>\n        $intent');
    } else {
      text = text.replaceFirst('<application',
          '<queries>\n        $intent\n    </queries>\n    <application');
    }
  }

  if (!text.contains('xmlns:tools=')) {
    text = text.replaceFirst('<manifest ',
        '<manifest xmlns:tools="http://schemas.android.com/tools" ');
  }
  if (!text.contains('tools:node="remove"')) {
    text = text.replaceFirst(
        '<application',
        '<uses-permission android:name="android.permission.INTERNET" tools:node="remove"/>\n    <application');
  }

  if (text != original) {
    file.writeAsStringSync(text);
    stdout.writeln('Manifest patched.');
  } else {
    stdout.writeln('Manifest already up to date.');
  }
}
