import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../core/bat_trach.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// La bàn động: dùng cảm biến để xoay hoa la bàn, tô xanh hướng tốt / đỏ hướng
/// xấu theo Bát trạch. Mũi tên trên cùng = hướng đang nhìn. THAM KHẢO.
class LaBanScreen extends StatelessWidget {
  final BatTrach batTrach;
  const LaBanScreen({super.key, required this.batTrach});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'La bàn phong thủy',
      body: _body(),
    );
  }

  Widget _body() {
    final stream = FlutterCompass.events;
    if (stream == null) return _fallback();
    return StreamBuilder<CompassEvent?>(
      stream: stream,
      builder: (context, snap) {
        final heading = snap.data?.heading;
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            GlassCard(
              fill: AppColors.glassStrong,
              child: Text(
                'Cung ${batTrach.queName} · ${batTrach.trach}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.jadeDark,
                    fontSize: 16),
              ),
            ),
            const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: heading == null ? 0 : -heading * math.pi / 180,
                    child: CustomPaint(
                        painter: _RosePainter(batTrach), size: Size.infinite),
                  ),
                  // Mũi tên cố định ở đỉnh = hướng đang nhìn.
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Icon(Icons.arrow_drop_down,
                        color: AppColors.jadeDark, size: 44),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (heading == null)
              const GlassCard(
                child: Text(
                    'Đang đọc cảm biến… Xoay điện thoại theo hình số 8 để '
                    'hiệu chỉnh la bàn.',
                    style: TextStyle(color: AppColors.ink)),
              )
            else
              _facingCard(heading),
            const SizedBox(height: 12),
            const Text(
              'Đặt điện thoại nằm ngang, mũi tên trên cùng chỉ hướng bạn đang '
              'nhìn. Hướng tốt tô xanh, xấu tô đỏ. Mang tính tham khảo.',
              style: TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
          ],
        );
      },
    );
  }

  Widget _facingCard(double heading) {
    final idx = (((heading + 22.5) % 360) / 45).floor() % 8;
    final h = batTrach.huongs[idx];
    final c = h.duTinh.tot ? AppColors.good : AppColors.bad;
    return GlassCard(
      fill: AppColors.glassStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đang nhìn hướng ${h.huong}  (${heading.round()}°)',
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.jadeDark,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text('${h.duTinh.name} — ${h.duTinh.tot ? "Hướng TỐT" : "Hướng XẤU"}',
              style:
                  TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 14)),
          Text(h.duTinh.y,
              style: const TextStyle(color: AppColors.ink, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _fallback() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.explore_off, size: 44, color: AppColors.jade),
                SizedBox(height: 10),
                Text('Thiết bị không có cảm biến la bàn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.jadeDark)),
                SizedBox(height: 6),
                Text('Bạn vẫn xem được hướng tốt/xấu ở màn Bát trạch.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.inkSoft, fontSize: 13)),
              ],
            ),
          ),
        ),
      );
}

class _RosePainter extends CustomPainter {
  final BatTrach bt;
  _RosePainter(this.bt);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 4;
    const deg = math.pi / 180;

    for (var h = 0; h < 8; h++) {
      final mid = -math.pi / 2 + h * 45 * deg; // 0 = North (lên trên)
      final start = mid - 22.5 * deg;
      const sweep = 45.0 * deg;
      final tot = bt.huongs[h].duTinh.tot;
      final color = (tot ? AppColors.good : AppColors.bad);
      final rect = Rect.fromCircle(center: center, radius: r);

      canvas.drawArc(rect, start, sweep, true,
          Paint()..color = color.withValues(alpha: 0.30));
      canvas.drawArc(
          rect,
          start,
          sweep,
          true,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = Colors.white70);

      final tp = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: '${bt.huongs[h].huong}\n',
              style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
          TextSpan(
              text: bt.huongs[h].duTinh.name,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 10)),
        ]),
      )..layout(maxWidth: 84);
      final lp = Offset(center.dx + math.cos(mid) * r * 0.6 - tp.width / 2,
          center.dy + math.sin(mid) * r * 0.6 - tp.height / 2);
      tp.paint(canvas, lp);
    }
    canvas.drawCircle(center, 6, Paint()..color = AppColors.jadeDark);
  }

  @override
  bool shouldRepaint(covariant _RosePainter oldDelegate) => false;
}
