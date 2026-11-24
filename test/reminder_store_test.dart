import 'package:flutter_test/flutter_test.dart';
import 'package:lich_am/data/reminder_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final from = DateTime(2026, 6, 25); // mốc cố định để test xác định

  Reminder r({
    bool isLunar = true,
    int day = 1,
    int month = 1,
    RepeatType repeat = RepeatType.yearly,
    String? onceSolar,
    bool notify = true,
    int before = 0,
    bool daily = false,
  }) => Reminder(
    id: 't',
    title: 'Test',
    isLunar: isLunar,
    day: day,
    month: month,
    repeat: repeat,
    onceSolar: onceSolar,
    notify: notify,
    remindBeforeDays: before,
    remindDaily: daily,
  );

  group('nextOccurrence', () {
    test('âm lịch hằng năm: Tết (1/1 ÂL) sau 25/6/2026 = 6/2/2027', () {
      final n = r(isLunar: true, day: 1, month: 1).nextOccurrence(from);
      expect(n, DateTime(2027, 2, 6));
    });

    test('dương lịch hằng năm: 2/9 sau 25/6/2026 = 2/9/2026', () {
      final n = r(isLunar: false, day: 2, month: 9).nextOccurrence(from);
      expect(n, DateTime(2026, 9, 2));
    });

    test('dương lịch hằng năm vắt năm: 1/1 sau 25/6/2026 = 1/1/2027', () {
      final n = r(isLunar: false, day: 1, month: 1).nextOccurrence(from);
      expect(n, DateTime(2027, 1, 1));
    });

    test('dương lịch hằng tháng: ngày 10 sau 25/6/2026 = 10/7/2026', () {
      final n = r(
        isLunar: false,
        day: 10,
        repeat: RepeatType.monthly,
      ).nextOccurrence(from);
      expect(n, DateTime(2026, 7, 10));
    });

    test('một lần: ngày dương tương lai trả đúng, quá khứ trả null', () {
      expect(
        r(
          repeat: RepeatType.once,
          onceSolar: '2026-12-31',
        ).nextOccurrence(from),
        DateTime(2026, 12, 31),
      );
      expect(
        r(
          repeat: RepeatType.once,
          onceSolar: '2020-01-01',
        ).nextOccurrence(from),
        isNull,
      );
    });
  });

  group('notificationDates', () {
    test('nhắc trước 3 ngày (1 lần): 1 ngày = sự kiện - 3', () {
      final dates = r(
        isLunar: false,
        day: 2,
        month: 9,
        before: 3,
      ).notificationDates(from);
      expect(dates, [DateTime(2026, 8, 30)]);
    });

    test('nhắc mỗi ngày trước 3 ngày: 4 ngày liên tiếp tới sự kiện', () {
      final dates = r(
        isLunar: false,
        day: 2,
        month: 9,
        before: 3,
        daily: true,
      ).notificationDates(from);
      expect(dates, [
        DateTime(2026, 8, 30),
        DateTime(2026, 8, 31),
        DateTime(2026, 9, 1),
        DateTime(2026, 9, 2),
      ]);
    });

    test('tắt thông báo: không có ngày nào', () {
      final dates = r(
        isLunar: false,
        day: 2,
        month: 9,
        notify: false,
      ).notificationDates(from);
      expect(dates, isEmpty);
    });
  });

  test('fromJson tương thích bản cũ (lunarDay/lunarMonth)', () {
    final old = Reminder.fromJson({
      'id': 'x',
      'title': 'Giỗ',
      'lunarDay': 10,
      'lunarMonth': 5,
    });
    expect(old.isLunar, true);
    expect(old.day, 10);
    expect(old.month, 5);
    expect(old.repeat, RepeatType.yearly);
    expect(old.notify, true);
  });

  test(
    'ReminderStore.upsert sửa bản cũ theo id, không tạo bản trùng',
    () async {
      SharedPreferences.setMockInitialValues({});
      final store = ReminderStore();

      await store.upsert(
        const Reminder(id: 'same', title: 'Giỗ', day: 10, month: 5),
      );
      await store.upsert(
        const Reminder(
          id: 'same',
          title: 'Giỗ đã sửa',
          note: 'ghi chú mới',
          day: 11,
          month: 6,
        ),
      );

      final items = await store.list();
      expect(items, hasLength(1));
      expect(items.single.title, 'Giỗ đã sửa');
      expect(items.single.note, 'ghi chú mới');
      expect(items.single.day, 11);
      expect(items.single.month, 6);
    },
  );
}
