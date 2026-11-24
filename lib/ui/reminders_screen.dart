import 'package:flutter/material.dart';
import '../data/reminder_store.dart';
import '../services/notifications.dart';
import 'add_reminder_screen.dart';
import 'theme.dart';

const _weekdays = [
  '',
  'Thứ Hai',
  'Thứ Ba',
  'Thứ Tư',
  'Thứ Năm',
  'Thứ Sáu',
  'Thứ Bảy',
  'Chủ Nhật',
];

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _store = ReminderStore();
  List<Reminder> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _store.list();
    setState(() {
      _items = items;
      _loading = false;
    });
    await NotificationService.instance.rescheduleAll(items);
  }

  Future<void> _addReminder() async {
    final r = await Navigator.of(context).push<Reminder>(
      MaterialPageRoute(builder: (_) => const AddReminderScreen()),
    );
    if (r != null) {
      await _store.upsert(r);
      await _load();
    }
  }

  Future<void> _editReminder(Reminder reminder) async {
    final r = await Navigator.of(context).push<Reminder>(
      MaterialPageRoute(builder: (_) => AddReminderScreen(initial: reminder)),
    );
    if (r != null) {
      await _store.upsert(r);
      await _load();
    }
  }

  String _repeatLabel(RepeatType r) {
    switch (r) {
      case RepeatType.monthly:
        return 'Hằng tháng';
      case RepeatType.once:
        return 'Một lần';
      case RepeatType.yearly:
        return 'Hằng năm';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'Chưa có nhắc nhở.\nNhấn + để thêm giỗ, lễ...',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.ink),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final r = _items[i];
                final next = r.nextOccurrence(DateTime.now());
                final cal = r.isLunar ? 'ÂL' : 'DL';
                String sub;
                if (next == null) {
                  sub = '${r.day}/${r.month} $cal · ${_repeatLabel(r.repeat)}';
                } else {
                  final days = DateTime(next.year, next.month, next.day)
                      .difference(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        ),
                      )
                      .inDays;
                  final dleft = days == 0 ? 'hôm nay' : 'còn $days ngày';
                  sub =
                      '${r.day}/${r.month} $cal · ${_repeatLabel(r.repeat)} → ${_weekdays[next.weekday]} ${next.day}/${next.month}/${next.year} ($dleft)';
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    radius: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ListTile(
                      onTap: () => _editReminder(r),
                      leading: const Icon(
                        Icons.event_note,
                        color: AppColors.jade,
                      ),
                      title: Text(
                        r.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub,
                            style: const TextStyle(color: AppColors.inkSoft),
                          ),
                          if (r.note.isNotEmpty)
                            Text(
                              r.note,
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: AppColors.inkSoft,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Sửa',
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: AppColors.jade,
                            ),
                            onPressed: () => _editReminder(r),
                          ),
                          IconButton(
                            tooltip: 'Xóa',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.bad,
                            ),
                            onPressed: () async {
                              await _store.delete(r.id);
                              await _load();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
