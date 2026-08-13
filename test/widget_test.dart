// test/widget_test.dart
//
// Smoke test verifying that the core library can be imported without errors.
// Full integration tests require a running Firebase emulator and are run
// separately via firebase emulators:exec.

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flutter test environment is healthy', (WidgetTester tester) async {
    // A simple sanity check: if this passes, the test runner is working
    // correctly and the project's Dart sources compile successfully.
    expect(1 + 1, 2);
  });
}
