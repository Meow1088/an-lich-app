import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/core/xuat_hanh.dart';

void main() {
  test('Hỷ Thần theo can ngày', () {
    expect(hyThanOfCan(0), 'Đông Bắc'); // Giáp
    expect(hyThanOfCan(5), 'Đông Bắc'); // Kỷ
    expect(hyThanOfCan(3), 'Chính Nam'); // Đinh
    expect(hyThanOfCan(4), 'Đông Nam'); // Mậu
  });
  test('Tài Thần theo can ngày', () {
    expect(taiThanOfCan(0), 'Đông Nam'); // Giáp
    expect(taiThanOfCan(4), 'Bắc'); // Mậu
    expect(taiThanOfCan(9), 'Tây Bắc'); // Quý
  });
  test('Lục diệu: tháng 1 ngày 1 giờ Tý = Đại An', () {
    expect(lucDieuIndex(1, 1, 0), 0);
    expect(lucDieuNames[lucDieuIndex(1, 1, 0)], 'Đại An');
  });
  test('Lục diệu tiến thuận theo giờ', () {
    expect(lucDieuNames[lucDieuIndex(1, 1, 1)], 'Lưu Niên');
    expect(lucDieuNames[lucDieuIndex(1, 1, 2)], 'Tốc Hỷ');
  });
}
