import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/lunar_calendar.dart';
import 'package:lich_am/core/can_chi.dart';

void main() {
  group('solarToLunar — mốc Tết Nguyên Đán (mùng 1 tháng 1 âm)', () {
    test('Tết Giáp Thìn: 10/02/2024 -> 1/1/2024 âm', () {
      final l = solarToLunar(10, 2, 2024);
      expect(l.day, 1);
      expect(l.month, 1);
      expect(l.year, 2024);
      expect(l.isLeapMonth, false);
    });

    test('Tết Ất Tỵ: 29/01/2025 -> 1/1/2025 âm', () {
      final l = solarToLunar(29, 1, 2025);
      expect(l.day, 1);
      expect(l.month, 1);
      expect(l.year, 2025);
    });

    test('Tết Bính Ngọ: 17/02/2026 -> 1/1/2026 âm', () {
      final l = solarToLunar(17, 2, 2026);
      expect(l.day, 1);
      expect(l.month, 1);
      expect(l.year, 2026);
    });

    test('29/01/2025 là ngày Tết nên năm âm = Ất Tỵ', () {
      final l = solarToLunar(29, 1, 2025);
      expect(canChiOfYear(l.year), 'Ất Tỵ');
    });
  });

  group('lunarToSolar — đảo ngược đúng', () {
    test('1/1/2026 âm -> 17/02/2026 dương', () {
      final s = lunarToSolar(1, 1, 2026);
      expect(s, isNotNull);
      expect(s!.day, 17);
      expect(s.month, 2);
      expect(s.year, 2026);
    });
  });

  group('round-trip solar -> lunar -> solar giữ nguyên ngày', () {
    final samples = <List<int>>[
      [1, 1, 2026],
      [15, 8, 2025],
      [30, 4, 2024],
      [24, 12, 2023],
      [7, 7, 2020],
      [29, 1, 2025],
    ];
    for (final s in samples) {
      test('${s[0]}/${s[1]}/${s[2]}', () {
        final l = solarToLunar(s[0], s[1], s[2]);
        final back = lunarToSolar(l.day, l.month, l.year,
            isLeapMonth: l.isLeapMonth);
        expect(back, isNotNull);
        expect(back!.day, s[0]);
        expect(back.month, s[1]);
        expect(back.year, s[2]);
      });
    }
  });

  group('can chi năm', () {
    test('2024 = Giáp Thìn', () => expect(canChiOfYear(2024), 'Giáp Thìn'));
    test('2025 = Ất Tỵ', () => expect(canChiOfYear(2025), 'Ất Tỵ'));
    test('2026 = Bính Ngọ', () => expect(canChiOfYear(2026), 'Bính Ngọ'));
    test('2000 = Canh Thìn', () => expect(canChiOfYear(2000), 'Canh Thìn'));
  });

  group('can chi ngày — tính chất tuần tự', () {
    test('ngày kế tiếp tiến cả Can và Chi đúng 1 bước', () {
      final jd = julianDayNumber(17, 2, 2026);
      final canToday = (jd + 9) % 10;
      final chiToday = (jd + 1) % 12;
      final jdNext = julianDayNumber(18, 2, 2026);
      expect(jdNext, jd + 1);
      expect((jdNext + 9) % 10, (canToday + 1) % 10);
      expect((jdNext + 1) % 12, (chiToday + 1) % 12);
    });

    test('định dạng can chi ngày hợp lệ (gồm 1 can + 1 chi)', () {
      final s = canChiOfDay(17, 2, 2026);
      final parts = s.split(' ');
      expect(parts.length, 2);
      expect(thienCan.contains(parts[0]), true);
      expect(diaChi.contains(parts[1]), true);
    });
  });

  group('tiết khí', () {
    test('cuối tháng 12 rơi vào Đông chí', () {
      expect(tietKhiOfDay(25, 12, 2025), 'Đông chí');
    });
  });
}
