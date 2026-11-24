/// Ngày hoàng đạo / hắc đạo và Giờ hoàng đạo.
/// Quy tắc cổ truyền (Lý Thuần Phong) — bảng tra theo tháng âm & địa chi của ngày.
library;

import 'can_chi.dart';
import 'lunar_calendar.dart';

/// 12 sao trực ngày theo thứ tự, bắt đầu từ Thanh Long.
const List<String> _sapName = [
  'Thanh Long', 'Minh Đường', 'Thiên Hình', 'Chu Tước', 'Kim Quỹ', 'Kim Đường',
  'Bạch Hổ', 'Ngọc Đường', 'Thiên Lao', 'Huyền Vũ', 'Tư Mệnh', 'Câu Trận',
];

/// Vị trí các sao Hoàng Đạo trong vòng 12 sao trên.
const Set<int> _hoangDaoStars = {0, 1, 4, 5, 7, 10};

/// Kết quả đánh giá một ngày.
class DayQuality {
  final bool isHoangDao;
  final String star; // tên sao trực ngày

  const DayQuality(this.isHoangDao, this.star);

  String get label => isHoangDao ? 'Hoàng đạo' : 'Hắc đạo';
}

/// Đánh giá ngày dương lịch là hoàng đạo hay hắc đạo.
/// Cần tháng ÂM của ngày đó (suy từ solarToLunar).
DayQuality dayQuality(int dd, int mm, int yy) {
  final lunar = solarToLunar(dd, mm, yy);
  final dayChi = chiIndexOfDay(dd, mm, yy);
  // Sao khởi đầu (Thanh Long) theo tháng âm: tháng 1->Tý, 2->Dần, ...
  final startChi = ((lunar.month - 1) % 6) * 2;
  final starIdx = (dayChi - startChi + 12) % 12;
  return DayQuality(_hoangDaoStars.contains(starIdx), _sapName[starIdx]);
}

/// Tên & khung giờ của 12 canh giờ (Tý..Hợi).
const List<String> gioChiNames = [
  'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ',
  'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi',
];
const List<String> gioRanges = [
  '23–1', '1–3', '3–5', '5–7', '7–9', '9–11',
  '11–13', '13–15', '15–17', '17–19', '19–21', '21–23',
];

/// Bảng giờ hoàng đạo theo (chi của ngày % 6). '1' = giờ hoàng đạo.
/// Nguồn: amlich (Hồ Ngọc Đức).
const List<String> _luckyHourTable = [
  '110100101100',
  '001101001011',
  '110011010010',
  '101100110100',
  '001011001101',
  '010010110011',
];

/// Một giờ hoàng đạo.
class LuckyHour {
  final String chi; // ví dụ "Tý"
  final String range; // ví dụ "23–1"
  const LuckyHour(this.chi, this.range);
}

/// Danh sách giờ hoàng đạo của một ngày dương lịch.
List<LuckyHour> luckyHours(int dd, int mm, int yy) {
  final dayChi = chiIndexOfDay(dd, mm, yy);
  final row = _luckyHourTable[dayChi % 6];
  final result = <LuckyHour>[];
  for (var i = 0; i < 12; i++) {
    if (row[i] == '1') {
      result.add(LuckyHour(gioChiNames[i], gioRanges[i]));
    }
  }
  return result;
}
