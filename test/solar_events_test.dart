import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/solar_events.dart';

void main() {
  test('solarEventsForDate trả đúng sự kiện theo ngày dương', () {
    expect(solarEventsForDate(3, 8).first.name, 'Quốc tế Phụ nữ');
    expect(solarEventsForDate(11, 20).first.name, 'Ngày Nhà giáo Việt Nam');
    expect(solarEventsForDate(2, 14).first.name, 'Lễ Tình nhân (Valentine)');
  });

  test('ngày không có sự kiện dương -> rỗng', () {
    expect(solarEventsForDate(1, 2), isEmpty);
  });

  test('upcomingSolarEvents: gần nhất + đúng số ngày còn lại', () {
    // từ 10/2/2026 -> 14/2 Valentine còn 4 ngày
    final up = upcomingSolarEvents(DateTime(2026, 2, 10));
    expect(up.first.event.name, 'Lễ Tình nhân (Valentine)');
    expect(up.first.daysAway, 4);
    // danh sách sắp tăng dần
    for (var i = 1; i < up.length; i++) {
      expect(up[i].daysAway >= up[i - 1].daysAway, isTrue);
    }
  });

  test('vắt qua năm sau: 26/12 -> 1/1 Tết Dương còn 6 ngày', () {
    final up = upcomingSolarEvents(DateTime(2026, 12, 26));
    expect(up.first.event.name, 'Tết Dương lịch');
    expect(up.first.daysAway, 6);
  });

  test('upcomingAllEvents gộp âm + dương, sắp tăng dần', () {
    // từ 25/6/2026: 28/6 Ngày Gia đình (dương) gần nhất = 3 ngày
    final up = upcomingAllEvents(DateTime(2026, 6, 25), limit: 5);
    expect(up.first.event.name, 'Ngày Gia đình Việt Nam');
    expect(up.first.daysAway, 3);
    for (var i = 1; i < up.length; i++) {
      expect(up[i].daysAway >= up[i - 1].daysAway, isTrue);
    }
  });
}
