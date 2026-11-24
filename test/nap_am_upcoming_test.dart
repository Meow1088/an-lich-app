import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/can_chi.dart';
import 'package:lich_am/core/lunar_calendar.dart';
import 'package:lich_am/core/lunar_events.dart';

void main() {
  group('nạp âm (đối chiếu Lịch Ta cho ngày 24/6/2026)', () {
    test('ngày Kỷ Tỵ = Đại Lâm Mộc', () {
      expect(napAmOfDay(24, 6, 2026).name, 'Đại Lâm Mộc');
      expect(napAmOfDay(24, 6, 2026).element, 'Mộc');
    });
    test('tháng Giáp Ngọ = Sa Trung Kim', () {
      final l = solarToLunar(24, 6, 2026);
      expect(napAmOfMonth(l.month, l.year).name, 'Sa Trung Kim');
    });
    test('năm Bính Ngọ (2026) = Thiên Hà Thủy', () {
      expect(napAmOfYear(2026).name, 'Thiên Hà Thủy');
    });
  });

  group('sự kiện sắp tới + đếm ngược', () {
    test('trả về danh sách sắp xếp tăng dần, daysAway >= 0', () {
      final list = upcomingEvents(DateTime(2026, 6, 24), limit: 4);
      expect(list.isNotEmpty, true);
      expect(list.length <= 4, true);
      for (var i = 0; i < list.length; i++) {
        expect(list[i].daysAway >= 0, true);
        if (i > 0) {
          expect(list[i].daysAway >= list[i - 1].daysAway, true);
        }
      }
    });
    test('sự kiện đầu tiên sau 24/6 là Vu Lan (15/7 ÂL)', () {
      final list = upcomingEvents(DateTime(2026, 6, 24), limit: 1);
      expect(list.first.event.name.contains('Vu Lan'), true);
    });
  });
}
