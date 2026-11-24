import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/can_chi.dart';
import '../core/lunar_events.dart';
import '../core/solar_events.dart';
import '../core/truc_tu.dart';
import '../core/tu_vi_ngay.dart';
import '../core/historical_figures.dart';
import 'theme.dart';

const _weekdays = [
  '', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
];

/// Thẻ "hôm nay" dạng dọc render ra PNG chia sẻ. Nền = ảnh theme đang chọn,
/// nội dung trong panel kính sáng (chữ tối đọc rõ mọi theme).
/// Cao 600 nếu không có hồ sơ; 760 nếu kèm "Tử vi hôm nay của tôi".
class ShareCard extends StatelessWidget {
  final DateTime date;
  final TuViNgay? horoscope;
  final String? horoName;
  final String? horoConGiap;

  const ShareCard({
    super.key,
    required this.date,
    this.horoscope,
    this.horoName,
    this.horoConGiap,
  });

  Size get size => horoscope == null ? const Size(380, 560) : const Size(380, 800);

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(date.day, date.month, date.year);
    final truc = trucOfDay(date.day, date.month, date.year);
    final tu = tuOfDay(date.day, date.month, date.year);
    final tiet = tietKhiOfDay(date.day, date.month, date.year);
    final spec = AppTheme.current;

    final majorEv = [
      ...solarEventsForDate(date.month, date.day),
      ...eventsForLunarDate(lunar.day, lunar.month),
    ].where((e) => e.isMajor).toList();
    final figures = figuresOnDate(date.month, date.day);
    final sz = size;

    return Container(
      width: sz.width,
      height: sz.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(spec.bgAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.spa, color: spec.onBg, size: 22, shadows: onBgShadows(spec)),
                const SizedBox(width: 8),
                Text('AN LỊCH',
                    style: TextStyle(
                        color: spec.onBg,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                        fontSize: 16,
                        shadows: onBgShadows(spec))),
                const Spacer(),
                Text('${date.year}',
                    style: TextStyle(
                        color: spec.onBg,
                        fontWeight: FontWeight.w700,
                        shadows: onBgShadows(spec))),
              ],
            ),
            const SizedBox(height: 12),
            // Panel kính sáng chứa nội dung — đọc rõ trên mọi nền.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                      '${_weekdays[date.weekday]}, ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${lunar.day}',
                            style: const TextStyle(
                                color: AppColors.jadeDark,
                                fontSize: 72,
                                height: 1,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Tháng ${lunar.month}${lunar.isLeapMonth ? ' (nhuận)' : ''} âm lịch',
                                  style: const TextStyle(
                                      color: AppColors.ink, fontSize: 15)),
                              Text('Năm ${canChiOfYear(lunar.year)}',
                                  style: const TextStyle(
                                      color: AppColors.inkSoft, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.jade.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.jade.withValues(alpha: 0.18)),
                      ),
                      child: Column(
                        children: [
                          _row('Ngày',
                              '${canChiOfDay(date.day, date.month, date.year)} · ${napAmOfDay(date.day, date.month, date.year).name}'),
                          _row('Trực', '${truc.name} (${truc.nature})'),
                          _row('Sao', '${tu.name} · ${tu.good ? "Tốt" : "Xấu"}'),
                          _row('Tiết khí', tiet),
                        ],
                      ),
                    ),
                    if (majorEv.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('${majorEv.first.emoji}  ${majorEv.first.name}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.jadeDark)),
                    ],
                    if (horoscope != null) ...[
                      const SizedBox(height: 10),
                      _horoscopeBlock(),
                    ] else if (figures.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                          'Ngày này: ${figures.first.name} (sinh ${figures.first.birthYear})',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13.5, color: AppColors.inkSoft)),
                    ],
                  ],
                ),
              ),
            const Spacer(),
            Center(
              child: Text('Tạo từ ứng dụng An Lịch',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: spec.onBg,
                      shadows: onBgShadows(spec))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _horoscopeBlock() {
    final tv = horoscope!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                    'Tử vi hôm nay của ${horoName ?? 'tôi'}'
                    '${horoConGiap != null ? ' · tuổi $horoConGiap' : ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.jadeDark)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(tv.tongQuan,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.inkSoft, height: 1.4)),
          const SizedBox(height: 8),
          for (final m in tv.mucs)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.icon, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 78,
                                child: Text(m.label,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink))),
                            for (var i = 0; i < 5; i++)
                              Icon(i < m.sao ? Icons.star : Icons.star_border,
                                  size: 14,
                                  color: m.tot
                                      ? AppColors.good
                                      : (m.xau
                                          ? AppColors.bad
                                          : AppColors.gold)),
                          ],
                        ),
                        Text(m.moTa,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
                                height: 1.35)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              child: Text(label,
                  style: const TextStyle(color: AppColors.inkSoft, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}
