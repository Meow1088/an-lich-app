/// Sự kiện theo DƯƠNG LỊCH (ngày-tháng dương cố định, lặp hằng năm).
/// Tái dùng [LunarEvent] làm nhãn chung (name + emoji) và [UpcomingEvent].
library;

import 'lunar_events.dart';

// Khoá = tháng*100 + ngày (dương lịch).
const Map<int, LunarEvent> _solarEvents = {
  101: LunarEvent('Tết Dương lịch', '🎉'),
  214: LunarEvent('Lễ Tình nhân (Valentine)', '💝'),
  227: LunarEvent('Ngày Thầy thuốc Việt Nam', '🩺'),
  308: LunarEvent('Quốc tế Phụ nữ', '🌷'),
  430: LunarEvent('Giải phóng miền Nam', '🇻🇳'),
  501: LunarEvent('Quốc tế Lao động', '🛠️'),
  519: LunarEvent('Sinh nhật Chủ tịch Hồ Chí Minh', '⭐'),
  601: LunarEvent('Quốc tế Thiếu nhi', '🎈'),
  628: LunarEvent('Ngày Gia đình Việt Nam', '🏡'),
  727: LunarEvent('Ngày Thương binh – Liệt sĩ', '🕯️'),
  902: LunarEvent('Quốc khánh', '🇻🇳'),
  1020: LunarEvent('Ngày Phụ nữ Việt Nam', '🌸'),
  1120: LunarEvent('Ngày Nhà giáo Việt Nam', '🎓'),
  1222: LunarEvent('Ngày thành lập Quân đội Nhân dân VN', '🎖️'),
  1225: LunarEvent('Lễ Giáng sinh', '🎄'),
};

int _key(int month, int day) => month * 100 + day;

/// Sự kiện dương lịch của một ngày (nếu có).
List<LunarEvent> solarEventsForDate(int month, int day) {
  final e = _solarEvents[_key(month, day)];
  return e == null ? const [] : [e];
}

/// Danh sách sự kiện dương lịch sắp tới (tính từ [from]), sắp theo gần nhất.
List<UpcomingEvent> upcomingSolarEvents(DateTime from, {int limit = 8}) {
  final today = DateTime(from.year, from.month, from.day);
  final list = <UpcomingEvent>[];
  _solarEvents.forEach((key, ev) {
    final m = key ~/ 100;
    final d = key % 100;
    var s = DateTime(today.year, m, d);
    if (s.isBefore(today)) s = DateTime(today.year + 1, m, d);
    list.add(UpcomingEvent(ev, s, s.difference(today).inDays));
  });
  list.sort((a, b) => a.daysAway.compareTo(b.daysAway));
  return list.take(limit).toList();
}

/// Gộp sự kiện lớn ÂM LỊCH + DƯƠNG LỊCH sắp tới, sắp theo gần nhất.
List<UpcomingEvent> upcomingAllEvents(DateTime from, {int limit = 5}) {
  final merged = <UpcomingEvent>[
    ...upcomingEvents(from, limit: limit + 8),
    ...upcomingSolarEvents(from, limit: limit + 8),
  ]..sort((a, b) => a.daysAway.compareTo(b.daysAway));
  return merged.take(limit).toList();
}
