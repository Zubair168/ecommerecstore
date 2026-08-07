import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerecstore/main.dart';

void main() {
  testWidgets('Online Shop app starts', (WidgetTester tester) async {
    // Verify the app launches without errors.
    // Full integration tests will be added per screen.
    await tester.pumpWidget(const OnlineShopApp());
  });
}
