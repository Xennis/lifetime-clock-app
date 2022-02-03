import 'package:flutter_test/flutter_test.dart';

import 'package:lifetime_clock/main.dart';

void main() {
  testWidgets('LifetimeApp can be rendered', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LifetimeApp());
  });
}
