import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/luan_tuoi.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/core/tu_vi_data/tuoi_data.dart';

void main() {
  group('helper can/chi năm (1-based)', () {
    test('1988 = Mậu Thìn -> can 5, chi 5', () {
      expect(canNamCuaNam(1988), 5); // Mậu
      expect(chiNamCuaNam(1988), 5); // Thìn
    });

    test('2000 = Canh Thìn -> can 7, chi 5', () {
      expect(canNamCuaNam(2000), 7); // Canh
      expect(chiNamCuaNam(2000), 5); // Thìn
    });

    test('2008 = Mậu Tý -> chi 1 (Tý)', () {
      expect(chiNamCuaNam(2008), 1);
    });
  });

  group('tuHoaCuaCanNam', () {
    test('Giáp (can 1) đúng bộ sao và thứ tự Lộc/Quyền/Khoa/Kỵ', () {
      final t = tuHoaCuaCanNam(1);
      expect(t.map((e) => e.ten).toList(),
          ['Liêm trinh', 'Phá quân', 'Vũ khúc', 'Thái Dương']);
      expect(t.map((e) => e.hoa).toList(),
          ['Hóa lộc', 'Hóa quyền', 'Hóa khoa', 'Hóa kỵ']);
    });

    test('luôn trả về đúng 4 Hóa cho mọi can 1..10', () {
      for (var can = 1; can <= 10; can++) {
        expect(tuHoaCuaCanNam(can).length, 4, reason: 'can=$can');
      }
    });
  });

  test('hoaLaTot: Hóa kỵ = false, còn lại = true', () {
    expect(hoaLaTot('Hóa lộc'), isTrue);
    expect(hoaLaTot('Hóa quyền'), isTrue);
    expect(hoaLaTot('Hóa khoa'), isTrue);
    expect(hoaLaTot('Hóa kỵ'), isFalse);
  });

  group('luanTheoTuoi', () {
    final r = luanTheoTuoi(1988); // Mậu Thìn

    test('con giáp + can chi + bản mệnh đúng (1988 Mậu Thìn = Đại Lâm Mộc)', () {
      expect(r.canChiNam, 'Mậu Thìn');
      expect(r.conVat, 'Rồng');
      expect(r.banMenh, 'Mộc');
      expect(r.banMenhTen, 'Đại Lâm Mộc');
      expect(r.namSinh, 1988);
    });

    test('có nội dung tính cách + bản mệnh + disclaimer', () {
      expect(r.tinhCach.trim(), isNotEmpty);
      expect(r.banMenhYNghia.trim(), isNotEmpty);
      expect(r.disclaimer.trim(), isNotEmpty);
    });

    test('đúng 4 Hóa, mỗi Hóa có lĩnh vực + ý nghĩa; Lộc tốt, Kỵ cần lưu ý', () {
      expect(r.tuHoa.length, 4);
      for (final h in r.tuHoa) {
        expect(h.linhVuc.trim(), isNotEmpty, reason: h.sao);
        expect(h.yNghia.trim(), isNotEmpty, reason: h.hoa);
      }
      expect(r.tuHoa.first.tot, isTrue); // Hóa lộc
      expect(r.tuHoa.last.tot, isFalse); // Hóa kỵ
    });

    test('con giáp đổi theo năm (2008 = Chuột)', () {
      expect(luanTheoTuoi(2008).conVat, 'Chuột');
    });
  });

  test('guard: chế độ Dễ hiểu KHÔNG rò thuật ngữ nặng', () {
    final r = luanTheoTuoi(1988);
    final blob = [
      r.tinhCach,
      r.banMenhYNghia,
      ...r.tuHoa.map((h) => h.yNghia),
    ].join(' ');
    for (final jargon in ['Miếu', 'Hãm', 'đắc địa', 'Tuần', 'Triệt', 'Tả Hữu']) {
      expect(blob.contains(jargon), isFalse, reason: 'rò "$jargon"');
    }
  });

  group('luanTuoiVanXuoi (văn xuôi)', () {
    final r = luanTheoTuoi(1988);
    final vx = luanTuoiVanXuoi(r);

    test('có 3 đoạn (con giáp / bản mệnh / tứ hóa)', () {
      expect(vx.split('\n\n').length, 3);
    });

    test('nhắc con giáp, can chi, bản mệnh và đủ 4 sao Tứ Hóa', () {
      expect(vx.contains(r.conVat), isTrue);
      expect(vx.contains(r.canChiNam), isTrue);
      expect(vx.contains(r.banMenhTen), isTrue);
      for (final h in r.tuHoa) {
        expect(vx.contains(h.sao), isTrue, reason: h.sao);
        expect(vx.contains(h.hoa), isTrue, reason: h.hoa);
      }
    });

    test('xưng "bạn", KHÔNG dùng thầy–con', () {
      expect(vx.contains('bạn'), isTrue);
      expect(vx.contains('thầy'), isFalse);
      expect(vx.contains(' con '), isFalse);
    });
  });
}
