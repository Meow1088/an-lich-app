import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/can_chi.dart';
import '../core/hoang_dao.dart';
import '../core/truc_tu.dart';
import 'theme.dart';
import 'widgets/info_row.dart';
import 'patterns/app_scaffold.dart';

const _weekdays = [
  '', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
];
const _lunarMonthNames = [
  '', 'Giêng', 'Hai', 'Ba', 'Tư', 'Năm', 'Sáu',
  'Bảy', 'Tám', 'Chín', 'Mười', 'Một', 'Chạp'
];

enum _Mode { solarToLunar, lunarToSolar }

/// Công cụ đổi ngày Dương ↔ Âm (offline, tái dùng lõi âm lịch đã verify).
class DoiNgayScreen extends StatefulWidget {
  const DoiNgayScreen({super.key});

  @override
  State<DoiNgayScreen> createState() => _DoiNgayScreenState();
}

class _DoiNgayScreenState extends State<DoiNgayScreen> {
  _Mode _mode = _Mode.solarToLunar;

  // Dương → Âm
  DateTime _solar = DateTime.now();

  // Âm → Dương
  late int _lDay;
  late int _lMonth;
  late int _lYear;
  bool _leap = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final l = solarToLunar(now.day, now.month, now.year);
    _lDay = l.day;
    _lMonth = l.month;
    _lYear = l.year;
  }

  Future<void> _pickSolar() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _solar,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _solar = d);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Đổi ngày Dương – Âm',
      body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<_Mode>(
                segments: const [
                  ButtonSegment(
                      value: _Mode.solarToLunar,
                      icon: Icon(Icons.wb_sunny_outlined, size: 18),
                      label: Text('Dương → Âm')),
                  ButtonSegment(
                      value: _Mode.lunarToSolar,
                      icon: Icon(Icons.nightlight_outlined, size: 18),
                      label: Text('Âm → Dương')),
                ],
                selected: {_mode},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 16),
              if (_mode == _Mode.solarToLunar)
                _solarToLunar()
              else
                _lunarToSolar(),
              const SizedBox(height: 14),
              const Text(
                'Can chi · trực · sao tính theo thuật toán âm lịch Hồ Ngọc Đức (UTC+7).',
                style: TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
    );
  }

  Widget _solarToLunar() {
    final d = _solar;
    final lunar = solarToLunar(d.day, d.month, d.year);
    final truc = trucOfDay(d.day, d.month, d.year);
    final tu = tuOfDay(d.day, d.month, d.year);
    final q = dayQuality(d.day, d.month, d.year);
    final hd = q.isHoangDao;
    return Column(
      children: [
        _PickRow(
          label: 'Ngày dương lịch',
          value: '${_weekdays[d.weekday]}, ${d.day}/${d.month}/${d.year}',
          onTap: _pickSolar,
        ),
        const SizedBox(height: 14),
        GlassCard(
          fill: AppColors.glassStrong,
          radius: 22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${lunar.day}',
                      style: const TextStyle(
                          color: AppColors.jadeDark,
                          fontSize: 64,
                          height: 1,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Tháng ${_lunarMonthNames[lunar.month]}'
                              '${lunar.isLeapMonth ? ' (nhuận)' : ''} âm lịch',
                              style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          Text('Năm ${canChiOfYear(lunar.year)}',
                              style: const TextStyle(
                                  color: AppColors.inkSoft, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 22, color: AppColors.glassBorder),
              InfoRow('Ngày',
                  '${canChiOfDay(d.day, d.month, d.year)} · ${napAmOfDay(d.day, d.month, d.year).name}'),
              InfoRow('Tháng',
                  '${canChiOfMonth(lunar.month, lunar.year)} · ${napAmOfMonth(lunar.month, lunar.year).name}'),
              InfoRow('Năm',
                  '${canChiOfYear(lunar.year)} · ${napAmOfYear(lunar.year).name}'),
              InfoRow('Tiết khí', tietKhiOfDay(d.day, d.month, d.year)),
              InfoRow('Trực', '${truc.name} (${truc.nature})'),
              InfoRow('Sao', '${tu.name} · ${tu.good ? "Tốt" : "Xấu"}'),
              const SizedBox(height: 4),
              _qualityPill(hd, q.label),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lunarToSolar() {
    final solar = lunarToSolar(_lDay, _lMonth, _lYear, isLeapMonth: _leap);
    return Column(
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ngày âm lịch',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.jadeDark)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _numDropdown(
                      'Ngày',
                      _lDay,
                      30,
                      (v) => setState(() => _lDay = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _numDropdown(
                      'Tháng',
                      _lMonth,
                      12,
                      (v) => setState(() => _lMonth = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Năm âm:',
                      style: TextStyle(color: AppColors.inkSoft)),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => setState(() => _lYear--),
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.jade,
                  ),
                  Text('$_lYear (${canChiOfYear(_lYear)})',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.ink)),
                  IconButton(
                    onPressed: () => setState(() => _lYear++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.jade,
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text('Tháng nhuận',
                    style: TextStyle(color: AppColors.ink, fontSize: 14)),
                value: _leap,
                activeThumbColor: AppColors.jade,
                onChanged: (v) => setState(() => _leap = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GlassCard(
          fill: AppColors.glassStrong,
          radius: 22,
          child: solar == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.bad),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            'Ngày âm không hợp lệ (có thể tháng đó không có nhuận, hoặc không có ngày 30).',
                            style: TextStyle(color: AppColors.ink)),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nhằm ngày dương lịch',
                        style: TextStyle(
                            color: AppColors.inkSoft, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                        '${_weekdays[solar.weekday]}, ${solar.day}/${solar.month}/${solar.year}',
                        style: const TextStyle(
                            color: AppColors.jadeDark,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    const Divider(height: 22, color: AppColors.glassBorder),
                    InfoRow('Ngày',
                        '${canChiOfDay(solar.day, solar.month, solar.year)} · ${napAmOfDay(solar.day, solar.month, solar.year).name}'),
                    InfoRow('Tiết khí',
                        tietKhiOfDay(solar.day, solar.month, solar.year)),
                    _qualityPill(
                        dayQuality(solar.day, solar.month, solar.year)
                            .isHoangDao,
                        dayQuality(solar.day, solar.month, solar.year).label),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _qualityPill(bool hd, String label) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: (hd ? AppColors.good : AppColors.bad).withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: (hd ? AppColors.good : AppColors.bad)
                  .withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            Icon(hd ? Icons.wb_sunny : Icons.nightlight_round,
                color: hd ? AppColors.good : AppColors.bad, size: 20),
            const SizedBox(width: 8),
            Text('Ngày $label',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: hd ? AppColors.good : AppColors.bad)),
          ],
        ),
      );

  Widget _numDropdown(
      String label, int value, int max, ValueChanged<int> onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.inkSoft),
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isExpanded: true,
          items: [
            for (var i = 1; i <= max; i++)
              DropdownMenuItem(value: i, child: Text('$i')),
          ],
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}

class _PickRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _PickRow(
      {required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.jade, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: AppColors.inkSoft, fontSize: 12.5)),
                  Text(value,
                      style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Icon(Icons.edit_calendar, color: AppColors.inkSoft),
          ],
        ),
      ),
    );
  }
}
