/// Xuất hành: hướng Hỷ Thần / Tài Thần (theo Can ngày) + giờ tốt Lý Thuần Phong (Lục diệu).
/// THAM KHẢO / tín ngưỡng dân gian. Verify nguồn 2026-06-26.
library;

import 'can_chi.dart';
import 'hoang_dao.dart' show gioChiNames, gioRanges;
import 'lunar_calendar.dart';

// Can index: Giáp0 Ất1 Bính2 Đinh3 Mậu4 Kỷ5 Canh6 Tân7 Nhâm8 Quý9.
const List<String> _hyThan = [
  'Đông Bắc', 'Tây Bắc', 'Tây Nam', 'Chính Nam', 'Đông Nam',
  'Đông Bắc', 'Tây Bắc', 'Tây Nam', 'Chính Nam', 'Đông Nam',
];
String hyThanOfCan(int canIdx) => _hyThan[canIdx];

const List<String> _taiThan = [
  'Đông Nam', 'Đông Nam', 'Đông', 'Đông', 'Bắc',
  'Nam', 'Tây Nam', 'Tây Nam', 'Tây', 'Tây Bắc',
];
String taiThanOfCan(int canIdx) => _taiThan[canIdx];

/// Hướng xuất hành của một ngày dương lịch.
class XuatHanh {
  final String hyThan; // hướng đón hỷ thần (may mắn)
  final String taiThan; // hướng đón tài thần (tài lộc)
  const XuatHanh(this.hyThan, this.taiThan);
}

XuatHanh xuatHanhOfDay(int dd, int mm, int yy) {
  final can = canIndexOfDay(dd, mm, yy);
  return XuatHanh(hyThanOfCan(can), taiThanOfCan(can));
}

// ---- Giờ Lý Thuần Phong (Lục diệu) ----

/// 6 trạng thái Lục diệu theo vòng (Đại An khởi tháng Giêng).
const List<String> lucDieuNames = [
  'Đại An', 'Lưu Niên', 'Tốc Hỷ', 'Xích Khẩu', 'Tiểu Cát', 'Không Vong',
];
// Tốt: Đại An(0), Tốc Hỷ(2), Tiểu Cát(4).
const Set<int> _lucDieuGood = {0, 2, 4};

bool lucDieuGood(int idx) => _lucDieuGood.contains(idx);

/// Chỉ số Lục diệu của 1 canh giờ (gioIdx 0=Tý..11=Hợi) theo ngày ÂL.
/// (thangAL-1 + ngayAL-1 + gio) % 6.
int lucDieuIndex(int lunarMonth, int lunarDay, int gioIdx) =>
    ((lunarMonth - 1) + (lunarDay - 1) + gioIdx) % 6;

class LucDieuHour {
  final String chi; // 'Tý'
  final String range; // '23-1'
  final String state; // 'Đại An'
  final bool good;
  const LucDieuHour(this.chi, this.range, this.state, this.good);
}

/// 12 canh giờ kèm trạng thái Lục diệu của một ngày dương lịch.
List<LucDieuHour> lucDieuHours(int dd, int mm, int yy) {
  final lunar = solarToLunar(dd, mm, yy);
  final result = <LucDieuHour>[];
  for (var g = 0; g < 12; g++) {
    final idx = lucDieuIndex(lunar.month, lunar.day, g);
    result.add(LucDieuHour(
        gioChiNames[g], gioRanges[g], lucDieuNames[idx], _lucDieuGood.contains(idx)));
  }
  return result;
}
