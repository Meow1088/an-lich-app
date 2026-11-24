import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/trach_nhat.dart';

void main() {
  final cuoi = viecList.firstWhere((v) => v.id == 'cuoi_hoi');

  test('findGoodDays đủ số ngày trong khoảng + xếp giảm dần', () {
    final list = findGoodDays(cuoi, DateTime(2026, 6, 1), DateTime(2026, 6, 30));
    expect(list.length, 30);
    for (var i = 1; i < list.length; i++) {
      expect(list[i - 1].score >= list[i].score, isTrue);
    }
  });

  test('19/6/2026 (5/5 ÂL) dính Dương Công cho cưới hỏi', () {
    final s = scoreDay(cuoi, 19, 6, 2026);
    expect(s.badReasons.any((r) => r.contains('Dương Công')), isTrue);
  });

  test('mapping score -> level đúng trên cả năm', () {
    final list =
        findGoodDays(cuoi, DateTime(2026, 1, 1), DateTime(2026, 12, 31));
    for (final s in list) {
      if (s.score >= 4) {
        expect(s.level, DayLevel.ratTot);
      } else if (s.score >= 1) {
        expect(s.level, DayLevel.tot);
      } else if (s.score == 0) {
        expect(s.level, DayLevel.binh);
      } else if (s.score >= -3) {
        expect(s.level, DayLevel.xau);
      } else {
        expect(s.level, DayLevel.ratXau);
      }
    }
  });

  test('DayLevel có nhãn tiếng Việt', () {
    expect(DayLevel.ratTot.label, 'Rất tốt');
    expect(DayLevel.ratXau.label, 'Rất xấu');
  });
}
