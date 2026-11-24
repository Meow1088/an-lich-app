import 'package:flutter_test/flutter_test.dart';

import 'package:lich_am/main.dart';

void main() {
  testWidgets('An Lich app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LichAmApp());
    await tester.pump();

    expect(find.text('An Lịch'), findsWidgets);
  });
}
