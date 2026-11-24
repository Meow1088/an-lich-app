import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/lunar_events.dart';

void main() {
  group('sự kiện âm lịch — ngày lễ lớn', () {
    test('1/1 = Tết Nguyên Đán (major)', () {
      final e = eventsForLunarDate(1, 1);
      expect(e.length, 1);
      expect(e.first.name, 'Tết Nguyên Đán');
      expect(e.first.isMajor, true);
    });
    test('15/8 = Tết Trung Thu', () {
      expect(eventsForLunarDate(15, 8).first.name, 'Tết Trung Thu');
    });
    test('5/5 = Tết Đoan Ngọ', () {
      expect(eventsForLunarDate(5, 5).first.name, 'Tết Đoan Ngọ');
    });
    test('23/12 = Ông Công Ông Táo', () {
      expect(eventsForLunarDate(23, 12).first.name, 'Ông Công Ông Táo');
    });
  });

  group('Mùng 1 / Rằm thường', () {
    test('1/4 = Mùng một (không major)', () {
      final e = eventsForLunarDate(1, 4);
      expect(e.first.name, 'Mùng một (đầu tháng)');
      expect(e.first.isMajor, false);
    });
    test('15/3 = Ngày Rằm (không major)', () {
      expect(eventsForLunarDate(15, 3).first.name, 'Ngày Rằm');
      expect(eventsForLunarDate(15, 3).first.isMajor, false);
    });
    test('ngày thường không có sự kiện', () {
      expect(eventsForLunarDate(7, 7).isEmpty, true);
    });
  });

  group('hasMajorEvent', () {
    test('15/8 có lễ lớn', () => expect(hasMajorEvent(15, 8), true));
    test('15/3 không phải lễ lớn', () => expect(hasMajorEvent(15, 3), false));
    test('7/7 không có lễ', () => expect(hasMajorEvent(7, 7), false));
  });
}
