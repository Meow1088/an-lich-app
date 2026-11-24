import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;
import 'package:lich_am/core/tu_vi_tong_hop.dart';

void main() {
  // Lá số mẫu đã verify khớp reference (28/6/1972 giờ Tý nam).
  final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);

  group('bộ sao', () {
    test('cung 2 chính tinh có bộ sao, cung 0/1 chính tinh thì null', () {
      for (final cung in la.cung) {
        final bs = boSaoCung(cung);
        if (cung.chinhTinh.length == 2) {
          expect(bs, isNotNull, reason: 'Cung ${cung.tenCung} thiếu bộ sao');
          expect(bs!.trim(), isNotEmpty);
        } else {
          expect(bs, isNull, reason: 'Cung ${cung.tenCung} không nên có bộ sao');
        }
      }
    });
  });

  group('cách cục', () {
    test('Mệnh lá số mẫu thuộc Tử Phủ Vũ Tướng', () {
      final cc = cachCucMenh(la);
      expect(cc, contains('Tử Phủ Vũ Tướng'));
    });
  });

  group('xung chiếu', () {
    test('đối cung đúng cặp và đối xứng', () {
      expect(doiCungCua('Mệnh'), 'Thiên di');
      expect(doiCungCua('Thiên di'), 'Mệnh');
      expect(doiCungCua('Quan lộc'), 'Phu thê');
      expect(doiCungCua('Tài bạch'), 'Phúc đức');
    });
  });

  group('vận hạn', () {
    test('tính đúng tuổi mụ + có đại/tiểu hạn (năm 2026)', () {
      final v = vanHanNam(la, now: DateTime(2026, 6, 29));
      expect(v.tuoiMu, 55); // 2026 - 1972 + 1
      expect(v.namCanChi.trim(), isNotEmpty);
      expect(v.daiHanCung.trim(), isNotEmpty);
      expect(v.tieuHanCung.trim(), isNotEmpty);
      expect(v.nhanXet.trim(), isNotEmpty);
      // Đại vận phải chứa tuổi 55 trong khoảng [daiHanTu, +9].
      expect(55 >= v.daiHanTu && 55 <= v.daiHanTu + 9, isTrue);
    });

    test('tất định (gọi 2 lần như nhau)', () {
      final a = vanHanNam(la, now: DateTime(2026, 6, 29));
      final b = vanHanNam(la, now: DateTime(2026, 6, 29));
      expect(a.nhanXet, b.nhanXet);
    });
  });
}
