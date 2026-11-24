import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/can_chi.dart';
import '../data/profile_store.dart';
import 'theme.dart';
import 'widgets/info_row.dart';
import 'widgets/person_picker.dart';
import 'patterns/app_scaffold.dart';

const _weekdays = [
  '', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
];

enum _Mode { tuoi, khoang }

/// Tính tuổi (tây/mụ) + khoảng cách giữa 2 ngày. Offline thuần.
class TinhTuoiScreen extends StatefulWidget {
  const TinhTuoiScreen({super.key});

  @override
  State<TinhTuoiScreen> createState() => _TinhTuoiScreenState();
}

class _TinhTuoiScreenState extends State<TinhTuoiScreen> {
  _Mode _mode = _Mode.tuoi;
  DateTime _birth = DateTime(1990, 1, 1);
  DateTime _from = DateTime.now();
  DateTime _to = DateTime.now().add(const Duration(days: 100));
  List<Profile> _people = [];
  String _selectedId = kSelfId;

  @override
  void initState() {
    super.initState();
    ProfileStore().loadAll().then((all) {
      if (all.isNotEmpty && mounted) {
        setState(() {
          _people = all;
          _selectedId = all.first.id;
          _birth = all.first.birthDate;
        });
      }
    });
  }

  Future<DateTime?> _pick(DateTime init) => showDatePicker(
        context: context,
        initialDate: init,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tính tuổi · Khoảng ngày',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<_Mode>(
                segments: const [
                  ButtonSegment(
                      value: _Mode.tuoi,
                      icon: Icon(Icons.cake_outlined, size: 18),
                      label: Text('Tính tuổi')),
                  ButtonSegment(
                      value: _Mode.khoang,
                      icon: Icon(Icons.timelapse, size: 18),
                      label: Text('Khoảng ngày')),
                ],
                selected: {_mode},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 16),
              if (_mode == _Mode.tuoi) _tuoi() else _khoang(),
            ],
          ),
    );
  }

  // ---------------- Tính tuổi ----------------
  Widget _tuoi() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final (y, m, d) = _breakdown(_birth, today);
    final lunarB = solarToLunar(_birth.day, _birth.month, _birth.year);
    final lunarNow = solarToLunar(today.day, today.month, today.year);
    final tuoiMu = lunarNow.year - lunarB.year + 1;
    final conGiap = diaChi[(lunarB.year + 8) % 12];
    final menh = napAmOfYear(lunarB.year).name;

    var bd = DateTime(today.year, _birth.month, _birth.day);
    if (bd.isBefore(today)) bd = DateTime(today.year + 1, _birth.month, _birth.day);
    final daysToBd = bd.difference(today).inDays;

    return Column(
      children: [
        if (_people.length > 1) ...[
          PersonPicker(
            people: _people,
            selectedId: _selectedId,
            onSelected: (p) => setState(() {
              _selectedId = p.id;
              _birth = p.birthDate;
            }),
          ),
          const SizedBox(height: 12),
        ],
        _PickCard(
          label: 'Ngày sinh (dương lịch)',
          value: '${_weekdays[_birth.weekday]}, ${_birth.day}/${_birth.month}/${_birth.year}',
          onTap: () async {
            final r = await _pick(_birth);
            if (r != null) setState(() => _birth = r);
          },
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
                  Text('$y',
                      style: const TextStyle(
                          color: AppColors.jadeDark,
                          fontSize: 64,
                          height: 1,
                          fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 10),
                    child: Text('tuổi',
                        style: TextStyle(
                            color: AppColors.inkSoft, fontSize: 18)),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('$m tháng $d ngày',
                        style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const Divider(height: 22, color: AppColors.glassBorder),
              InfoRow('Tuổi mụ (âm lịch)', '$tuoiMu tuổi'),
              InfoRow('Con giáp', '$conGiap (${canChiOfYear(lunarB.year)})'),
              InfoRow('Mệnh', menh),
              InfoRow('Sinh nhật tới',
                  daysToBd == 0 ? 'Hôm nay 🎂' : 'còn $daysToBd ngày'),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Khoảng ngày ----------------
  Widget _khoang() {
    final a = DateTime(_from.year, _from.month, _from.day);
    final b = DateTime(_to.year, _to.month, _to.day);
    final days = b.difference(a).inDays;
    final absDays = days.abs();
    final lo = days >= 0 ? a : b;
    final hi = days >= 0 ? b : a;
    final (y, m, d) = _breakdown(lo, hi);

    return Column(
      children: [
        _PickCard(
          label: 'Từ ngày',
          value: '${_weekdays[_from.weekday]}, ${_from.day}/${_from.month}/${_from.year}',
          onTap: () async {
            final r = await _pick(_from);
            if (r != null) setState(() => _from = r);
          },
        ),
        const SizedBox(height: 10),
        _PickCard(
          label: 'Đến ngày',
          value: '${_weekdays[_to.weekday]}, ${_to.day}/${_to.month}/${_to.year}',
          onTap: () async {
            final r = await _pick(_to);
            if (r != null) setState(() => _to = r);
          },
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
                  Text('$absDays',
                      style: const TextStyle(
                          color: AppColors.jadeDark,
                          fontSize: 64,
                          height: 1,
                          fontWeight: FontWeight.bold)),
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 10),
                    child: Text('ngày',
                        style: TextStyle(
                            color: AppColors.inkSoft, fontSize: 18)),
                  ),
                ],
              ),
              const Divider(height: 22, color: AppColors.glassBorder),
              InfoRow('Tương đương', '$y năm $m tháng $d ngày'),
              InfoRow('Số tuần',
                  '${(absDays / 7).floor()} tuần ${absDays % 7} ngày'),
              InfoRow('Hướng', days >= 0 ? 'Đến sau Từ' : 'Đến trước Từ'),
            ],
          ),
        ),
      ],
    );
  }

  /// Khoảng cách Y/M/D giữa 2 mốc (from <= to).
  static (int, int, int) _breakdown(DateTime from, DateTime to) {
    int y = to.year - from.year;
    int m = to.month - from.month;
    int d = to.day - from.day;
    if (d < 0) {
      m--;
      d += DateTime(to.year, to.month, 0).day; // số ngày tháng trước [to]
    }
    if (m < 0) {
      y--;
      m += 12;
    }
    return (y, m, d);
  }
}

class _PickCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _PickCard(
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
