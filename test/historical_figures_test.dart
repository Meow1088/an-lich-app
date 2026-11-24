import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/historical_figures.dart';

void main() {
  test('19/5 = Hồ Chí Minh sinh năm 1890', () {
    final f = figuresOnDate(5, 19);
    expect(f, isNotEmpty);
    expect(f.first.name, 'Hồ Chí Minh');
    expect(f.first.birthYear, 1890);
  });

  test('28/6 = Ngô Bảo Châu 1972; 25/8 = Võ Nguyên Giáp 1911', () {
    expect(figuresOnDate(6, 28).first.name, 'Ngô Bảo Châu');
    expect(figuresOnDate(6, 28).first.birthYear, 1972);
    expect(figuresOnDate(8, 25).first.name, 'Võ Nguyên Giáp');
    expect(figuresOnDate(8, 25).first.birthYear, 1911);
  });

  test('ngày không có danh nhân -> rỗng', () {
    expect(figuresOnDate(6, 25), isEmpty);
  });

  test('1 ngày nhiều danh nhân: 12/2 = Darwin + Lincoln (cùng 1809)', () {
    final f = figuresOnDate(2, 12);
    expect(f.length, 2);
    expect(f.map((e) => e.name),
        containsAll(['Charles Darwin', 'Abraham Lincoln']));
  });
}
