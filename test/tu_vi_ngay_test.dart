import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi_ngay.dart';

void main() {
  final birth = DateTime(1972, 6, 28);
  final today = DateTime(2026, 6, 26);

  test('trả 4 mục, mỗi mục 1..5 sao', () {
    final tv = tuViNgay(birth, 1972, today);
    expect(tv.mucs.length, 4);
    expect(tv.mucs.map((m) => m.label).toList(),
        ['Tài lộc', 'Công việc', 'Sức khỏe', 'Tình cảm']);
    for (final m in tv.mucs) {
      expect(m.sao >= 1 && m.sao <= 5, isTrue);
      expect(m.moTa.isNotEmpty, isTrue);
    }
  });

  test('tổng sao = tổng các mục, nằm trong [4,20]', () {
    final tv = tuViNgay(birth, 1972, today);
    expect(tv.tongSao, tv.mucs.fold(0, (a, m) => a + m.sao));
    expect(tv.tongSao >= 4 && tv.tongSao <= 20, isTrue);
    expect(tv.tongQuan.isNotEmpty, isTrue);
  });

  test('xác định (deterministic) — cùng input cho cùng kết quả', () {
    final a = tuViNgay(birth, 1972, today);
    final b = tuViNgay(birth, 1972, today);
    expect(a.tongSao, b.tongSao);
    expect(a.mucs[0].sao, b.mucs[0].sao);
  });

  test('ngày khác cho kết quả có thể khác', () {
    final a = tuViNgay(birth, 1972, DateTime(2026, 1, 1));
    final b = tuViNgay(birth, 1972, DateTime(2026, 7, 15));
    // ít nhất tổng sao hợp lệ ở cả hai
    expect(a.tongSao >= 4, isTrue);
    expect(b.tongSao >= 4, isTrue);
  });
}
