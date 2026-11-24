import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/ngay_xau.dart';

void main() {
  group('Tam Nương / Nguyệt kỵ', () {
    test('Tam Nương = 3,7,13,18,22,27', () {
      for (final d in [3, 7, 13, 18, 22, 27]) {
        expect(isTamNuong(d), isTrue, reason: 'ngày $d');
      }
      expect(isTamNuong(4), isFalse);
      expect(isTamNuong(1), isFalse);
    });
    test('Nguyệt kỵ = 5,14,23', () {
      for (final d in [5, 14, 23]) {
        expect(isNguyetKy(d), isTrue, reason: 'ngày $d');
      }
      expect(isNguyetKy(6), isFalse);
    });
  });

  group('Dương Công kỵ nhật', () {
    test('mốc đầu 13 tháng Giêng', () => expect(isDuongCong(13, 1), isTrue));
    test('tháng 7 có 2 ngày 8 và 29', () {
      expect(isDuongCong(8, 7), isTrue);
      expect(isDuongCong(29, 7), isTrue);
    });
    test('tháng 12 = ngày 19', () => expect(isDuongCong(19, 12), isTrue));
    test('ngày thường không dính', () => expect(isDuongCong(14, 1), isFalse));
  });

  group('Sát chủ', () {
    // chi: Tý0 Sửu1 Dần2 Mão3 Thìn4 Tỵ5 Ngọ6 Mùi7 Thân8 Dậu9 Tuất10 Hợi11
    test('Sát chủ Dương: T1=Tý, T4=Tuất, T11=Mùi', () {
      expect(isSatChuDuong(0, 1), isTrue);
      expect(isSatChuDuong(10, 4), isTrue);
      expect(isSatChuDuong(7, 11), isTrue);
      expect(isSatChuDuong(0, 2), isFalse);
    });
    test('Sát chủ Âm: T1=Tỵ, T7=Hợi, T12=Thìn', () {
      expect(isSatChuAm(5, 1), isTrue);
      expect(isSatChuAm(11, 7), isTrue);
      expect(isSatChuAm(4, 12), isTrue);
      expect(isSatChuAm(0, 1), isFalse);
    });
  });
}
