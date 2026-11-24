import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/can_chi.dart';
import '../core/truc_tu.dart';
import '../core/lunar_events.dart';
import '../core/solar_events.dart';
import '../data/reminder_store.dart';
import 'theme.dart';

/// Bảng màu cho widget — suy theo theme đang chọn (sáng/tối). Giữ màu ngữ
/// nghĩa (đỏ CN/Hắc đạo, vàng lễ) gần như cố định; chỉ nền card + chữ + nhấn
/// "hôm nay" đổi để hợp theme.
class _WPalette {
  final Color card,
      border,
      ink,
      muted,
      number,
      todayBg,
      danger,
      good,
      gold,
      divider;
  const _WPalette({
    required this.card,
    required this.border,
    required this.ink,
    required this.muted,
    required this.number,
    required this.todayBg,
    required this.danger,
    required this.good,
    required this.gold,
    required this.divider,
  });

  static const light = _WPalette(
    card: Color(0x8CF4FAF5), // ~55%
    border: Color(0x73FFFFFF),
    ink: Color(0xFF1F352B),
    muted: Color(0xFF55675C),
    number: Color(0xFF1E6E4F),
    todayBg: Color(0xFF1E6E4F),
    danger: Color(0xFFC0392B),
    good: Color(0xFF2E7D5B),
    gold: Color(0xFFC9A227),
    divider: Color(0x1A1F352B),
  );

  static const dark = _WPalette(
    card: Color(0xA80E2A22), // ~66%
    border: Color(0x4DFFFFFF),
    ink: Color(0xFFEAF4EC),
    muted: Color(0xFFAFC6BC),
    number: Color(0xFF8FD3B0),
    todayBg: Color(0xFF2E7D5B),
    danger: Color(0xFFE08A82),
    good: Color(0xFF6FCF97),
    gold: Color(0xFFEAD79A),
    divider: Color(0x33FFFFFF),
  );

  static _WPalette of(AppThemeSpec spec) => spec.dark ? dark : light;
}

/// Giao diện widget màn hình chính — render offscreen ra ảnh PNG.
/// KHÔNG dùng Theme.of/Material widget (render ngoài MaterialApp).
/// Card bán trong suốt để lọt hình nền điện thoại; màu theo theme đang chọn.
class HomeWidgetView extends StatelessWidget {
  final DateTime date;
  final double width;
  final double height;
  final List<Reminder> reminders;

  const HomeWidgetView({
    super.key,
    required this.date,
    this.width = 380,
    this.height = 205,
    this.reminders = const [],
  });

  /// Gộp sự kiện DƯƠNG + ÂM của đúng ngày này (ưu tiên lễ lớn).
  static List<LunarEvent> eventsOfDay(DateTime date, LunarDate lunar) {
    final all = <LunarEvent>[
      ...solarEventsForDate(date.month, date.day),
      ...eventsForLunarDate(lunar.day, lunar.month),
    ];
    if (all.isEmpty) return const [];
    final major = all.where((e) => e.isMajor).toList();
    return major.isNotEmpty ? [major.first] : [all.first];
  }

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(date.day, date.month, date.year);
    final truc = trucOfDay(date.day, date.month, date.year);
    final events = eventsOfDay(date, lunar);
    final hasEvent = events.isNotEmpty;
    final nextReminder = _nextReminder(date, reminders);
    final p = _WPalette.of(AppTheme.current);

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: p.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 56,
            child: _MiniMonth(date: date, p: p),
          ),
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: p.divider,
          ),
          Expanded(
            flex: 44,
            child: _Panel(
              date: date,
              lunar: lunar,
              nen: truc.nen,
              events: events,
              hasEvent: hasEvent,
              nextReminder: nextReminder,
              p: p,
            ),
          ),
        ],
      ),
    );
  }

  /// Chỉ hiện nhắc nhở nếu rơi trong vòng [_maxDaysAway] ngày tới — nhắc nhở
  /// còn xa (vài tháng) không có ích trên widget nhỏ, dễ gây rối mắt.
  static const int _maxDaysAway = 14;

  static WidgetReminder? _nextReminder(
    DateTime date,
    List<Reminder> reminders,
  ) {
    final today = DateTime(date.year, date.month, date.day);
    WidgetReminder? best;
    for (final reminder in reminders) {
      final next = reminder.nextOccurrence(today);
      if (next == null) continue;
      final nextDay = DateTime(next.year, next.month, next.day);
      final days = nextDay.difference(today).inDays;
      if (days < 0 || days > _maxDaysAway) continue;
      final candidate = WidgetReminder(reminder.title, days);
      if (best == null || candidate.daysAway < best.daysAway) {
        best = candidate;
      }
    }
    return best;
  }
}

class WidgetReminder {
  final String title;
  final int daysAway;

  const WidgetReminder(this.title, this.daysAway);

  String get label => daysAway == 0 ? 'hôm nay' : 'còn $daysAway ngày';
}

class _Panel extends StatelessWidget {
  final DateTime date;
  final LunarDate lunar;
  final String nen; // việc nên làm hôm nay (theo Trực) — ghi gọn
  final List<LunarEvent> events;
  final bool hasEvent;
  final WidgetReminder? nextReminder;
  final _WPalette p;
  const _Panel({
    required this.date,
    required this.lunar,
    required this.nen,
    required this.events,
    required this.hasEvent,
    required this.nextReminder,
    required this.p,
  });

  @override
  Widget build(BuildContext context) {
    final eventName = hasEvent ? events.first.name : null;
    final isMajor = hasEvent && events.first.isMajor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 46,
                height: 1,
                fontWeight: FontWeight.w800,
                color: p.number,
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'Tháng ${date.month}\n${date.year}',
                style: TextStyle(fontSize: 12, height: 1.15, color: p.muted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Âm lịch ${lunar.day}/${lunar.month}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: p.ink,
          ),
        ),
        Text(
          '${canChiOfDay(date.day, date.month, date.year)} · ${canChiOfYear(lunar.year)}',
          style: TextStyle(fontSize: 11, color: p.muted),
        ),
        const SizedBox(height: 6),
        Text(
          'Hôm nay nên',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            color: p.good,
          ),
        ),
        Text(
          nen,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11, height: 1.15, color: p.ink),
        ),
        if (eventName != null) ...[
          const SizedBox(height: 3),
          Text(
            eventName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isMajor ? p.gold : p.muted,
            ),
          ),
        ],
        if (nextReminder != null) ...[
          const SizedBox(height: 3),
          Text(
            'Nhắc: ${nextReminder!.title} · ${nextReminder!.label}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: p.gold,
            ),
          ),
        ],
      ],
    );
  }
}

class _MiniMonth extends StatelessWidget {
  final DateTime date;
  final _WPalette p;
  const _MiniMonth({required this.date, required this.p});

  @override
  Widget build(BuildContext context) {
    final first = DateTime(date.year, date.month, 1);
    final leading = first.weekday - 1; // Mon=0
    final daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    const dow = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    final rows = <Widget>[];
    // header
    rows.add(
      Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: Text(
                  dow[i],
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: i == 6 ? p.danger : p.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    var day = 1 - leading;
    final totalCells = leading + daysInMonth;
    final weeks = (totalCells / 7).ceil();
    for (var w = 0; w < weeks; w++) {
      final cells = <Widget>[];
      for (var c = 0; c < 7; c++) {
        if (day < 1 || day > daysInMonth) {
          cells.add(const Expanded(child: SizedBox()));
        } else {
          cells.add(Expanded(child: _cell(day, c == 6)));
        }
        day++;
      }
      rows.add(Expanded(child: Row(children: cells)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        rows.first,
        const SizedBox(height: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows.sublist(1),
          ),
        ),
      ],
    );
  }

  Widget _cell(int d, bool isSunday) {
    final isToday = d == date.day;
    final lunar = solarToLunar(d, date.month, date.year);
    // Sự kiện = lễ lớn ÂM LỊCH hoặc sự kiện DƯƠNG LỊCH của ngày đó.
    final isEvent =
        hasMajorEvent(lunar.day, lunar.month) ||
        solarEventsForDate(date.month, d).isNotEmpty;
    final lunarLabel = lunar.day == 1
        ? '${lunar.day}/${lunar.month}'
        : '${lunar.day}';

    Color solarColor = p.ink;
    if (isSunday) solarColor = p.danger;
    if (isEvent) solarColor = p.gold;

    final solar = Text(
      '$d',
      style: TextStyle(
        fontSize: 11,
        height: 1,
        fontWeight: isEvent ? FontWeight.w800 : FontWeight.w600,
        color: isToday ? Colors.white : solarColor,
      ),
    );

    final solarWidget = isToday
        ? Container(
            width: 17,
            height: 17,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: p.todayBg, shape: BoxShape.circle),
            child: solar,
          )
        : SizedBox(height: 17, child: Center(child: solar));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          solarWidget,
          Text(
            lunarLabel,
            style: TextStyle(
              fontSize: 7.5,
              height: 1.1,
              fontWeight: isEvent ? FontWeight.w700 : FontWeight.w400,
              color: isEvent ? p.gold : p.muted,
            ),
          ),
        ],
      ),
    );
  }
}
