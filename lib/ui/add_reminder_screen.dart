import 'package:flutter/material.dart';
import '../data/reminder_store.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Form "Thêm nhắc nhở" (giỗ, lễ, sự kiện) — bố cục theo app tham khảo,
/// nhuốm tông ngọc bích kính mờ của app. Trả về [Reminder] qua Navigator.pop.
class AddReminderScreen extends StatefulWidget {
  final Reminder? initial;

  const AddReminderScreen({super.key, this.initial});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  RepeatType _repeat = RepeatType.yearly;
  bool _isLunar = true;
  int _day = 1;
  int _month = 1;
  bool _notify = true;
  int _before = 1;
  bool _remindDaily = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _titleCtrl.text = initial.title;
      _noteCtrl.text = initial.note;
      _repeat = initial.repeat;
      _isLunar = initial.isLunar;
      _day = initial.day.clamp(1, _maxDay);
      _month = initial.month;
      _notify = initial.notify;
      _before = initial.remindBeforeDays;
      _remindDaily = initial.remindDaily;
    } else {
      final now = DateTime.now();
      _day = now.day.clamp(1, _maxDay);
      _month = now.month;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  int get _maxDay => _isLunar ? 30 : 31;

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tên nhắc nhở trước đã')),
      );
      return;
    }
    String? onceSolar;
    if (_repeat == RepeatType.once) {
      // Giải ngày dương cho lần xảy ra kế tiếp rồi cố định lại.
      final probe = Reminder(
        id: '_',
        title: title,
        isLunar: _isLunar,
        day: _day,
        month: _month,
        repeat: RepeatType.yearly,
      );
      final next = probe.nextOccurrence(DateTime.now());
      if (next == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ngày không hợp lệ, chọn lại giúp mình'),
          ),
        );
        return;
      }
      onceSolar =
          '${next.year.toString().padLeft(4, '0')}-${next.month.toString().padLeft(2, '0')}-${next.day.toString().padLeft(2, '0')}';
    }

    final reminder = Reminder(
      id:
          widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      note: _noteCtrl.text.trim(),
      isLunar: _isLunar,
      day: _day,
      month: _month,
      repeat: _repeat,
      onceSolar: onceSolar,
      notify: _notify,
      remindBeforeDays: _before,
      remindDaily: _remindDaily,
    );
    Navigator.of(context).pop(reminder);
  }

  Future<void> _pickCustomBefore() async {
    final ctrl = TextEditingController(text: '$_before');
    final v = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nhắc trước bao nhiêu ngày?'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'ngày'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text.trim())),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (v != null && v >= 0 && v <= 60) setState(() => _before = v);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.initial == null ? 'Thêm nhắc nhở' : 'Sửa nhắc nhở',
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.check, color: AppColors.jade),
          onPressed: _save,
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _label('TÊN NHẮC NHỞ'),
          _field(_titleCtrl, 'Ví dụ: Giỗ ông nội'),
          const SizedBox(height: 18),
          _label('GHI CHÚ (TÙY CHỌN)'),
          _field(_noteCtrl, 'Thêm ghi chú...', maxLines: 2),
          const SizedBox(height: 18),
          _label('LẶP LẠI'),
          Row(
            children: [
              _pill(
                'Hằng năm',
                _repeat == RepeatType.yearly,
                () => setState(() => _repeat = RepeatType.yearly),
              ),
              const SizedBox(width: 8),
              _pill(
                'Hằng tháng',
                _repeat == RepeatType.monthly,
                () => setState(() => _repeat = RepeatType.monthly),
              ),
              const SizedBox(width: 8),
              _pill(
                'Một lần',
                _repeat == RepeatType.once,
                () => setState(() => _repeat = RepeatType.once),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _label('CHỌN NGÀY'),
          Row(
            children: [
              _pill('Âm lịch', _isLunar, () {
                setState(() {
                  _isLunar = true;
                  if (_day > _maxDay) _day = _maxDay;
                });
              }),
              const SizedBox(width: 8),
              _pill(
                'Dương lịch',
                !_isLunar,
                () => setState(() => _isLunar = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _dropdown(
                  label: 'Ngày',
                  value: _day,
                  count: _maxDay,
                  onChanged: (v) => setState(() => _day = v),
                ),
              ),
              if (_repeat != RepeatType.monthly) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Tháng',
                    value: _month,
                    count: 12,
                    onChanged: (v) => setState(() => _month = v),
                  ),
                ),
              ],
            ],
          ),
          if (_repeat == RepeatType.monthly)
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 4),
              child: Text(
                'Lặp lại ngày này mỗi tháng',
                style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
              ),
            ),
          const SizedBox(height: 20),
          GlassCard(
            radius: 18,
            padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'THÔNG BÁO',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: AppColors.jadeDark,
                        ),
                      ),
                    ),
                    Switch(
                      value: _notify,
                      activeThumbColor: AppColors.jade,
                      onChanged: (v) => setState(() => _notify = v),
                    ),
                  ],
                ),
                if (_notify) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Nhắc tôi trước:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _pill(
                        'Đúng hôm đó',
                        _before == 0,
                        () => setState(() => _before = 0),
                      ),
                      _pill(
                        '1 ngày',
                        _before == 1,
                        () => setState(() => _before = 1),
                      ),
                      _pill(
                        '3 ngày',
                        _before == 3,
                        () => setState(() => _before = 3),
                      ),
                      _pill(
                        '5 ngày',
                        _before == 5,
                        () => setState(() => _before = 5),
                      ),
                      _pill(
                        _before != 0 &&
                                _before != 1 &&
                                _before != 3 &&
                                _before != 5
                            ? 'Tùy chọn ($_before)'
                            : 'Tùy chọn',
                        _before != 0 &&
                            _before != 1 &&
                            _before != 3 &&
                            _before != 5,
                        _pickCustomBefore,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nhắc mỗi ngày',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            const Text(
                              'Từ ngày xa nhất đến ngày sự kiện',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _remindDaily,
                        activeThumbColor: AppColors.jade,
                        onChanged: _before > 0
                            ? (v) => setState(() => _remindDaily = v)
                            : null,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- widget nhỏ ----------

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 2),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.jadeDark,
      ),
    ),
  );

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) =>
      GlassCard(
        radius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.inkSoft),
            border: InputBorder.none,
          ),
        ),
      );

  Widget _pill(String label, bool selected, VoidCallback onTap) => InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.jade : Colors.white.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? AppColors.jade : AppColors.glassBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.ink,
        ),
      ),
    ),
  );

  Widget _dropdown({
    required String label,
    required int value,
    required int count,
    required ValueChanged<int> onChanged,
  }) => GlassCard(
    radius: 14,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    child: Row(
      children: [
        Text('$label ', style: const TextStyle(color: AppColors.inkSoft)),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value > count ? count : value,
              isExpanded: true,
              iconEnabledColor: AppColors.jade,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.jadeDark,
              ),
              items: [
                for (var i = 1; i <= count; i++)
                  DropdownMenuItem(
                    value: i,
                    child: Text(i.toString().padLeft(2, '0')),
                  ),
              ],
              onChanged: (v) => onChanged(v!),
            ),
          ),
        ),
      ],
    ),
  );
}
