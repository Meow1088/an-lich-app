import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;

/// Đối chiếu engine an sao với 3 lá số chuẩn sinh từ phần mềm mã nguồn mở
/// `doanguyen/lasotuvi` (MIT). Fixture: test/tu_vi_fixture.json.
void main() {
  final raw = File('test/tu_vi_fixture.json').readAsStringSync();
  final cases = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

  for (final c in cases) {
    final solar = (c['solar'] as List).cast<int>(); // [d,m,y]
    final gio = c['gio'] as int; // 1-based chi
    final gt = c['gt'] as int;
    final gender = gt == 1 ? Gender.nam : Gender.nu;
    final label = '${solar[0]}/${solar[1]}/${solar[2]} giờ #$gio ${gender.name}';

    test('Lá số khớp reference: $label', () {
      final la = lapLaSoTuDuong(
        DateTime(solar[2], solar[1], solar[0]),
        gio - 1,
        gender,
      );

      // Ngày âm khớp.
      final lunar = (c['lunar'] as List).cast<int>();
      expect([la.lunar.day, la.lunar.month, la.lunar.year], lunar,
          reason: 'lunar $label');

      // Cung Mệnh / Thân.
      expect(la.viTriMenh, c['cungMenh'], reason: 'cung Mệnh $label');
      expect(la.viTriThan, c['cungThan'], reason: 'cung Thân $label');

      // Từng cung: tập sao + đại/tiểu hạn + thân + tuần/triệt.
      for (final ecu in (c['cungs'] as List).cast<Map<String, dynamic>>()) {
        final v = ecu['cung'] as int;
        final cung = la.cung.firstWhere((x) => x.viTri == v);

        final got = cung.sao.map((s) => s.ten).toList()..sort();
        final want = (ecu['sao'] as List).cast<String>().toList()..sort();
        expect(got, want, reason: 'sao cung $v ($label)');

        expect(cung.daiHanTu, ecu['daiHan'], reason: 'đại hạn cung $v ($label)');
        expect(cung.tieuHanChi, ecu['tieuHan'],
            reason: 'tiểu hạn cung $v ($label)');
        expect(cung.laThan, ecu['than'], reason: 'thân cung $v ($label)');
        expect(cung.tuan, ecu['tuan'], reason: 'tuần cung $v ($label)');
        expect(cung.triet, ecu['triet'], reason: 'triệt cung $v ($label)');
      }
    });
  }

  test('Cục + mệnh chủ lá số mẫu (28/6/1972 giờ Tý nam)', () {
    final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);
    expect(la.cucSo, 2); // Thủy nhị cục
    expect(la.cucTen, 'Thủy nhị Cục');
    expect(la.canChiNam, 'Nhâm Tý');
    expect(la.amDuongMenh, 'Dương Nam');
    // Cung Mệnh ở Ngọ (viTri 7) -> mệnh chủ Phá quân.
    expect(la.menhChu, 'Phá quân');
    expect(la.cungMenh.voChinhDieu, isFalse);
  });
}
