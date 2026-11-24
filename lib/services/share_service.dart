import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../core/can_chi.dart';
import '../core/lunar_calendar.dart';
import '../core/tu_vi_ngay.dart';
import '../data/profile_store.dart';
import '../ui/share_card.dart';

/// Render ShareCard ra PNG rồi mở share sheet hệ thống.
/// Nếu có hồ sơ cá nhân → kèm "Tử vi hôm nay của tôi" vào ảnh + caption.
class ShareService {
  static Future<void> shareDay(BuildContext context, DateTime date) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      // Nạp hồ sơ để thêm tử vi cá nhân (nếu có).
      final profile = await ProfileStore().load();
      TuViNgay? horo;
      String? hName;
      String? hCon;
      if (profile != null) {
        final lb = solarToLunar(profile.birthDate.day, profile.birthDate.month,
            profile.birthDate.year);
        hCon = canChiOfYear(lb.year);
        horo = tuViNgay(profile.birthDate, lb.year, date);
        hName = profile.name.trim().isEmpty ? 'tôi' : profile.name.trim();
      }

      final card = ShareCard(
        date: date,
        horoscope: horo,
        horoName: hName,
        horoConGiap: hCon,
      );

      if (!context.mounted) return;
      final bytes = await ScreenshotController().captureFromWidget(
        card,
        context: context,
        targetSize: card.size,
        pixelRatio: 3,
        delay: const Duration(milliseconds: 120),
      );
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/lich_am_${date.year}_${date.month}_${date.day}.png');
      await file.writeAsBytes(bytes);

      final caption = horo != null
          ? 'An Lịch ngày ${date.day}/${date.month}/${date.year} · Tử vi hôm nay của $hName'
          : 'An Lịch ngày ${date.day}/${date.month}/${date.year}';

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: caption,
        ),
      );
    } catch (e) {
      messenger?.showSnackBar(
        SnackBar(content: Text('Không chia sẻ được ảnh: $e')),
      );
    }
  }
}
