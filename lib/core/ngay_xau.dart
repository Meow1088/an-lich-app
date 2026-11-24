/// Ngày xấu cổ truyền (THAM KHẢO / tín ngưỡng dân gian).
/// Đã verify nguồn 2026-06-26: Tam Nương, Nguyệt kỵ, Dương Công kỵ nhật, Sát chủ.
/// Predicate thuần theo dữ liệu âm lịch -> test literal được, không gọi I/O.
library;

import 'can_chi.dart';
import 'lunar_calendar.dart';

/// Một loại ngày xấu phát hiện trên 1 ngày.
class BadDay {
  final String name; // 'Tam Nương'
  final String reason; // việc đại kỵ
  const BadDay(this.name, this.reason);
}

// Tam Nương: ngày 3,7,13,18,22,27 âm lịch.
const Set<int> _tamNuongDays = {3, 7, 13, 18, 22, 27};
bool isTamNuong(int lunarDay) => _tamNuongDays.contains(lunarDay);

// Nguyệt kỵ: ngày 5,14,23 âm lịch.
const Set<int> _nguyetKyDays = {5, 14, 23};
bool isNguyetKy(int lunarDay) => _nguyetKyDays.contains(lunarDay);

// Dương Công kỵ nhật: 13 ngày cố định theo (ngày, tháng) âm lịch.
const Map<int, List<int>> _duongCongByMonth = {
  1: [13], 2: [11], 3: [9], 4: [7], 5: [5], 6: [3],
  7: [8, 29], 8: [27], 9: [25], 10: [23], 11: [21], 12: [19],
};
bool isDuongCong(int lunarDay, int lunarMonth) =>
    _duongCongByMonth[lunarMonth]?.contains(lunarDay) ?? false;

// Chi index: Tý0 Sửu1 Dần2 Mão3 Thìn4 Tỵ5 Ngọ6 Mùi7 Thân8 Dậu9 Tuất10 Hợi11.
// Sát chủ Dương theo tháng âm -> chi của ngày.
const Map<int, int> _satChuDuongChi = {
  1: 0, 2: 1, 3: 1, 4: 10, 5: 4, 6: 4,
  7: 1, 8: 4, 9: 1, 10: 4, 11: 7, 12: 4,
};
bool isSatChuDuong(int dayChi, int lunarMonth) =>
    _satChuDuongChi[lunarMonth] == dayChi;

// Sát chủ Âm theo tháng âm -> chi của ngày.
const Map<int, int> _satChuAmChi = {
  1: 5, 2: 0, 3: 7, 4: 3, 5: 8, 6: 10,
  7: 11, 8: 1, 9: 6, 10: 9, 11: 2, 12: 4,
};
bool isSatChuAm(int dayChi, int lunarMonth) =>
    _satChuAmChi[lunarMonth] == dayChi;

/// Tất cả ngày xấu cổ truyền trên một ngày dương lịch.
List<BadDay> badDaysOf(int dd, int mm, int yy) {
  final lunar = solarToLunar(dd, mm, yy);
  final dayChi = chiIndexOfDay(dd, mm, yy);
  final result = <BadDay>[];
  if (isTamNuong(lunar.day)) {
    result.add(const BadDay('Tam Nương', 'Kỵ cưới hỏi, khai trương, việc lớn'));
  }
  if (isNguyetKy(lunar.day)) {
    result.add(const BadDay('Nguyệt kỵ', 'Kỵ xuất hành, khởi sự việc lớn'));
  }
  if (isDuongCong(lunar.day, lunar.month)) {
    result.add(const BadDay('Dương Công kỵ nhật', 'Đại kỵ mọi việc trọng đại'));
  }
  if (isSatChuDuong(dayChi, lunar.month)) {
    result.add(const BadDay('Sát chủ Dương', 'Kỵ buôn bán, ký kết, mua nhà'));
  }
  if (isSatChuAm(dayChi, lunar.month)) {
    result.add(const BadDay('Sát chủ Âm', 'Kỵ an táng, cải táng, tâm linh'));
  }
  return result;
}
