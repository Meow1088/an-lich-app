import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/bat_trach.dart';

String _star(BatTrach b, String huong) =>
    b.huongs.firstWhere((h) => h.huong == huong).duTinh.name;

void main() {
  group('Cung phi', () {
    test('nam 1972 = Khảm (Ngô Bảo Châu)', () {
      expect(cungPhi(1972, true), 0);
    });
    test('nam 1969 = Tốn', () => expect(cungPhi(1969, true), 3));
    test('nữ 1970 = Chấn', () => expect(cungPhi(1970, false), 2));
    test('nam 1985 = Càn', () => expect(cungPhi(1985, true), 7));
  });

  group('Du tinh — cung Khảm (1972 nam)', () {
    final b = batTrachOf(1972, true);
    test('Đông tứ mệnh, mệnh Thủy', () {
      expect(b.dongTu, isTrue);
      expect(b.menh, 'Thủy');
    });
    test('Sinh Khí ở Đông Nam', () => expect(_star(b, 'Đông Nam'), 'Sinh Khí'));
    test('Thiên Y ở Đông', () => expect(_star(b, 'Đông'), 'Thiên Y'));
    test('Diên Niên ở Nam', () => expect(_star(b, 'Nam'), 'Diên Niên'));
    test('Phục Vị ở Bắc', () => expect(_star(b, 'Bắc'), 'Phục Vị'));
    test('Tuyệt Mệnh ở Tây Nam', () =>
        expect(_star(b, 'Tây Nam'), 'Tuyệt Mệnh'));
    test('4 tốt 4 xấu', () {
      expect(b.tot.length, 4);
      expect(b.xau.length, 4);
    });
  });

  group('Du tinh — cung Càn (1985 nam)', () {
    final b = batTrachOf(1985, true);
    test('Tây tứ mệnh, mệnh Kim', () {
      expect(b.dongTu, isFalse);
      expect(b.menh, 'Kim');
    });
    test('Sinh Khí ở Tây', () => expect(_star(b, 'Tây'), 'Sinh Khí'));
    test('Diên Niên ở Tây Nam', () =>
        expect(_star(b, 'Tây Nam'), 'Diên Niên'));
    test('Tuyệt Mệnh ở Nam', () => expect(_star(b, 'Nam'), 'Tuyệt Mệnh'));
  });
}
