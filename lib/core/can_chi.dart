/// Can Chi (Thiên Can / Địa Chi) và Tiết khí.
/// Công thức theo amlich (Hồ Ngọc Đức).
library;

import 'lunar_calendar.dart';
import 'nap_am.dart';

const List<String> thienCan = [
  'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu',
  'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý',
];

const List<String> diaChi = [
  'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ',
  'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi',
];

/// 24 tiết khí, bắt đầu từ Xuân phân (kinh độ mặt trời 0°), mỗi bước 15°.
const List<String> tietKhiNames = [
  'Xuân phân', 'Thanh minh', 'Cốc vũ', 'Lập hạ', 'Tiểu mãn', 'Mang chủng',
  'Hạ chí', 'Tiểu thử', 'Đại thử', 'Lập thu', 'Xử thử', 'Bạch lộ',
  'Thu phân', 'Hàn lộ', 'Sương giáng', 'Lập đông', 'Tiểu tuyết', 'Đại tuyết',
  'Đông chí', 'Tiểu hàn', 'Đại hàn', 'Lập xuân', 'Vũ thủy', 'Kinh trập',
];

/// Can chi của NGÀY, từ Julian Day Number.
String canChiOfJd(int jd) => '${thienCan[(jd + 9) % 10]} ${diaChi[(jd + 1) % 12]}';

/// Can chi của NGÀY dương lịch.
String canChiOfDay(int dd, int mm, int yy) =>
    canChiOfJd(julianDayNumber(dd, mm, yy));

/// Chi của NGÀY (0..11) — cần cho giờ hoàng đạo & ngày hoàng đạo.
int chiIndexOfDay(int dd, int mm, int yy) =>
    (julianDayNumber(dd, mm, yy) + 1) % 12;

/// Can chi của NĂM âm lịch.
String canChiOfYear(int lunarYear) =>
    '${thienCan[(lunarYear + 6) % 10]} ${diaChi[(lunarYear + 8) % 12]}';

// ---- Chỉ số can/chi (cho nạp âm) ----
int canIndexOfDay(int dd, int mm, int yy) =>
    (julianDayNumber(dd, mm, yy) + 9) % 10;

/// Nạp âm ngũ hành của NGÀY.
NapAm napAmOfDay(int dd, int mm, int yy) =>
    napAmOf(canIndexOfDay(dd, mm, yy), chiIndexOfDay(dd, mm, yy));

/// Nạp âm của THÁNG âm lịch.
NapAm napAmOfMonth(int lunarMonth, int lunarYear) => napAmOf(
    (lunarYear * 12 + lunarMonth + 3) % 10, (lunarMonth + 1) % 12);

/// Nạp âm của NĂM âm lịch.
NapAm napAmOfYear(int lunarYear) =>
    napAmOf((lunarYear + 6) % 10, (lunarYear + 8) % 12);

/// Can chi của THÁNG âm lịch (cần năm âm để suy ra Thiên Can của tháng).
/// Địa chi tháng cố định: tháng giêng = Dần, ... tháng 11 = Tý, tháng 12 = Sửu.
String canChiOfMonth(int lunarMonth, int lunarYear) {
  final canIdx = (lunarYear * 12 + lunarMonth + 3) % 10;
  final chiIdx = (lunarMonth + 1) % 12;
  return '${thienCan[canIdx]} ${diaChi[chiIdx]}';
}

/// Thiên Can của GIỜ Tý đầu ngày, suy từ Can của ngày.
/// Giáp/Kỷ -> Giáp Tý; Ất/Canh -> Bính Tý; Bính/Tân -> Mậu Tý;
/// Đinh/Nhâm -> Canh Tý; Mậu/Quý -> Nhâm Tý.
int canOfFirstHour(int jd) {
  final canDay = (jd + 9) % 10;
  return (canDay % 5) * 2;
}

/// Tiết khí của một ngày dương lịch (theo kinh độ mặt trời, bước 15°).
String tietKhiOfDay(int dd, int mm, int yy, {double timeZone = vnTimeZone}) {
  final jd = julianDayNumber(dd, mm, yy);
  final idx = (sunLongitudeRad(jd - 0.5 - timeZone / 24) / 3.141592653589793 * 12)
      .floor();
  return tietKhiNames[idx % 24];
}
