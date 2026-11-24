import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/xem_tuoi.dart';

void main() {
  group('Kim Lâu', () {
    test('55 tuổi mụ -> Kim Lâu Thân (ví dụ chuẩn)', () {
      final k = kimLau(55);
      expect(k.pham, isTrue);
      expect(k.loai, 'Thân');
    });
    test('dư 3/6/8 -> Thê/Tử/Lục Súc', () {
      expect(kimLau(12).loai, 'Thê'); // 12%9=3
      expect(kimLau(33).loai, 'Tử'); // 33%9=6
      expect(kimLau(26).loai, 'Lục Súc'); // 26%9=8
    });
    test('không phạm khi dư khác 1,3,6,8', () {
      expect(kimLau(54).pham, isFalse); // 54%9=0
      expect(kimLau(50).pham, isFalse); // 50%9=5
    });
  });

  group('Hoang Ốc', () {
    test('mốc thập niên', () {
      expect(hoangOc(10).cung, 'Nhất Cát');
      expect(hoangOc(20).cung, 'Nhì Nghi');
      expect(hoangOc(24).cung, 'Lục Hoang Ốc');
      expect(hoangOc(25).cung, 'Nhất Cát');
    });
    test('cung xấu đúng theo danh sách tuổi tránh', () {
      for (final t in [12, 14, 15, 21, 23, 24, 30]) {
        expect(hoangOc(t).tot, isFalse, reason: 'tuổi $t');
      }
      expect(hoangOc(20).tot, isTrue);
      expect(hoangOc(22).tot, isTrue); // Tứ Tấn Tài
    });
  });

  group('Tam Tai', () {
    test('Thân Tý Thìn -> Dần Mão Thìn', () {
      expect(tamTaiYears(8), [2, 3, 4]);
      expect(isTamTai(0, 2), isTrue); // Tý gặp năm Dần
      expect(isTamTai(0, 6), isFalse);
    });
    test('Tỵ Dậu Sửu -> Hợi Tý Sửu', () {
      expect(isTamTai(5, 11), isTrue); // Tỵ gặp năm Hợi
      expect(isTamTai(9, 0), isTrue); // Dậu gặp năm Tý
    });
  });

  group('Tam hợp / Tứ hành xung', () {
    test('tam hợp Tý = Thân Tý Thìn', () {
      final g = tamHopOf(0);
      expect(g.contains(8), isTrue);
      expect(g.contains(4), isTrue);
    });
    test('tứ hành xung Tý = Tý Ngọ Mão Dậu', () {
      final g = tuHanhXungOf(0);
      expect(g.toSet(), {0, 6, 3, 9});
    });
    test('lục xung đối đỉnh', () {
      expect(lucXungOf(0), 6); // Tý - Ngọ
      expect(lucXungOf(2), 8); // Dần - Thân
    });
  });

  test('yearChiIndex: 2026 = Ngọ (Bính Ngọ)', () {
    expect(yearChiIndex(2026), 6);
  });
}
