import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/ngay_via.dart';

void main() {
  group('Ngày vía', () {
    test('Thần Tài 10/1', () {
      final v = viaOnDate(10, 1);
      expect(v.any((e) => e.name.contains('Thần Tài')), isTrue);
    });
    test('Quan Âm 19/2, 19/6, 19/9', () {
      expect(viaOnDate(19, 2).any((e) => e.name.contains('Quan Âm')), isTrue);
      expect(viaOnDate(19, 6).any((e) => e.name.contains('Quan Âm')), isTrue);
      expect(viaOnDate(19, 9).any((e) => e.name.contains('Quan Âm')), isTrue);
    });
    test('Ông Táo 23/12', () {
      expect(viaOnDate(23, 12).any((e) => e.name.contains('Táo')), isTrue);
    });
    test('ngày thường không có vía', () => expect(viaOnDate(11, 3), isEmpty));
  });

  group('Lịch ăn chay', () {
    test('Thập trai = 1,8,14,15,18,23,24,28,29,30', () {
      for (final d in [1, 8, 14, 15, 18, 23, 24, 28, 29, 30]) {
        expect(isChay(ChayType.thap, d), isTrue, reason: 'ngày $d');
      }
      expect(isChay(ChayType.thap, 2), isFalse);
    });
    test('Nhị trai = 1,15', () {
      expect(chayDays[ChayType.nhi], {1, 15});
    });
    test('chayTypesOf: ngày 15 thuộc cả 4 chế độ', () {
      expect(chayTypesOf(15).length, 4);
    });
    test('chayTypesOf: ngày 8 chỉ lục+thập', () {
      final t = chayTypesOf(8);
      expect(t.contains(ChayType.luc), isTrue);
      expect(t.contains(ChayType.thap), isTrue);
      expect(t.contains(ChayType.nhi), isFalse);
    });
  });
}
