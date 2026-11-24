import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/than_so.dart';

void main() {
  test('28/6/1972 -> số chủ đạo 8', () {
    expect(soChuDao(28, 6, 1972), 8); // 10+6+19=35 -> 8
  });
  test('1/1/2000 -> 4', () => expect(soChuDao(1, 1, 2000), 4));
  test('giữ số bậc thầy hoặc rút về 1..9', () {
    final s = soChuDao(29, 11, 1991);
    expect(s == 11 || (s >= 1 && s <= 9) || s == 22, isTrue);
  });
  test('mỗi số có đủ thông tin chi tiết', () {
    final ts = thanSoOf(8);
    expect(ts.tieuDe.contains('8'), isTrue);
    expect(ts.diemManh.isNotEmpty, isTrue);
    expect(ts.diemYeu.isNotEmpty, isTrue);
    expect(ts.suNghiep.isNotEmpty, isTrue);
    expect(ts.loiKhuyen.isNotEmpty, isTrue);
    expect(thanSoOf(11).tieuDe.isNotEmpty, isTrue);
  });
}
