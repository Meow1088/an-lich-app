import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/hop_tuoi.dart';

void main() {
  test('lục hợp Tý-Sửu, Ngọ-Mùi', () {
    expect(isLucHop(0, 1), isTrue);
    expect(isLucHop(6, 7), isTrue);
    expect(isLucHop(0, 2), isFalse);
  });
  test('lục hại Tý-Mùi, Dậu-Tuất', () {
    expect(isLucHai(0, 7), isTrue);
    expect(isLucHai(9, 10), isTrue);
    expect(isLucHai(0, 1), isFalse);
  });
  test('chiXongDat(Tý) = Thân, Thìn (tam hợp) + Sửu (lục hợp)', () {
    expect(chiXongDat(0).toSet(), {1, 4, 8});
  });
  test('hợp tuổi: 2008 Tý - 2012 Thìn = chi Tam hợp, chi điểm +1', () {
    final r = hopTuoiVoChong(2008, 2012);
    expect(r.chiQuanHe, 'Tam hợp');
    expect(r.chiDiem, 1);
    expect(r.ket.isNotEmpty, isTrue);
  });
  test('hợp tuổi: chi xung -> Không hợp khi mệnh cũng khắc', () {
    // Tý(0) - Ngọ(6) tứ hành xung
    final r = hopTuoiVoChong(2008, 2014); // 2014 Giáp Ngọ
    expect(r.chiQuanHe, 'Tứ hành xung');
    expect(r.chiDiem, -1);
  });
}
