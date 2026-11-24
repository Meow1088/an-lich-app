import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;
import 'package:lich_am/core/tu_vi_dien_giai.dart';

void main() {
  // Lớp diễn giải SÂU phải phủ đủ 14 chính tinh cho các cung trọng yếu.
  final cungSau = {
    'Mệnh': menhChinhTinh,
    'Tài bạch': taiBachChinhTinh,
    'Quan lộc': quanLocChinhTinh,
    'Phu thê': phuTheChinhTinh,
    'Phúc đức': phucDucChinhTinh,
  };

  group('diễn giải sâu chính tinh theo cung', () {
    test('mỗi cung trọng yếu có đủ 14 chính tinh', () {
      for (final entry in cungSau.entries) {
        for (final sao in chinhTinhTinhChat.keys) {
          expect(
            entry.value.containsKey(sao),
            isTrue,
            reason: 'Thiếu "$sao" trong cung ${entry.key}',
          );
        }
        expect(entry.value.length, 14, reason: 'Cung ${entry.key} sai số sao');
      }
    });

    test('dienGiaiSauChinhTinh trả lớp sâu cho cung trọng yếu', () {
      expect(dienGiaiSauChinhTinh('Tài bạch', 'Vũ khúc'), isNotNull);
      expect(dienGiaiSauChinhTinh('Quan lộc', 'Tử vi'), isNotNull);
      expect(dienGiaiSauChinhTinh('Phu thê', 'Thái âm'), isNotNull);
      expect(dienGiaiSauChinhTinh('Phúc đức', 'Thiên đồng'), isNotNull);
      expect(dienGiaiSauChinhTinh('Mệnh', 'Phá quân'), isNotNull);
    });

    test('cung KHÔNG có lớp sâu trả null (luận theo tính chất chung)', () {
      expect(dienGiaiSauChinhTinh('Thiên di', 'Tử vi'), isNull);
      expect(dienGiaiSauChinhTinh('Tật ách', 'Vũ khúc'), isNull);
      expect(dienGiaiSauChinhTinh('Tài bạch', 'Sao không tồn tại'), isNull);
    });

    test('dienGiaiCung dùng lớp sâu khi chính tinh nằm ở cung trọng yếu', () {
      // Lá số mẫu đã verify khớp reference (28/6/1972 giờ Tý nam).
      final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);
      for (final cung in la.cung) {
        if (!cungSau.containsKey(cung.tenCung)) continue;
        for (final sao in cung.chinhTinh) {
          final sau = dienGiaiSauChinhTinh(cung.tenCung, sao.ten);
          if (sau == null) continue; // sao không phải 1 trong 14 chính tinh
          // Chuyên sâu viết hoa chữ đầu lớp diễn giải để đứng thành câu → chấp
          // nhận cả bản gốc lẫn bản hoa hóa chữ đầu.
          final sauHoa = sau[0].toUpperCase() + sau.substring(1);
          final out = dienGiaiCung(cung);
          expect(
            out.contains(sau) || out.contains(sauHoa),
            isTrue,
            reason: 'dienGiaiCung(${cung.tenCung}) bỏ sót lớp sâu của ${sao.ten}',
          );
        }
      }
    });
  });
}
