import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/van_han_12_thang.dart';

void main() {
  group('VanHan12Thang Core Tests', () {
    test('vanHan12Thang returns 12 months for a given profile and year', () {
      final birthDate = DateTime(1990, 5, 15);
      final res = vanHan12Thang(
        birthDate: birthDate,
        birthLunarYear: 1990,
        isNam: true,
        lunarYearTarget: 2026,
      );

      expect(res.lunarYear, equals(2026));
      expect(res.canChiYear, equals('Bính Ngọ'));
      expect(res.thangs.length, equals(12));

      // Each month should have valid values
      for (final t in res.thangs) {
        expect(t.thangAm, greaterThanOrEqualTo(1));
        expect(t.thangAm, lessThanOrEqualTo(12));
        expect(t.canChiThang, isNotEmpty);
        expect(t.taiLocSao, greaterThanOrEqualTo(1));
        expect(t.taiLocSao, lessThanOrEqualTo(5));
        expect(t.congDanhSao, greaterThanOrEqualTo(1));
        expect(t.congDanhSao, lessThanOrEqualTo(5));
        expect(t.sucKhoeSao, greaterThanOrEqualTo(1));
        expect(t.sucKhoeSao, lessThanOrEqualTo(5));
        expect(t.tinhCamSao, greaterThanOrEqualTo(1));
        expect(t.tinhCamSao, lessThanOrEqualTo(5));
        expect(t.nhatDinh, isIn(['Cát', 'Bình hòa', 'Cần chú ý']));
        expect(t.moTaChiTiet, isNotEmpty);
        expect(t.loiKhuyen, isNotEmpty);
      }

      expect(res.tongQuanNam, isNotEmpty);
    });
  });
}
