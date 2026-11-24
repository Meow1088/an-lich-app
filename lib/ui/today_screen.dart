import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/can_chi.dart';
import '../core/hoang_dao.dart';
import '../core/lunar_events.dart';
import '../core/solar_events.dart';
import '../core/glossary.dart';
import '../core/historical_figures.dart';
import '../core/ngay_xau.dart';
import '../core/truc_tu.dart';
import '../services/share_service.dart';
import 'help_icon.dart';
import 'theme.dart';
import 'tu_vi_ngay_card.dart';
import 'widgets/info_row.dart';
import 'patterns/app_scaffold.dart';

const _weekdays = [
  '', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
];

const _lunarMonthNames = [
  '', 'Giêng', 'Hai', 'Ba', 'Tư', 'Năm', 'Sáu',
  'Bảy', 'Tám', 'Chín', 'Mười', 'Một', 'Chạp'
];

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DayDetail(date: DateTime.now(), showUpcoming: true);
  }
}

/// Chi tiet mot ngay khi cham 1 o lich.
class DayDetailPage extends StatelessWidget {
  final DateTime date;
  const DayDetailPage({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Chi tiết ngày',
      body: _DayDetail(date: date),
    );
  }
}

Widget _sectionTitle(String text) => Builder(
      builder: (_) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 2),
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.current.onBg,
                shadows: onBgShadows(AppTheme.current))),
      ),
    );

class _DayDetail extends StatelessWidget {
  final DateTime date;
  final bool showUpcoming;
  const _DayDetail({required this.date, this.showUpcoming = false});

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(date.day, date.month, date.year);
    final quality = dayQuality(date.day, date.month, date.year);
    final hours = luckyHours(date.day, date.month, date.year);
    final tiet = tietKhiOfDay(date.day, date.month, date.year);
    final events = eventsForLunarDate(lunar.day, lunar.month);
    final truc = trucOfDay(date.day, date.month, date.year);
    final tu = tuOfDay(date.day, date.month, date.year);
    final badDays = badDaysOf(date.day, date.month, date.year);
    final upcoming = showUpcoming
        ? upcomingAllEvents(date, limit: 5)
        : const <UpcomingEvent>[];
    final figures = figuresOnDate(date.month, date.day);
    final hd = quality.isHoangDao;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ===== HERO: ngày + số âm lớn + can chi + hoàng đạo + chia sẻ =====
        GlassCard(
          fill: AppColors.glassStrong,
          radius: 24,
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_weekdays[date.weekday]}, ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Nút chia sẻ gọn = biểu tượng
                  IconButton(
                    onPressed: () => ShareService.shareDay(context, date),
                    icon: const Icon(Icons.ios_share, size: 22),
                    color: AppColors.jade,
                    tooltip: 'Chia sẻ ảnh',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${lunar.day}',
                      style: const TextStyle(
                          color: AppColors.jadeDark,
                          fontSize: 72,
                          height: 1,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tháng ${_lunarMonthNames[lunar.month]}'
                            '${lunar.isLeapMonth ? ' (nhuận)' : ''} âm lịch',
                            style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          Text('Năm ${canChiOfYear(lunar.year)}',
                              style: const TextStyle(
                                  color: AppColors.inkSoft, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (showUpcoming) ...[
          const TuViNgayCard(),
          const SizedBox(height: 14),
        ],
        if (events.isNotEmpty) ...[
          _EventCard(event: events.first),
          const SizedBox(height: 14),
        ],
        // ===== Bảng can chi / trực / sao =====
        GlassCard(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Column(
            children: [
              InfoRow('Ngày',
                  '${canChiOfDay(date.day, date.month, date.year)} · ${napAmOfDay(date.day, date.month, date.year).name}'),
              InfoRow('Tháng',
                  '${canChiOfMonth(lunar.month, lunar.year)} · ${napAmOfMonth(lunar.month, lunar.year).name}'),
              InfoRow('Năm',
                  '${canChiOfYear(lunar.year)} · ${napAmOfYear(lunar.year).name}'),
              InfoRow('Tiết khí', tiet),
              InfoRow('Trực', '${truc.name} (${truc.nature})'),
              InfoRow('Sao', '${tu.name} (${tu.tinh}) · ${tu.good ? "Tốt" : "Xấu"}'),
              const Divider(height: 14, color: AppColors.glassBorder),
              Row(
                children: [
                  const Text('Hoàng đạo',
                      style: TextStyle(color: AppColors.inkSoft)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Ngày ${quality.label} · ${quality.star}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: hd ? AppColors.good : AppColors.bad)),
                  ),
                  HelpIcon(
                      title: 'Hoàng đạo / Hắc đạo là gì?',
                      content: explain('hoang_dao')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (badDays.isNotEmpty) ...[
          GlassCard(
            radius: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.bad, size: 22),
                    SizedBox(width: 8),
                    Text('Ngày xấu cổ truyền',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bad)),
                  ],
                ),
                for (final b in badDays)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('• ${b.name}: ${b.reason}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.ink)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        _NenTranhCard(truc: truc),
        const SizedBox(height: 14),
        // Giờ hoàng đạo — nền trắng/kính, chữ đen, gom 1 hàng (giống mẫu).
        GlassCard(
          fill: AppColors.glassStrong,
          radius: 18,
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 14),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Giờ hoàng đạo',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink)),
                  HelpIcon(
                      title: 'Giờ hoàng đạo là gì?',
                      content: explain('gio_hoang_dao')),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final h in hours)
                    Expanded(
                      child: Column(
                        children: [
                          Text(h.chi,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink)),
                          const SizedBox(height: 2),
                          Text('${h.range}h',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.inkSoft)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (upcoming.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle('Sự kiện sắp tới'),
          const SizedBox(height: 10),
          for (final u in upcoming) _UpcomingTile(item: u),
        ],
        if (figures.isNotEmpty) ...[
          const SizedBox(height: 20),
          _sectionTitle('Ngày này trong lịch sử'),
          const SizedBox(height: 10),
          GlassCard(
            radius: 16,
            child: Column(
              children: [
                for (var i = 0; i < figures.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 18, color: AppColors.glassBorder),
                  _FigureRow(figure: figures[i]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final LunarEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final major = event.isMajor;
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Text(event.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(major ? 'Sự kiện hôm nay' : 'Ngày Sóc/Vọng',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: major
                            ? const Color(0xFF7A5E12)
                            : AppColors.inkSoft)),
                Text(event.name,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.jadeDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  final UpcomingEvent item;
  const _UpcomingTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final e = item.event;
    final s = item.solar;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        radius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Text(e.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink)),
                  Text(
                      '${_weekdays[s.weekday]}, ${s.day}/${s.month}/${s.year}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.inkSoft)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(minWidth: 56),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.glassStrong,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: item.daysAway == 0
                  ? const Text('Hôm nay',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.jadeDark))
                  : Column(
                      children: [
                        Text('${item.daysAway}',
                            style: const TextStyle(
                                fontSize: 18,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: AppColors.jadeDark)),
                        const Text('ngày',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.inkSoft)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NenTranhCard extends StatelessWidget {
  final Truc truc;
  const _NenTranhCard({required this.truc});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Trực ${truc.name}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (truc.isGood
                          ? AppColors.good
                          : (truc.isBad ? AppColors.bad : AppColors.inkSoft))
                      .withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(truc.nature,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: truc.isGood
                            ? AppColors.good
                            : (truc.isBad
                                ? AppColors.bad
                                : AppColors.inkSoft))),
              ),
              const Spacer(),
              HelpIcon(
                title: 'Trực ${truc.name} là gì?',
                content: '${explain('truc')}\n\n'
                    'Hôm nay là Trực ${truc.name} (${truc.nature}). '
                    'Trực này hợp: ${truc.nen}. '
                    'Nên kiêng: ${truc.kieng}.',
              ),
            ],
          ),
          const SizedBox(height: 10),
          _line(Icons.check_circle, AppColors.good, 'Nên', truc.nen),
          const SizedBox(height: 6),
          _line(Icons.cancel, AppColors.bad, 'Tránh', truc.kieng),
        ],
      ),
    );
  }

  Widget _line(IconData icon, Color color, String label, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
                children: [
                  TextSpan(
                      text: '$label: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: color)),
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
        ],
      );
}

class _FigureRow extends StatelessWidget {
  final HistoricalFigure figure;
  const _FigureRow({required this.figure});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.cake_outlined, size: 18, color: AppColors.jade),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${figure.name} — sinh năm ${figure.birthYear}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.ink)),
              Text(figure.note,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.inkSoft)),
            ],
          ),
        ),
      ],
    );
  }
}
