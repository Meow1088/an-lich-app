import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../core/lunar_calendar.dart';
import '../core/ngay_via.dart';
import '../core/van_khan.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Cúng lễ: hôm nay (chay/vía) + văn khấn + ngày vía + lịch ăn chay.
class CungLeScreen extends StatelessWidget {
  const CungLeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lunar = solarToLunar(now.day, now.month, now.year);
    final chay = chayTypesOf(lunar.day);
    final vias = viaOnDate(lunar.day, lunar.month);
    final sortedVia = [...ngayViaList]
      ..sort((a, b) => a.month != b.month ? a.month - b.month : a.day - b.day);
    final thap = (chayDays[ChayType.thap]!.toList()..sort());

    return AppScaffold(
      title: 'Cúng lễ',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            children: [
              GlassCard(
                fill: AppColors.glassStrong,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hôm nay: ${lunar.day}/${lunar.month} âm lịch',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.jadeDark)),
                    const SizedBox(height: 6),
                    if (chay.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.spa, size: 18, color: AppColors.good),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                                'Ngày chay — ${chay.map((t) => t.label.split(' ').first).join(', ')}',
                                style: const TextStyle(
                                    color: AppColors.good,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5)),
                          ),
                        ],
                      )
                    else
                      const Text('Không phải ngày chay.',
                          style: TextStyle(
                              color: AppColors.inkSoft, fontSize: 13)),
                    for (final v in vias)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${v.emoji} ${v.name}',
                            style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _title('Văn khấn'),
              const SizedBox(height: 8),
              for (final vk in vanKhanList) ...[
                _VanKhanTile(vk: vk),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              _title('Ngày vía trong năm'),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    for (var i = 0; i < sortedVia.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 14, color: AppColors.glassBorder),
                      Row(
                        children: [
                          Text(sortedVia[i].emoji,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(sortedVia[i].name,
                                style: const TextStyle(
                                    color: AppColors.ink, fontSize: 13.5)),
                          ),
                          Text('${sortedVia[i].day}/${sortedVia[i].month} ÂL',
                              style: const TextStyle(
                                  color: AppColors.jade,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _title('Lịch ăn chay (Thập trai)'),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final d in thap)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.good.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.good.withValues(alpha: 0.4)),
                            ),
                            child: Text('$d',
                                style: const TextStyle(
                                    color: AppColors.good,
                                    fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Nhị trai: 1, 15 · Lục trai: 8,14,15,23,29,30 · Tứ trai: 1,14,15,30',
                        style:
                            TextStyle(color: AppColors.inkSoft, fontSize: 12)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Văn khấn theo bản phổ biến, có nhiều dị bản. Thông tin mang tính tham khảo.',
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

  Widget _title(String t) => Text(t,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.jadeDark));
}

class _VanKhanTile extends StatelessWidget {
  final VanKhan vk;
  const _VanKhanTile({required this.vk});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => VanKhanDetailScreen(vk: vk))),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.menu_book, color: AppColors.jade, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vk.title,
                      style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5)),
                  Text(vk.dip,
                      style: const TextStyle(
                          color: AppColors.inkSoft, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkSoft),
          ],
        ),
      ),
    );
  }
}

/// Chi tiết 1 bài văn khấn — chữ to, đọc được, có thể copy.
/// Giữ màn hình luôn sáng khi đọc (tiện lúc cúng, tay bận).
class VanKhanDetailScreen extends StatefulWidget {
  final VanKhan vk;
  const VanKhanDetailScreen({super.key, required this.vk});

  @override
  State<VanKhanDetailScreen> createState() => _VanKhanDetailScreenState();
}

class _VanKhanDetailScreenState extends State<VanKhanDetailScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vk = widget.vk;
    return AppScaffold(
      title: 'Văn khấn',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: [
              Text(vk.title,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark)),
              const SizedBox(height: 2),
              Text(vk.dip,
                  style:
                      const TextStyle(color: AppColors.inkSoft, fontSize: 13)),
              const SizedBox(height: 14),
              GlassCard(
                fill: AppColors.glassStrong,
                child: SelectableText(
                  vk.body,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 16, height: 1.6),
                ),
              ),
            ],
          ),
    );
  }
}
