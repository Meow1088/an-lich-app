import 'package:flutter/material.dart';
import '../core/kien_thuc.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Góc kiến thức — danh sách bài viết mẹo phong thủy đời sống.
class KienThucScreen extends StatelessWidget {
  const KienThucScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Góc kiến thức',
      body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            children: [
              for (final b in baiVietList) ...[
                _BaiTile(b: b),
                const SizedBox(height: 10),
              ],
            ],
          ),
    );
  }
}

class _BaiTile extends StatelessWidget {
  final BaiViet b;
  const _BaiTile({required this.b});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BaiVietScreen(b: b))),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline,
                color: AppColors.gold, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.title,
                      style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5)),
                  const SizedBox(height: 2),
                  Text(b.tomTat,
                      style: const TextStyle(
                          color: AppColors.inkSoft, fontSize: 12.5)),
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

/// Đọc 1 bài — chữ to, có thể copy.
class BaiVietScreen extends StatelessWidget {
  final BaiViet b;
  const BaiVietScreen({super.key, required this.b});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Góc kiến thức',
      body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            children: [
              Text(b.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark,
                      height: 1.3)),
              const SizedBox(height: 14),
              GlassCard(
                fill: AppColors.glassStrong,
                child: SelectableText(
                  b.body,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 16, height: 1.6),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12),
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
