import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app never requests the INTERNET permission', () {
    final file = File('android/app/src/main/AndroidManifest.xml');
    expect(file.existsSync(), isTrue,
        reason: 'Run flutter create first (see README.md)');
    final lines = file
        .readAsLinesSync()
        .where((l) => l.contains('android.permission.INTERNET'));
    // The only allowed mention is the line that REMOVES the permission.
    for (final l in lines) {
      expect(l.contains('tools:node="remove"'), isTrue,
          reason: 'INTERNET must only appear as a removal: $l');
    }
  });
}
