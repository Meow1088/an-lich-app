import 'package:flutter/material.dart';
import '../core/hoang_dao.dart';
import '../core/lunar_calendar.dart';
import '../core/trach_nhat.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Xem ngày tốt theo việc: chọn việc + độ dài khoảng -> danh sách ngày xếp hạng.
class XemNgayTotScreen extends StatefulWidget {
  const XemNgayTotScreen({super.key});

  @override
  State<XemNgayTotScreen> createState() => _XemNgayTotScreenState();
}

class _XemNgayTotScreenState extends State<XemNgayTotScreen> {
  Viec _viec = viecList.first;
  int _days = 60; // 30 / 60 / 90

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final from = DateTime(today.year, today.month, today.day);
    final to = from.add(Duration(days: _days - 1));
    final results = findGoodDays(_viec, from, to);

    return AppScaffold(
      title: 'Xem ngày tốt',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Chọn việc',
                        style: TextStyle(
                            color: AppColors.inkSoft,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    DropdownButton<Viec>(
                      value: _viec,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (final v in viecList)
                          DropdownMenuItem(value: v, child: Text(v.label)),
                      ],
                      onChanged: (v) => setState(() => _viec = v!),
                    ),
                    const SizedBox(height: 10),
                    const Text('Khoảng tìm',
                        style: TextStyle(
                            color: AppColors.inkSoft,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 30, label: Text('30 ngày')),
                        ButtonSegment(value: 60, label: Text('60 ngày')),
                        ButtonSegment(value: 90, label: Text('90 ngày')),
                      ],
                      selected: {_days},
                      onSelectionChanged: (s) =>
                          setState(() => _days = s.first),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              for (final r in results) ...[
                _DayCard(r),
                const SizedBox(height: 10),
              ],
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Thông tin mang tính tham khảo / tín ngưỡng dân gian.',
                  style: TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
    );
  }
}

Color _levelColor(DayLevel l) => switch (l) {
      DayLevel.ratTot => AppColors.good,
      DayLevel.tot => AppColors.jade,
      DayLevel.binh => AppColors.inkSoft,
      DayLevel.xau => AppColors.bad,
      DayLevel.ratXau => AppColors.bad,
    };

const _thuNames = [
  'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
];

class _DayCard extends StatelessWidget {
  final DayScore s;
  const _DayCard(this.s);

  @override
  Widget build(BuildContext context) {
    final date = DateTime(s.yy, s.mm, s.dd);
    final lunar = solarToLunar(s.dd, s.mm, s.yy);
    final color = _levelColor(s.level);
    final hours = luckyHours(s.dd, s.mm, s.yy).map((h) => h.chi).join(', ');

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_thuNames[date.weekday - 1]}, ${s.dd}/${s.mm}/${s.yy}',
                  style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.7)),
                ),
                child: Text(s.level.label,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text('${lunar.day}/${lunar.month} ÂL · điểm ${s.score}',
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 12.5)),
          if (s.goodReasons.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('✓ ${s.goodReasons.join(' · ')}',
                style: const TextStyle(color: AppColors.good, fontSize: 12.5)),
          ],
          if (s.badReasons.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('✕ ${s.badReasons.join(' · ')}',
                style: const TextStyle(color: AppColors.bad, fontSize: 12.5)),
          ],
          const SizedBox(height: 4),
          Text('Giờ hoàng đạo: $hours',
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 12)),
        ],
      ),
    );
  }
}
