import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;
import 'package:lich_am/core/tu_vi_dien_giai.dart';

void main() {
  group('dữ liệu phụ tinh', () {
    test('mọi ý nghĩa đều không rỗng', () {
      expect(phuTinhYNghia, isNotEmpty);
      for (final e in phuTinhYNghia.entries) {
        expect(e.value.trim(), isNotEmpty, reason: 'Sao "${e.key}" thiếu ý nghĩa');
      }
    });

    test('sao cần lưu ý đều có trong bảng ý nghĩa', () {
      for (final s in saoCanLuuY) {
        expect(phuTinhYNghia.containsKey(s), isTrue,
            reason: 'Sao xấu "$s" chưa có ý nghĩa');
      }
    });

    test('phân cực tốt/xấu vài sao quen thuộc', () {
      expect(laSaoCanLuuY('Kình dương'), isTrue);
      expect(laSaoCanLuuY('Kiếp sát'), isTrue);
      expect(laSaoCanLuuY('Lộc tồn'), isFalse);
      expect(laSaoCanLuuY('Văn Khúc'), isFalse);
    });
  });

  group('diễn giải nhúng ý nghĩa phụ tinh', () {
    // Lá số mẫu đã verify khớp reference (28/6/1972 giờ Tý nam).
    final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);

    test('mỗi phụ tinh có dữ liệu đều xuất hiện trong dienGiaiCung (cả 2 chế độ)',
        () {
      var checked = 0;
      for (final cung in la.cung) {
        final sau = dienGiaiCung(cung, mode: CheDoXem.chuyenSau);
        final coBan = dienGiaiCung(cung, mode: CheDoXem.coBan);
        for (final s in cung.sao) {
          final yn = yNghiaPhuTinh(s.ten);
          if (yn == null) continue;
          checked++;
          expect(sau.contains(yn), isTrue,
              reason: 'Chuyên sâu cung ${cung.tenCung} thiếu ý nghĩa ${s.ten}');
          expect(coBan.contains(yn), isTrue,
              reason: 'Cơ bản cung ${cung.tenCung} thiếu ý nghĩa ${s.ten}');
        }
      }
      // Lá số mẫu chắc chắn có ít nhất vài phụ tinh được diễn giải.
      expect(checked, greaterThan(0));
    });

    test('mọi CHÍNH TINH trên lá số đều khớp tên trong bảng tính chất', () {
      // Chặn lỗi lệch hoa/thường (vd "Thái Dương" vs "Thái dương").
      for (final cung in la.cung) {
        for (final s in cung.chinhTinh) {
          expect(chinhTinhTinhChat.containsKey(s.ten), isTrue,
              reason: 'Chính tinh "${s.ten}" thiếu trong chinhTinhTinhChat');
        }
      }
    });
  });
}
