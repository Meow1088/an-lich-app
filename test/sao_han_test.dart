import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/sao_han.dart';

void main() {
  test('nam 10 tuổi = La Hầu (xấu)', () {
    final s = saoHanOf(10, true);
    expect(s.name, 'La Hầu');
    expect(s.xau, isTrue);
  });
  test('nữ 10 tuổi = Kế Đô', () {
    expect(saoHanOf(10, false).name, 'Kế Đô');
  });
  test('nam 31 = Thái Bạch (hung), nữ 31 = Thái Âm (cát)', () {
    expect(saoHanOf(31, true).name, 'Thái Bạch');
    expect(saoHanOf(31, true).xau, isTrue);
    expect(saoHanOf(31, false).name, 'Thái Âm');
    expect(saoHanOf(31, false).tot, isTrue);
  });
  test('chu kỳ 9 năm lặp lại', () {
    expect(saoHanOf(19, true).name, saoHanOf(10, true).name);
  });
}
