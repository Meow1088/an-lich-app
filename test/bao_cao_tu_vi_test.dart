import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/core/bao_cao_tu_vi.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;

BaoCaoTuVi _mau() {
  // Lá số mẫu đã verify khớp reference (28/6/1972 giờ Tý nam).
  final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);
  return baoCaoTongQuan(la,
      name: 'Ngô Bảo Châu',
      birthDate: DateTime(1972, 6, 28),
      genderLabel: 'Nam',
      hourChi: 0);
}

String _flatMuc(BaoCaoMuc m) =>
    '${m.tieuDe}|${m.sao}|${m.doan.join("¶")}|${m.nen.join(",")}|'
    '${m.tranh.join(",")}|${m.diem.map((d) => "${d.ten}:${d.sao}").join(",")}';

String _flat(BaoCaoTuVi b) => [
      b.tieuDe,
      ...b.hoSo.entries.map((e) => '${e.key}:${e.value}'),
      b.disclaimer,
      _flatMuc(b.tomTat),
      for (final m in b.mucs) _flatMuc(m),
      for (final t in b.timeline) '${t.tuoi}|${t.sao}|${t.trongTam}',
    ].join('\n');

bool _coNoiDung(BaoCaoMuc m) =>
    m.doan.any((d) => d.trim().isNotEmpty) ||
    m.nen.isNotEmpty ||
    m.tranh.isNotEmpty ||
    m.diem.isNotEmpty;

void main() {
  group('baoCaoTongQuan', () {
    test('có hồ sơ, disclaimer, tóm tắt điều hành và các mục chính', () {
      final b = _mau();
      expect(b.hoSo['Họ tên'], 'Ngô Bảo Châu');
      expect(b.disclaimer.contains('tham khảo'), isTrue);
      expect(b.tomTat.tieuDe, 'Tóm tắt điều hành');
      expect(b.tomTat.diem.length, 5); // 5 chủ đề

      final tieuDes = b.mucs.map((m) => m.tieuDe).toList();
      for (final t in [
        'Tính cách',
        'Sự nghiệp',
        'Tài chính',
        'Sức khỏe',
        'Quan hệ xã hội',
        'Độ phù hợp nghề nghiệp',
        'Kế hoạch hành động',
      ]) {
        expect(tieuDes.contains(t), isTrue, reason: 'Thiếu mục "$t"');
      }
    });

    test('mọi mục có nội dung; điểm sao và điểm biểu đồ hợp lệ 1..5', () {
      final b = _mau();
      void kiem(BaoCaoMuc m) {
        expect(_coNoiDung(m), isTrue, reason: '${m.tieuDe} rỗng');
        if (m.sao != null) expect(m.sao, inInclusiveRange(1, 5));
        for (final d in m.diem) {
          expect(d.sao, inInclusiveRange(1, 5));
          expect(d.ten.trim(), isNotEmpty);
        }
      }
      kiem(b.tomTat);
      b.mucs.forEach(kiem);
    });

    test('có timeline đại vận, mỗi mốc điểm 1..5', () {
      final b = _mau();
      expect(b.timeline, isNotEmpty);
      for (final t in b.timeline) {
        expect(t.sao, inInclusiveRange(1, 5));
        expect(t.tuoi.contains('tuổi'), isTrue);
        expect(t.trongTam.trim(), isNotEmpty);
      }
    });

    test('độ phù hợp nghề có 5 hướng', () {
      final b = _mau();
      final dp = b.mucs.firstWhere((m) => m.tieuDe == 'Độ phù hợp nghề nghiệp');
      expect(dp.diem.length, 5);
    });

    test('tất định (gọi 2 lần cho kết quả như nhau)', () {
      expect(_flat(_mau()), _flat(_mau()));
    });

    test('giờ không rõ -> hồ sơ ghi Không rõ', () {
      final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);
      final b = baoCaoTongQuan(la,
          birthDate: DateTime(1972, 6, 28),
          genderLabel: 'Nam',
          hourChi: null,
          gioGhiChu: ' (không rõ — luận tổng quát)');
      expect(b.hoSo['Giờ sinh']!.contains('Không rõ'), isTrue);
    });
  });
}
