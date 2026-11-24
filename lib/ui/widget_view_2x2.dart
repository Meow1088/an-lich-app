import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/hoang_dao.dart';
import '../core/lunar_calendar.dart';
import 'theme.dart';

class _W2x2Palette {
  final Color card, border, ink, muted, number, todayBg, danger, good, gold, divider;

  const _W2x2Palette({
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

  static const light = _W2x2Palette(
    card: Color(0x8CF4FAF5),
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

  static const dark = _W2x2Palette(
    card: Color(0xA80E2A22),
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

  static _W2x2Palette of(AppThemeSpec spec) => spec.dark ? dark : light;
}

/// Giao diện widget màn hình chính 2x2 vuông nhỏ gọn.
class HomeWidget2x2View extends StatelessWidget {
  final DateTime date;
  final double width;
  final double height;

  const HomeWidget2x2View({
    super.key,
    required this.date,
    this.width = 180,
    this.height = 180,
  });

  static const _dowNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final spec = appThemeNotifier.value;
    final p = _W2x2Palette.of(spec);

    final lunar = solarToLunar(date.day, date.month, date.year);
    final dowIdx = (date.weekday - 1) % 7;
    final isSunday = date.weekday == DateTime.sunday;
    final numColor = isSunday ? p.danger : p.number;

    final dq = dayQuality(date.day, date.month, date.year);
    final isHoangDao = dq.isHoangDao;
    final gioHoangDao = luckyHours(date.day, date.month, date.year).map((h) => h.chi);
    final canChiDayName = canChiOfDay(date.day, date.month, date.year);

    return MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.border, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hàng trên: Thứ & Tháng/Năm Dương
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSunday ? p.danger : p.todayBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _dowNames[dowIdx],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Th${date.month}/${date.year}',
                    style: TextStyle(
                      color: p.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Số ngày Dương nổi bật
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                  color: numColor,
                ),
              ),

              // Ngày Âm Lịch + Badge Hoàng Đạo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${lunar.day}/${lunar.month} Âm',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: p.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: isHoangDao
                          ? p.good.withValues(alpha: 0.2)
                          : p.danger.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isHoangDao ? 'HĐ' : 'HĐao',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isHoangDao ? p.good : p.danger,
                      ),
                    ),
                  ),
                ],
              ),

              // Can Chi ngày + Giờ Hoàng Đạo
              Column(
                children: [
                  Text(
                    'Ngày $canChiDayName',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: p.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Giờ HĐ: ${gioHoangDao.take(4).join(', ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: p.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
