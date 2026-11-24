/// Sự kiện / ngày lễ theo ÂM LỊCH (cố định theo ngày-tháng âm, lặp hằng năm).
library;

import 'lunar_calendar.dart';

/// Một sự kiện âm lịch.
class LunarEvent {
  final String name;
  final String emoji;

  /// true = ngày lễ lớn (hiển thị nổi bật + chấm trên lịch);
  /// false = ngày Sóc/Vọng thường (Mùng 1 / Rằm).
  final bool isMajor;

  const LunarEvent(this.name, this.emoji, {this.isMajor = true});
}

// Khoá = ngày*100 + tháng (âm lịch).
const Map<int, LunarEvent> _majorEvents = {
  101: LunarEvent('Tết Nguyên Đán', '🎆'),
  201: LunarEvent('Mùng 2 Tết', '🎆'),
  301: LunarEvent('Mùng 3 Tết', '🎆'),
  1501: LunarEvent('Tết Nguyên Tiêu (Rằm tháng Giêng)', '🏮'),
  303: LunarEvent('Tết Hàn Thực', '🍡'),
  1003: LunarEvent('Giỗ Tổ Hùng Vương', '🇻🇳'),
  1504: LunarEvent('Lễ Phật Đản', '🪷'),
  505: LunarEvent('Tết Đoan Ngọ', '🌿'),
  1507: LunarEvent('Lễ Vu Lan (Rằm tháng Bảy)', '🪷'),
  1508: LunarEvent('Tết Trung Thu', '🥮'),
  1010: LunarEvent('Tết Thường Tân (Cơm mới)', '🌾'),
  2312: LunarEvent('Ông Công Ông Táo', '🐟'),
};

int _key(int day, int month) => day * 100 + month;

/// Danh sách sự kiện của một ngày âm lịch.
/// Ưu tiên ngày lễ lớn; nếu không có thì gắn nhãn Mùng 1 / Rằm.
List<LunarEvent> eventsForLunarDate(int lunarDay, int lunarMonth) {
  final major = _majorEvents[_key(lunarDay, lunarMonth)];
  if (major != null) return [major];
  if (lunarDay == 1) {
    return const [LunarEvent('Mùng một (đầu tháng)', '🌑', isMajor: false)];
  }
  if (lunarDay == 15) {
    return const [LunarEvent('Ngày Rằm', '🌕', isMajor: false)];
  }
  return const [];
}

/// Có ngày lễ LỚN không (để đánh dấu trên lịch tháng).
bool hasMajorEvent(int lunarDay, int lunarMonth) =>
    _majorEvents.containsKey(_key(lunarDay, lunarMonth));

/// Một ngày lễ sắp tới kèm số ngày còn lại.
class UpcomingEvent {
  final LunarEvent event;
  final DateTime solar;
  final int daysAway;
  const UpcomingEvent(this.event, this.solar, this.daysAway);
}

/// Danh sách ngày lễ LỚN sắp tới (tính từ [from]), sắp theo gần nhất.
List<UpcomingEvent> upcomingEvents(DateTime from, {int limit = 4}) {
  final today = DateTime(from.year, from.month, from.day);
  final curLunarYear = solarToLunar(from.day, from.month, from.year).year;
  final list = <UpcomingEvent>[];
  _majorEvents.forEach((key, ev) {
    final d = key ~/ 100;
    final m = key % 100;
    for (var i = 0; i <= 1; i++) {
      final s = lunarToSolar(d, m, curLunarYear + i);
      if (s != null) {
        final sd = DateTime(s.year, s.month, s.day);
        if (!sd.isBefore(today)) {
          list.add(UpcomingEvent(ev, sd, sd.difference(today).inDays));
          break;
        }
      }
    }
  });
  list.sort((a, b) => a.daysAway.compareTo(b.daysAway));
  return list.take(limit).toList();
}
