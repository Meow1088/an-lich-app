import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/lunar_calendar.dart';

/// Kiểu lặp lại của một nhắc nhở.
enum RepeatType { yearly, monthly, once }

RepeatType _repeatFrom(String? s) {
  switch (s) {
    case 'monthly':
      return RepeatType.monthly;
    case 'once':
      return RepeatType.once;
    default:
      return RepeatType.yearly;
  }
}

String _repeatName(RepeatType r) => r.name; // yearly/monthly/once

/// Một nhắc nhở (giỗ, lễ, sự kiện...).
///
/// Có thể theo NGÀY ÂM LỊCH hoặc DƯƠNG LỊCH, lặp hằng năm / hằng tháng /
/// một lần. Vì ngày âm rơi vào ngày dương khác nhau mỗi năm nên lần xảy ra
/// kế tiếp được tính lại mỗi lần.
class Reminder {
  final String id;
  final String title;
  final String note;
  final bool isLunar; // true = âm lịch, false = dương lịch
  final int day;
  final int month;
  final RepeatType repeat;
  final String? onceSolar; // 'yyyy-MM-dd' — chỉ dùng khi repeat == once
  final bool notify;
  final int remindBeforeDays; // nhắc trước N ngày (0 = đúng hôm đó)
  final bool remindDaily; // nhắc mỗi ngày từ ngày xa nhất đến ngày sự kiện

  const Reminder({
    required this.id,
    required this.title,
    this.note = '',
    this.isLunar = true,
    required this.day,
    required this.month,
    this.repeat = RepeatType.yearly,
    this.onceSolar,
    this.notify = true,
    this.remindBeforeDays = 0,
    this.remindDaily = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'isLunar': isLunar,
    'day': day,
    'month': month,
    'repeat': _repeatName(repeat),
    'onceSolar': onceSolar,
    'notify': notify,
    'remindBeforeDays': remindBeforeDays,
    'remindDaily': remindDaily,
  };

  factory Reminder.fromJson(Map<String, dynamic> j) => Reminder(
    id: j['id'] as String,
    title: j['title'] as String,
    note: (j['note'] as String?) ?? '',
    // Tương thích bản cũ: chỉ có lunarDay/lunarMonth, luôn là âm lịch.
    isLunar: (j['isLunar'] as bool?) ?? true,
    day: (j['day'] ?? j['lunarDay']) as int,
    month: (j['month'] ?? j['lunarMonth']) as int,
    repeat: _repeatFrom(j['repeat'] as String?),
    onceSolar: j['onceSolar'] as String?,
    notify: (j['notify'] as bool?) ?? true,
    remindBeforeDays: (j['remindBeforeDays'] as int?) ?? 0,
    remindDaily: (j['remindDaily'] as bool?) ?? false,
  );

  /// Lần xảy ra dương lịch kế tiếp của SỰ KIỆN (kể từ [from], gồm cả hôm nay).
  DateTime? nextOccurrence(DateTime from) {
    final today = DateTime(from.year, from.month, from.day);

    if (repeat == RepeatType.once) {
      if (onceSolar == null) return null;
      final d = DateTime.parse(onceSolar!);
      final dd = DateTime(d.year, d.month, d.day);
      return dd.isBefore(today) ? null : dd;
    }

    if (isLunar) {
      if (repeat == RepeatType.monthly) {
        // Ngày âm [day] của bất kỳ tháng âm nào — quét tới tối đa ~2 tháng.
        for (var off = 0; off <= 62; off++) {
          final c = today.add(Duration(days: off));
          if (solarToLunar(c.day, c.month, c.year).day == day) return c;
        }
        return null;
      }
      // yearly
      final curLunarYear = solarToLunar(from.day, from.month, from.year).year;
      for (var i = 0; i <= 4; i++) {
        final solar = lunarToSolar(day, month, curLunarYear + i);
        if (solar != null) {
          final s = DateTime(solar.year, solar.month, solar.day);
          if (!s.isBefore(today)) return s;
        }
      }
      return null;
    }

    // Dương lịch
    if (repeat == RepeatType.monthly) {
      for (var off = 0; off <= 62; off++) {
        final c = today.add(Duration(days: off));
        if (c.day == day) return c;
      }
      return null;
    }
    // yearly dương
    for (var y = today.year; y <= today.year + 4; y++) {
      if (_validSolar(y, month, day)) {
        final d = DateTime(y, month, day);
        if (!d.isBefore(today)) return d;
      }
    }
    return null;
  }

  /// Các ngày (mức ngày, 00:00) cần bắn thông báo, kể từ [from].
  List<DateTime> notificationDates(DateTime from) {
    if (!notify) return const [];
    final event = nextOccurrence(from);
    if (event == null) return const [];
    final today = DateTime(from.year, from.month, from.day);
    final before = remindBeforeDays;
    final out = <DateTime>[];
    if (remindDaily && before > 0) {
      for (var k = before; k >= 0; k--) {
        final d = event.subtract(Duration(days: k));
        if (!d.isBefore(today)) out.add(d);
      }
    } else {
      var d = event.subtract(Duration(days: before));
      if (d.isBefore(today)) d = event; // ngày nhắc đã qua -> nhắc đúng hôm đó
      if (!d.isBefore(today)) out.add(d);
    }
    return out;
  }

  static bool _validSolar(int y, int m, int d) {
    final dim = DateTime(y, m + 1, 0).day;
    return d >= 1 && d <= dim;
  }
}

class ReminderStore {
  static const _kKey = 'reminders';

  Future<List<Reminder>> list() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_kKey) ?? [];
    return raw
        .map((s) => Reminder.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save(List<Reminder> items) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList(
      _kKey,
      items.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }

  Future<void> add(Reminder r) async {
    final items = await list();
    items.add(r);
    await _save(items);
  }

  Future<void> upsert(Reminder r) async {
    final items = await list();
    final index = items.indexWhere((x) => x.id == r.id);
    if (index >= 0) {
      items[index] = r;
    } else {
      items.add(r);
    }
    await _save(items);
  }

  Future<void> delete(String id) async {
    final items = await list();
    items.removeWhere((r) => r.id == id);
    await _save(items);
  }
}
