import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/ui/widget_view_2x2.dart';

void main() {
  group('HomeWidget2x2View Widget Tests', () {
    testWidgets('renders 2x2 widget correctly', (tester) async {
      final date = DateTime(2026, 7, 27);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeWidget2x2View(
              date: date,
              width: 180,
              height: 180,
            ),
          ),
        ),
      );

      // Verify date numbers are displayed
      expect(find.text('27'), findsOneWidget);
      expect(find.text('Th7/2026'), findsOneWidget);
      expect(find.text('T2'), findsOneWidget);
    });
  });
}
