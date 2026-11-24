import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;
import 'package:lich_am/core/tu_vi_tong_hop.dart';

void main() {
  // Lá số mẫu đã verify khớp reference (28/6/1972 giờ Tý nam).
  final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);

  group('chấm điểm cung', () {
    test('mọi cung cho điểm 1..5', () {
      for (final cung in la.cung) {
        final s = diemCung(cung);
        expect(s, inInclusiveRange(1, 5), reason: 'Cung ${cung.tenCung}');
      }
    });

    test('saoChuoi đúng số sao đặc/rỗng', () {
      expect(saoChuoi(4), '★★★★☆');
      expect(saoChuoi(5), '★★★★★');
      expect(saoChuoi(1), '★☆☆☆☆');
    });

    test('kết quả tất định (gọi 2 lần như nhau)', () {
      final a = diemCung(la.cungMenh);
      final b = diemCung(la.cungMenh);
      expect(a, b);
    });
  });

  group('chấm theo chủ đề', () {
    test('đủ 5 chủ đề, mỗi chủ đề hợp lệ', () {
      final cd = chamChuDe(la);
      expect(cd.length, 5);
      const ten = {'Tình duyên', 'Tài chính', 'Sự nghiệp', 'Sức khỏe', 'Con cái'};
      for (final c in cd) {
        expect(ten.contains(c.ten), isTrue);
        expect(c.sao, inInclusiveRange(1, 5));
        expect(c.nhanXet.trim(), isNotEmpty);
      }
    });
  });

  group('tổng kết', () {
    test('có điểm mạnh / nghề hợp / lời khuyên', () {
      final tk = tongKet(la);
      expect(tk.diemManh, isNotEmpty);
      expect(tk.ngheHop, isNotEmpty);
      expect(tk.loiKhuyen.trim(), isNotEmpty);
    });

    test('Mệnh có chính tinh thì điểm yếu không rỗng', () {
      // Mệnh lá số mẫu có chính tinh → phải gom được điểm cần lưu ý.
      if (la.cungMenh.chinhTinh.isNotEmpty) {
        expect(tongKet(la).diemYeu, isNotEmpty);
      }
    });
  });
}
