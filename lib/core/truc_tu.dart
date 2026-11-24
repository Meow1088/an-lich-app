/// Trạch nhật: 12 Trực (Kiến Trừ) và Nhị thập bát tú (28 sao).
/// Đã đối chiếu mốc: 1/1/2000 = Trực Phá; 1/1/1995 = sao Hư; 8/3/1997 = sao Liễu.
/// Phần "nên/kiêng" và tốt/xấu là theo cổ truyền (THAM KHẢO), nhiều nguồn có thể khác.
library;

import 'dart:math';
import 'lunar_calendar.dart';

// ===================== 12 TRỰC =====================

class Truc {
  final String name;
  final String nature; // 'Tốt' / 'Xấu' / 'Bình'
  final String nen; // nên làm
  final String kieng; // nên tránh
  const Truc(this.name, this.nature, this.nen, this.kieng);

  bool get isGood => nature == 'Tốt';
  bool get isBad => nature == 'Xấu';
}

// Thứ tự 12 trực: Kiến, Trừ, Mãn, Bình, Định, Chấp, Phá, Nguy, Thành, Thu, Khai, Bế.
const List<Truc> _trucs = [
  Truc('Kiến', 'Tốt', 'Xuất hành, nhậm chức, cầu tài, khai trương',
      'Động thổ, an táng, đào giếng'),
  Truc('Trừ', 'Tốt', 'Chữa bệnh, cúng lễ, dọn dẹp, trừ tà',
      'Cưới hỏi, xuất hành xa'),
  Truc('Mãn', 'Bình', 'Mở kho, khai trương, giao dịch, cầu tài',
      'An táng, kiện tụng, uống thuốc'),
  Truc('Bình', 'Xấu', 'Việc nhỏ thường ngày',
      'Cưới hỏi, khởi công, an táng'),
  Truc('Định', 'Tốt', 'Cưới hỏi, ký kết, nhập học, khai trương',
      'Kiện tụng, xuất hành'),
  Truc('Chấp', 'Bình', 'Xây dựng, tạo tác, bắt giữ',
      'Xuất hành, dời nhà, giao dịch'),
  Truc('Phá', 'Xấu', 'Phá dỡ, chữa bệnh nặng',
      'Cưới hỏi, khai trương, mọi việc lớn'),
  Truc('Nguy', 'Xấu', 'Cúng lễ, cầu an',
      'Leo cao, đi sông nước, khởi sự, xuất hành'),
  Truc('Thành', 'Tốt', 'Cưới hỏi, khai trương, nhập học, mọi việc',
      'Kiện tụng, tranh chấp'),
  Truc('Thu', 'Bình', 'Thu hoạch, nhập kho, cầu tài, mở cửa hàng',
      'An táng, xuất hành, khai trương'),
  Truc('Khai', 'Tốt', 'Khai trương, cưới hỏi, nhập học, xuất hành',
      'An táng, động thổ'),
  Truc('Bế', 'Xấu', 'Đắp đê, lấp hố, an táng',
      'Khai trương, xuất hành, chữa bệnh, khởi sự'),
];

/// Trực của một ngày dương lịch.
/// Kiến-tháng theo 節 (kinh độ mặt trời mỗi 30° kể từ 315° Lập Xuân = kiến Dần).
Truc trucOfDay(int dd, int mm, int yy, {double timeZone = vnTimeZone}) {
  final jd = julianDayNumber(dd, mm, yy);
  final sunDeg = sunLongitudeRad(jd - 0.5 - timeZone / 24) * 180 / pi;
  final kienMonth = ((sunDeg - 315) % 360) ~/ 30; // 0..11
  final kienBranch = (2 + kienMonth) % 12; // Dần=2
  final dayChi = (jd + 1) % 12;
  final trucIdx = (dayChi - kienBranch + 12) % 12;
  return _trucs[trucIdx];
}

// ===================== NHỊ THẬP BÁT TÚ =====================

class Tu {
  final String name;
  final String tinh; // thất diệu: Nhật/Nguyệt/Hỏa/Thủy/Mộc/Kim/Thổ
  final bool good; // tốt (cát) hay xấu (hung) — theo cổ truyền
  const Tu(this.name, this.tinh, this.good);
}

// 28 sao theo thứ tự vòng ngày (Đông→Bắc→Tây→Nam). Hư ở vị trí 10.
const List<Tu> _tus = [
  Tu('Giác', 'Mộc', true),
  Tu('Cang', 'Kim', false),
  Tu('Đê', 'Thổ', false),
  Tu('Phòng', 'Nhật', true),
  Tu('Tâm', 'Nguyệt', false),
  Tu('Vĩ', 'Hỏa', true),
  Tu('Cơ', 'Thủy', true),
  Tu('Đẩu', 'Mộc', true),
  Tu('Ngưu', 'Kim', false),
  Tu('Nữ', 'Thổ', false),
  Tu('Hư', 'Nhật', false),
  Tu('Nguy', 'Nguyệt', false),
  Tu('Thất', 'Hỏa', true),
  Tu('Bích', 'Thủy', true),
  Tu('Khuê', 'Mộc', true),
  Tu('Lâu', 'Kim', true),
  Tu('Vị', 'Thổ', true),
  Tu('Mão', 'Nhật', false),
  Tu('Tất', 'Nguyệt', true),
  Tu('Chủy', 'Hỏa', false),
  Tu('Sâm', 'Thủy', false),
  Tu('Tỉnh', 'Mộc', true),
  Tu('Quỷ', 'Kim', false),
  Tu('Liễu', 'Thổ', false),
  Tu('Tinh', 'Nhật', false),
  Tu('Trương', 'Nguyệt', true),
  Tu('Dực', 'Hỏa', true),
  Tu('Chẩn', 'Thủy', true),
];

// Mốc: 1/1/1995 = sao Hư (chỉ số 10).
final int _anchorJd = julianDayNumber(1, 1, 1995);
const int _anchorTu = 10;

/// Nhị thập bát tú của một ngày dương lịch.
Tu tuOfDay(int dd, int mm, int yy) {
  final jd = julianDayNumber(dd, mm, yy);
  final idx = (((jd - _anchorJd) % 28 + _anchorTu) % 28 + 28) % 28;
  return _tus[idx];
}
