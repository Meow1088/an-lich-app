import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/data/reminder_store.dart';
import 'package:lich_am/ui/widget_view.dart';

void main() {
  final renderDate = DateTime(2026, 1, 1);

  Reminder onceOn(String isoDate, {String title = 'Giỗ ông nội'}) => Reminder(
        id: isoDate,
        title: title,
        isLunar: false,
        day: 1,
        month: 1,
        repeat: RepeatType.once,
        onceSolar: isoDate,
      );

  Future<void> pump(WidgetTester tester, List<Reminder> reminders) =>
      tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: HomeWidgetView(date: renderDate, reminders: reminders),
          ),
        ),
      );

  testWidgets('hiện nhắc nhở khi trong vòng 14 ngày', (tester) async {
    await pump(tester, [onceOn('2026-01-10')]); // còn 9 ngày
    expect(find.textContaining('Nhắc:'), findsOneWidget);
    expect(find.textContaining('còn 9 ngày'), findsOneWidget);
  });

  testWidgets('ẩn nhắc nhở khi xa hơn 14 ngày', (tester) async {
    await pump(tester, [onceOn('2026-02-01')]); // còn 31 ngày
    expect(find.textContaining('Nhắc:'), findsNothing);
  });

  testWidgets('hiện đúng "hôm nay" khi nhắc nhở rơi vào ngày render', (
    tester,
  ) async {
    await pump(tester, [onceOn('2026-01-01')]);
    expect(find.textContaining('Nhắc:'), findsOneWidget);
    expect(find.textContaining('hôm nay'), findsOneWidget);
  });

  testWidgets('chọn nhắc nhở gần nhất khi có nhiều nhắc trong 14 ngày', (
    tester,
  ) async {
    await pump(tester, [
      onceOn('2026-01-12', title: 'Xa hơn'),
      onceOn('2026-01-05', title: 'Gần hơn'),
    ]);
    expect(find.textContaining('Gần hơn'), findsOneWidget);
    expect(find.textContaining('Xa hơn'), findsNothing);
  });
}
