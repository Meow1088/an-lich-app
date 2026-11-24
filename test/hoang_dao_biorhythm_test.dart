import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/hoang_dao.dart';
import 'package:lich_am/core/biorhythm.dart';

void main() {
  group('giờ hoàng đạo', () {
    test('mỗi ngày có đúng 6 giờ hoàng đạo', () {
      expect(luckyHours(17, 2, 2026).length, 6);
      expect(luckyHours(1, 1, 2024).length, 6);
      expect(luckyHours(30, 6, 2025).length, 6);
    });

    test('giờ hoàng đạo có tên chi & khung giờ hợp lệ', () {
      for (final h in luckyHours(17, 2, 2026)) {
        expect(gioChiNames.contains(h.chi), true);
        expect(h.range.contains('–'), true);
      }
    });
  });

  group('ngày hoàng đạo/hắc đạo', () {
    test('trả về nhãn hợp lệ', () {
      final q = dayQuality(17, 2, 2026);
      expect(q.isHoangDao, anyOf(true, false));
      expect(q.label, anyOf('Hoàng đạo', 'Hắc đạo'));
      expect(q.star.isNotEmpty, true);
    });
  });

  group('biorhythm', () {
    final birth = DateTime(1990, 5, 15);

    test('ngày sinh: cả 3 sóng = 0', () {
      expect(daysSinceBirth(birth, birth), 0);
      expect(physical(birth, birth).abs() < 1e-9, true);
      expect(emotional(birth, birth).abs() < 1e-9, true);
      expect(intellectual(birth, birth).abs() < 1e-9, true);
    });

    test('sau đúng 1 chu kỳ giá trị quay về ~0', () {
      expect(physical(birth, birth.add(Duration(days: 23))).abs() < 1e-9, true);
      expect(emotional(birth, birth.add(Duration(days: 28))).abs() < 1e-9, true);
      expect(
          intellectual(birth, birth.add(Duration(days: 33))).abs() < 1e-9, true);
    });

    test('giá trị luôn trong [-1, 1]', () {
      for (var d = 0; d < 100; d++) {
        final v = physical(birth, birth.add(Duration(days: d)));
        expect(v >= -1.0 && v <= 1.0, true);
      }
    });
  });
}
