import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/lunar_calendar.dart';
import '../core/can_chi.dart';
import '../core/hoang_dao.dart';
import '../core/lunar_events.dart';
import '../core/ngay_xau.dart';
import '../core/truc_tu.dart';
import 'theme.dart';

const _weekdays = [
  '', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
];

// Tên tháng âm lịch theo dân gian (1=Giêng ... 12=Chạp).
const _lunarMonthNames = [
  '', 'Giêng', 'Hai', 'Ba', 'Tư', 'Năm', 'Sáu', 'Bảy', 'Tám', 'Chín', 'Mười',
  'Một', 'Chạp'
];

class MonthScreen extends StatefulWidget {
  const MonthScreen({super.key});

  @override
  State<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  // Trang giữa = tháng hiện tại; vuốt được ~100 năm mỗi chiều.
  static const _basePage = 1200;
  final PageController _pager = PageController(initialPage: _basePage);
  late DateTime _month; // ngày 1 của tháng đang xem
  late DateTime _selected; // ngày đang được chọn (hiện chi tiết bên dưới)

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month, 1);
    _selected = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  DateTime _monthAt(int page) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + (page - _basePage), 1);
  }

  void _onPageChanged(int page) {
    final m = _monthAt(page);
    final today = DateTime.now();
    setState(() {
      _month = m;
      // Về tháng hiện tại thì chọn hôm nay; tháng khác chọn mùng 1.
      _selected = (m.year == today.year && m.month == today.month)
          ? DateTime(today.year, today.month, today.day)
          : m;
    });
  }

  void _shift(int delta) {
    final page = (_pager.page ?? _basePage.toDouble()).round() + delta;
    _pager.animateToPage(page,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic);
  }

  void _select(DateTime date) {
    HapticFeedback.selectionClick();
    setState(() => _selected = date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lunarStart = solarToLunar(1, _month.month, _month.year);
    const dow = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      children: [
        // --- Thanh chuyển tháng ---
        Row(
          children: [
            IconButton(
                onPressed: () => _shift(-1),
                color: AppColors.jadeDark,
                icon: const Icon(Icons.chevron_left)),
            Expanded(
              child: Column(
                children: [
                  Text('Tháng ${_month.month}/${_month.year}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.jadeDark)),
                  Text(
                      'Âm lịch tháng ${lunarStart.month} năm ${lunarStart.year}',
                      style: const TextStyle(color: AppColors.inkSoft)),
                ],
              ),
            ),
            IconButton(
                onPressed: () => _shift(1),
                color: AppColors.jadeDark,
                icon: const Icon(Icons.chevron_right)),
          ],
        ),
        const SizedBox(height: 4),
        // --- Lưới lịch (vuốt ngang để chuyển tháng) ---
        GlassCard(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 6),
          child: Column(
            children: [
              Row(
                children: [
                  for (final d in dow)
                    Expanded(
                      child: Center(
                        child: Text(d,
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: d == 'CN'
                                    ? cs.error
                                    : AppColors.inkSoft)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              LayoutBuilder(
                builder: (context, cons) {
                  final cellW = cons.maxWidth / 7;
                  // 6 hàng cố định để chiều cao không nhảy khi vuốt tháng.
                  final gridH = cellW * 1.14 * 6;
                  return SizedBox(
                    height: gridH,
                    child: PageView.builder(
                      controller: _pager,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, page) =>
                          _monthGrid(context, _monthAt(page)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // --- Thông tin ngày được chọn (hiện ngay bên dưới) ---
        _DayInfoCard(date: _selected),
      ],
    );
  }

  Widget _monthGrid(BuildContext context, DateTime month) {
    final today = DateTime.now();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // weekday của ngày 1 (Mon=1..Sun=7) → số ô trống trước ngày 1
    final leading = DateTime(month.year, month.month, 1).weekday - 1;

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, childAspectRatio: 1 / 1.14),
      itemCount: 42,
      itemBuilder: (context, i) {
        final day = i - leading + 1;
        if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
        final date = DateTime(month.year, month.month, day);
        return _DayCell(
          date: date,
          isToday: date.year == today.year &&
              date.month == today.month &&
              date.day == today.day,
          isSelected: date.year == _selected.year &&
              date.month == _selected.month &&
              date.day == _selected.day,
          onTap: () => _select(date),
        );
      },
    );
  }
}

/// Một ô ngày: số dương trong vòng tròn trạng thái (chọn = jade đặc,
/// hôm nay = viền jade), số âm nhỏ bên dưới, chấm vàng = ngày lễ.
class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final lunar = solarToLunar(date.day, date.month, date.year);
    final isSunday = date.weekday == 7;
    final isEvent = hasMajorEvent(lunar.day, lunar.month);
    final isLunarFirst = lunar.day == 1; // đầu tháng âm: hiện "1/X"
    final lunarLabel =
        isLunarFirst ? '${lunar.day}/${lunar.month}' : '${lunar.day}';

    final numColor = isSelected
        ? Colors.white
        : (isSunday
            ? cs.error
            : (isToday ? AppColors.jade : cs.onSurface));

    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.jade : null,
                    border: (!isSelected && isToday)
                        ? Border.all(color: AppColors.jade, width: 1.5)
                        : null,
                  ),
                  child: Text('${date.day}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: (isToday || isSelected)
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: numColor)),
                ),
                const SizedBox(height: 1),
                Text(lunarLabel,
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight:
                            isLunarFirst ? FontWeight.w700 : FontWeight.w400,
                        color: isLunarFirst
                            ? AppColors.jade
                            : cs.onSurfaceVariant.withValues(alpha: 0.75))),
              ],
            ),
          ),
          if (isEvent)
            Positioned(
              top: 3,
              right: 8,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Thẻ thông tin gọn của 1 ngày, hiển thị inline dưới lịch tháng.
class _DayInfoCard extends StatelessWidget {
  final DateTime date;
  const _DayInfoCard({required this.date});

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(date.day, date.month, date.year);
    final quality = dayQuality(date.day, date.month, date.year);
    final hours = luckyHours(date.day, date.month, date.year);
    final tiet = tietKhiOfDay(date.day, date.month, date.year);
    final truc = trucOfDay(date.day, date.month, date.year);
    final events = eventsForLunarDate(lunar.day, lunar.month);
    final badDays = badDaysOf(date.day, date.month, date.year);
    final hoursText =
        hours.map((h) => '${h.chi} (${h.range})').join(', ');

    return Column(
      children: [
        GlassCard(
          fill: AppColors.glassStrong,
          radius: 20,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ngày ${lunar.day} tháng ${_lunarMonthNames[lunar.month]}'
                '${lunar.isLeapMonth ? ' (nhuận)' : ''}, năm ${canChiOfYear(lunar.year)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.jadeDark),
              ),
              const SizedBox(height: 12),
              _info('Ngày',
                  '${canChiOfDay(date.day, date.month, date.year)} (${napAmOfDay(date.day, date.month, date.year).name})'),
              _info('Tháng',
                  '${canChiOfMonth(lunar.month, lunar.year)} (${napAmOfMonth(lunar.month, lunar.year).name})'),
              _info('Tiết khí', tiet),
              _info('Thần sát', '${quality.label} (${quality.star})'),
              _info('Giờ HĐ', hoursText),
              if (badDays.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 76,
                        child: Text('Ngày xấu',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.bad)),
                      ),
                      Expanded(
                        child: Text(
                            badDays.map((b) => b.name).join(', '),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.bad)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.wb_sunny, size: 16, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Text(
                    '${_weekdays[date.weekday]}, ${date.day}/${date.month}/${date.year}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft),
                  ),
                ],
              ),
              if (events.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(events.first.emoji,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(events.first.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.jadeDark)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        // --- Gợi ý hoạt động (Nên làm / Nên tránh) ---
        GlassCard(
          radius: 18,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Gợi ý hoạt động',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.jadeDark)),
                  const SizedBox(width: 8),
                  Text('· Trực ${truc.name} (${truc.nature})',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.inkSoft)),
                ],
              ),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _suggestColumn(
                          Icons.check_circle, AppColors.good, 'Nên làm',
                          truc.nen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _suggestColumn(
                          Icons.warning_amber_rounded, AppColors.bad,
                          'Nên tránh', truc.kieng),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _info(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 76,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.inkSoft)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink)),
            ),
          ],
        ),
      );

  static Widget _suggestColumn(
      IconData icon, Color color, String title, String csv) {
    final items = csv
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        for (final it in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text('• $it',
                style: const TextStyle(fontSize: 13, color: AppColors.ink)),
          ),
      ],
    );
  }
}
