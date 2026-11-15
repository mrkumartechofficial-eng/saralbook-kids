import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('main Android manifest does not request INTERNET permission', () {
    final file = File('android/app/src/main/AndroidManifest.xml');
    expect(file.existsSync(), isTrue,
        reason: 'Run flutter create first (see README.md)');
    expect(file.readAsStringSync().contains('android.permission.INTERNET'),
        isFalse);
  });
}
