import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/ngay_xau.dart';
import '../core/xuat_hanh.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Hướng xuất hành + giờ tốt Lý Thuần Phong cho một ngày.
class XuatHanhScreen extends StatefulWidget {
  const XuatHanhScreen({super.key});

  @override
  State<XuatHanhScreen> createState() => _XuatHanhScreenState();
}

class _XuatHanhScreenState extends State<XuatHanhScreen> {
  DateTime _date = DateTime.now();

  Future<void> _pick() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('vi'),
    );
    if (d != null) setState(() => _date = d);
  }

  @override
  Widget build(BuildContext context) {
    final dd = _date.day, mm = _date.month, yy = _date.year;
    final xh = xuatHanhOfDay(dd, mm, yy);
    final lunar = solarToLunar(dd, mm, yy);
    final bad = badDaysOf(dd, mm, yy);
    final hours = lucDieuHours(dd, mm, yy);

    return AppScaffold(
      title: 'Hướng xuất hành',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            children: [
              GlassCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$dd/$mm/$yy · ${lunar.day}/${lunar.month} ÂL',
                        style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pick,
                      icon: const Icon(Icons.edit_calendar, size: 18),
                      label: const Text('Đổi ngày'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DirRow('Hỷ Thần (may mắn)', xh.hyThan, AppColors.good),
                    const SizedBox(height: 8),
                    _DirRow('Tài Thần (tài lộc)', xh.taiThan, AppColors.gold),
                  ],
                ),
              ),
              if (bad.isNotEmpty) ...[
                const SizedBox(height: 12),
                GlassCard(
                  fill: AppColors.glassBadFill,
                  borderColor: AppColors.glassBadBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ngày xấu cổ truyền',
                          style: TextStyle(
                              color: AppColors.bad,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      for (final b in bad)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text('• ${b.name}: ${b.reason}',
                              style: const TextStyle(
                                  color: AppColors.ink, fontSize: 12.5)),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Giờ xuất hành (Lý Thuần Phong)',
                        style: TextStyle(
                            color: AppColors.jadeDark,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    for (final h in hours)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Icon(
                                h.good
                                    ? Icons.check_circle
                                    : Icons.cancel_outlined,
                                size: 16,
                                color: h.good ? AppColors.good : AppColors.bad),
                            const SizedBox(width: 8),
                            SizedBox(
                                width: 96,
                                child: Text('${h.chi} (${h.range})',
                                    style: const TextStyle(
                                        color: AppColors.ink, fontSize: 13))),
                            Text(h.state,
                                style: TextStyle(
                                    color: h.good
                                        ? AppColors.good
                                        : AppColors.inkSoft,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
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

class _DirRow extends StatelessWidget {
  final String label;
  final String dir;
  final Color color;
  const _DirRow(this.label, this.dir, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.explore, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.inkSoft, fontSize: 13.5))),
        Text(dir,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: 16)),
      ],
    );
  }
}
