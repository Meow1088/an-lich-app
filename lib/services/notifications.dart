import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../data/reminder_store.dart';

/// Bọc flutter_local_notifications. Thiết kế phòng thủ: app vẫn chạy bình thường
/// nếu thông báo thất bại (vd Samsung One UI chặn alarm nền).
class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    try {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, iOS: ios),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
      _ready = true;
    } catch (e) {
      debugPrint('Notification init failed: $e');
    }
  }

  /// Đặt lại lịch thông báo cho toàn bộ nhắc nhở (lần xảy ra kế tiếp).
  Future<void> rescheduleAll(List<Reminder> reminders) async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'lich_am_reminders',
          'Nhắc nhở âm lịch',
          channelDescription: 'Nhắc giỗ, lễ theo ngày âm lịch',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );
      final now = DateTime.now();
      var id = 0;
      for (final r in reminders) {
        final event = r.nextOccurrence(now);
        if (event == null) continue;
        final cal = r.isLunar ? 'âm lịch' : 'dương lịch';
        for (final fd in r.notificationDates(now)) {
          var when = tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, 7, 0);
          final tzNow = tz.TZDateTime.now(tz.local);
          if (when.isBefore(tzNow)) {
            final sameDay =
                fd.year == now.year &&
                fd.month == now.month &&
                fd.day == now.day;
            if (!sameDay) continue;
            when = tzNow.add(const Duration(minutes: 1));
          }
          final daysLeft = DateTime(
            event.year,
            event.month,
            event.day,
          ).difference(DateTime(fd.year, fd.month, fd.day)).inDays;
          final lead = daysLeft == 0
              ? 'Hôm nay (${r.day}/${r.month} $cal)'
              : 'Còn $daysLeft ngày (${r.day}/${r.month} $cal)';
          final body = r.note.isEmpty ? lead : '$lead\n${r.note}';
          await _plugin.zonedSchedule(
            id: id++,
            title: 'Nhắc nhở: ${r.title}',
            body: body,
            scheduledDate: when,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
        }
      }
    } catch (e) {
      debugPrint('Reschedule failed: $e');
    }
  }
}
