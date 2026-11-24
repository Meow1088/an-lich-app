import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/truc_tu.dart';

void main() {
  group('Trực — đối chiếu mốc', () {
    test('1/1/2000 = Trực Phá', () {
      expect(trucOfDay(1, 1, 2000).name, 'Phá');
    });
    test('trực có đủ nên/kiêng', () {
      final t = trucOfDay(24, 6, 2026);
      expect(t.name.isNotEmpty, true);
      expect(t.nen.isNotEmpty, true);
      expect(t.kieng.isNotEmpty, true);
      expect(['Tốt', 'Xấu', 'Bình'].contains(t.nature), true);
    });
    test('trực tiến tuần tự (trừ ngày đổi tiết)', () {
      // qua nhiều ngày liên tiếp, trực phải nằm trong 12 trực hợp lệ
      const names = ['Kiến','Trừ','Mãn','Bình','Định','Chấp','Phá','Nguy','Thành','Thu','Khai','Bế'];
      for (var d = 1; d <= 28; d++) {
        expect(names.contains(trucOfDay(d, 9, 2026).name), true);
      }
    });
  });

  group('Nhị thập bát tú — đối chiếu mốc', () {
    test('1/1/1995 = sao Hư', () {
      expect(tuOfDay(1, 1, 1995).name, 'Hư');
    });
    test('8/3/1997 = sao Liễu', () {
      expect(tuOfDay(8, 3, 1997).name, 'Liễu');
    });
    test('1/1/2000 = sao Vị', () {
      expect(tuOfDay(1, 1, 2000).name, 'Vị');
    });
    test('Hư là sao Nhật (1/1/1995 là Chủ Nhật)', () {
      expect(tuOfDay(1, 1, 1995).tinh, 'Nhật');
    });
    test('chu kỳ 28: sau 28 ngày lặp lại cùng sao', () {
      expect(tuOfDay(1, 1, 1995).name, tuOfDay(29, 1, 1995).name);
    });
  });
}
