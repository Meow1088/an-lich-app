import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/backup_service.dart';
import '../data/reminder_store.dart';
import '../data/settings_store.dart';
import '../services/notifications.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Màn Sao lưu & Khôi phục dữ liệu (offline) — qua tệp .json.
class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _service = BackupService();
  bool _busy = false;

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String get _stamp =>
      DateTime.now().toIso8601String().substring(0, 10).replaceAll('-', '');

  /// Lưu tệp .json thẳng vào máy qua hộp thoại "Tạo tài liệu" của hệ thống
  /// (SAF — không cần quyền bộ nhớ). file_selector KHÔNG hỗ trợ lưu tệp trên
  /// Android nên dùng flutter_file_dialog.
  Future<void> _exportSaveToDevice() async {
    if (!Platform.isAndroid) {
      await _exportShare();
      return;
    }
    setState(() => _busy = true);
    try {
      final json = await _service.exportJson();
      final savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          data: Uint8List.fromList(utf8.encode(json)),
          fileName: 'an_lich_backup_$_stamp.json',
          mimeTypesFilter: const ['application/json'],
        ),
      );
      if (savedPath == null) {
        if (mounted) setState(() => _busy = false);
        return; // người dùng bấm Huỷ
      }
      _snack('Đã lưu tệp sao lưu vào máy.');
    } catch (e) {
      _snack('Không lưu được tệp: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportShare() async {
    setState(() => _busy = true);
    try {
      final json = await _service.exportJson();
      final dir = await getTemporaryDirectory();
      final stamp = _stamp;
      final file = File('${dir.path}/an_lich_backup_$stamp.json');
      await file.writeAsString(json);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          text: 'Sao lưu An Lịch ($stamp)',
        ),
      );
    } catch (e) {
      _snack('Không tạo được tệp sao lưu: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importFile() async {
    setState(() => _busy = true);
    try {
      const group = XTypeGroup(label: 'JSON', extensions: ['json']);
      final picked = await openFile(acceptedTypeGroups: [group]);
      if (picked == null) {
        if (mounted) setState(() => _busy = false);
        return;
      }
      final raw = await picked.readAsString();
      final n = await _service.importJson(raw);
      // Áp lại theme + lịch thông báo theo dữ liệu vừa khôi phục.
      final store = SettingsStore();
      ThemeController.mode = ThemeController.modeFromString(
        await store.getThemeMode(),
      );
      ThemeController.lightId = await store.getLightThemeId();
      ThemeController.resolve();
      final reminders = await ReminderStore().list();
      await NotificationService.instance.rescheduleAll(reminders);
      _snack(
        'Đã khôi phục $n mục từ tệp. Mở lại app nếu cần làm mới hoàn toàn.',
      );
    } catch (e) {
      _snack('Khôi phục thất bại — tệp không hợp lệ. ($e)');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sao lưu & Khôi phục',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.backup_outlined, color: AppColors.jade),
                    SizedBox(width: 10),
                    Text(
                      'Sao lưu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.jadeDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tạo tệp .json gồm hồ sơ, nhắc nhở và cài đặt giao diện — '
                  'lưu thẳng vào máy, hoặc chia sẻ (Drive, Zalo...) để cất '
                  'giữ / chuyển sang máy khác.',
                  style: TextStyle(color: AppColors.ink, height: 1.4),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _busy ? null : _exportSaveToDevice,
                  icon: const Icon(Icons.save_alt),
                  label: Text(
                    Platform.isAndroid
                        ? 'Lưu tệp vào máy'
                        : 'Lưu bằng bảng chia sẻ',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.jade,
                    minimumSize: const Size.fromHeight(46),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _exportShare,
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Chia sẻ tệp sao lưu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.jade,
                    side: const BorderSide(color: AppColors.jade),
                    minimumSize: const Size.fromHeight(46),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.restore, color: AppColors.gold),
                    SizedBox(width: 10),
                    Text(
                      'Khôi phục',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.jadeDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Chọn tệp .json đã sao lưu để khôi phục. Dữ liệu hiện tại '
                  'sẽ bị ghi đè.',
                  style: TextStyle(color: AppColors.ink, height: 1.4),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _busy ? null : _importFile,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Chọn tệp .json để khôi phục'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: const Color(0xFF4A380A),
                    minimumSize: const Size.fromHeight(46),
                  ),
                ),
              ],
            ),
          ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
