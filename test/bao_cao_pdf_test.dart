import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/tu_vi.dart';
import 'package:lich_am/core/bao_cao_tu_vi.dart';
import 'package:lich_am/services/bao_cao_pdf.dart';
import 'package:lich_am/data/profile_store.dart' show Gender;

BaoCaoTuVi _mau() {
  final la = lapLaSoTuDuong(DateTime(1972, 6, 28), 0, Gender.nam);
  return baoCaoTongQuan(la,
      name: 'Ngô Bảo Châu',
      birthDate: DateTime(1972, 6, 28),
      genderLabel: 'Nam',
      hourChi: 0);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('BaoCaoPdf.build dựng PDF không lỗi bố cục, trả bytes hợp lệ', () async {
    final bytes = await BaoCaoPdf.build(_mau());
    expect(bytes.length, greaterThan(1000));
    // Header %PDF ở đầu file.
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    // Ghi ra file để mở xem trực tiếp khi cần kiểm thị giác.
    final out = File('build/sample_ho_so_van_trinh.pdf');
    out.parent.createSync(recursive: true);
    out.writeAsBytesSync(bytes);
  });

  test('PDF dựng được cả khi không rõ giờ sinh', () async {
    final la = lapLaSoTuDuong(DateTime(1990, 1, 1), 0, Gender.nu);
    final bc = baoCaoTongQuan(la,
        birthDate: DateTime(1990, 1, 1),
        genderLabel: 'Nữ',
        hourChi: null,
        gioGhiChu: ' (không rõ — luận tổng quát)');
    final bytes = await BaoCaoPdf.build(bc);
    expect(bytes.length, greaterThan(1000));
  });
}
