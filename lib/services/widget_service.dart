import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import '../data/reminder_store.dart';
import '../ui/widget_view.dart';
import '../ui/widget_view_2x2.dart';

/// Render giao diện widget bằng Flutter -> ảnh PNG, rồi yêu cầu Android cập nhật.
/// Hỗ trợ 2 loại widget: 4x2 (chi tiết nhắc nhở) và 2x2 (nhỏ gọn).
class WidgetService {
  static const String _imageKey = 'lich_widget_image';
  static const String _provider = 'LichAmWidgetProvider';
  static const String _qualifiedProvider =
      'com.goccuameo.lich_am.LichAmWidgetProvider';
  static const Size _size = Size(380, 205);

  static const String _imageKey2x2 = 'lich_widget_2x2_image';
  static const String _provider2x2 = 'LichAmWidget2x2Provider';
  static const String _qualifiedProvider2x2 =
      'com.goccuameo.lich_am.LichAmWidget2x2Provider';
  static const Size _size2x2 = Size(180, 180);

  /// Render sẵn hôm nay + 30 ngày tới để widget tự đổi ngày lúc nửa đêm.
  static const int _prerenderDays = 31;

  static const MethodChannel _batteryChannel = MethodChannel(
    'com.goccuameo.lich_am/battery',
  );

  static bool _updating = false;

  static final RegExp _datedImage = RegExp(
    r'^(lich_widget_image|lich_widget_2x2_image)_(\d{4})-(\d{2})-(\d{2})\.png$',
  );

  /// Tên file ảnh có ngày < today -> trả key (bỏ đuôi .png) để xoá.
  /// Bỏ qua khoá fallback không có ngày, file lạ, ngày sai định dạng.
  static List<String> staleWidgetKeys(
    Iterable<String> fileNames,
    DateTime today,
  ) {
    final t = DateTime(today.year, today.month, today.day);
    final out = <String>[];
    for (final name in fileNames) {
      final m = _datedImage.firstMatch(name);
      if (m == null) continue;
      final y = int.parse(m.group(2)!);
      final mo = int.parse(m.group(3)!);
      final d = int.parse(m.group(4)!);
      final date = DateTime(y, mo, d);
      if (date.year != y || date.month != mo || date.day != d) continue;
      if (date.isBefore(t)) out.add(name.substring(0, name.length - 4));
    }
    return out;
  }

  static Future<void> _cleanupStale(DateTime today) async {
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/home_widget');
      if (!await dir.exists()) return;
      final names = <String>[];
      await for (final e in dir.list()) {
        if (e is File) names.add(e.uri.pathSegments.last);
      }
      for (final key in staleWidgetKeys(names, today)) {
        await HomeWidget.saveWidgetData<String>(key, null);
      }
    } catch (e) {
      debugPrint('Widget cleanup failed: $e');
    }
  }

  /// true = app không bị hạn chế pin (widget đổi ngày ổn định); null = không áp dụng/lỗi.
  static Future<bool?> isBatteryUnrestricted() async {
    if (!Platform.isAndroid) return null;
    try {
      return await _batteryChannel.invokeMethod<bool>(
        'isIgnoringBatteryOptimizations',
      );
    } catch (e) {
      debugPrint('Battery state failed: $e');
      return null;
    }
  }

  static Future<void> openAppBatterySettings() async {
    try {
      await _batteryChannel.invokeMethod<void>('openAppSettings');
    } catch (e) {
      debugPrint('Open app settings failed: $e');
    }
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Future<void> _render(
    DateTime date,
    String key,
    List<Reminder> reminders,
  ) => HomeWidget.renderFlutterWidget(
    HomeWidgetView(
      date: date,
      width: _size.width,
      height: _size.height,
      reminders: reminders,
    ),
    key: key,
    logicalSize: _size,
    pixelRatio: 3,
  );

  static Future<void> _render2x2(
    DateTime date,
    String key,
  ) => HomeWidget.renderFlutterWidget(
    HomeWidget2x2View(
      date: date,
      width: _size2x2.width,
      height: _size2x2.height,
    ),
    key: key,
    logicalSize: _size2x2,
    pixelRatio: 3,
  );

  static Future<void> update() async {
    if (!Platform.isAndroid || _updating) return;
    _updating = true;
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final reminders = await ReminderStore().list();

      for (var i = 0; i < _prerenderDays; i++) {
        final d = today.add(Duration(days: i));
        final dk = _dateKey(d);
        await _render(d, '${_imageKey}_$dk', reminders);
        await _render2x2(d, '${_imageKey2x2}_$dk');
      }

      // Khoá cũ (fallback) = hôm nay.
      await _render(today, _imageKey, reminders);
      await _render2x2(today, _imageKey2x2);

      await HomeWidget.updateWidget(
        androidName: _provider,
        qualifiedAndroidName: _qualifiedProvider,
      );

      await HomeWidget.updateWidget(
        androidName: _provider2x2,
        qualifiedAndroidName: _qualifiedProvider2x2,
      );

      await _cleanupStale(today);
    } catch (e) {
      debugPrint('Widget update failed: $e');
    } finally {
      _updating = false;
    }
  }
}
