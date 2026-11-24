import 'package:flutter/material.dart';
import '../core/bat_trach.dart';
import '../core/lunar_calendar.dart';
import '../data/profile_store.dart';
import 'ho_so_screen.dart';
import 'la_ban_screen.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';
import 'widgets/empty_state.dart';
import 'widgets/person_picker.dart';

/// Phong thủy bát trạch: cung mệnh + hướng tốt/xấu + màu hợp.
/// Mặc định theo hồ sơ (năm sinh + giới tính), vẫn cho đổi.
class BatTrachScreen extends StatefulWidget {
  const BatTrachScreen({super.key});

  @override
  State<BatTrachScreen> createState() => _BatTrachScreenState();
}

class _BatTrachScreenState extends State<BatTrachScreen> {
  List<Profile> _people = [];
  String _selectedId = kSelfId;
  bool _loading = true;
  int _year = 1990;
  bool _isNam = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await ProfileStore().loadAll();
    if (!mounted) return;
    setState(() {
      _people = all;
      _loading = false;
      if (all.isNotEmpty) _applyPerson(all.first);
    });
  }

  void _applyPerson(Profile p) {
    _selectedId = p.id;
    _year =
        solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year).year;
    _isNam = p.gender == Gender.nam;
  }

  Future<void> _addProfile() async {
    final changed = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const HoSoScreen()));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Phong thủy bát trạch',
      body: _loading
          ? const SizedBox.shrink()
          : (_people.isEmpty ? _needProfile() : _content()),
    );
  }

  Widget _needProfile() => EmptyState(
        title: 'Cần thông tin cá nhân',
        subtitle: 'Bát trạch cần năm sinh + giới tính.',
        onPressed: _addProfile,
      );

  Widget _content() {
    final now = DateTime.now().year;
    final b = batTrachOf(_year, _isNam);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
      children: [
        if (_people.length > 1) ...[
          PersonPicker(
            people: _people,
            selectedId: _selectedId,
            onSelected: (p) => setState(() => _applyPerson(p)),
          ),
          const SizedBox(height: 12),
        ],
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Năm sinh',
                        style: TextStyle(
                            color: AppColors.inkSoft,
                            fontWeight: FontWeight.w600)),
                    DropdownButton<int>(
                      value: _year,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (var y = now; y >= 1930; y--)
                          DropdownMenuItem(value: y, child: Text('$y')),
                      ],
                      onChanged: (v) => setState(() => _year = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Nam')),
                  ButtonSegment(value: false, label: Text('Nữ')),
                ],
                selected: {_isNam},
                onSelectionChanged: (s) => setState(() => _isNam = s.first),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          fill: AppColors.glassStrong,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cung ${b.queName} · Mệnh ${b.menh}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark)),
              Text(b.trach,
                  style: const TextStyle(
                      color: AppColors.jade, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Màu hợp: ${mauHopMenh[b.menh] ?? ''}',
                  style: const TextStyle(color: AppColors.ink, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.jade, foregroundColor: Colors.white),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => LaBanScreen(batTrach: b))),
            icon: const Icon(Icons.explore),
            label: const Text('Mở la bàn động'),
          ),
        ),
        const SizedBox(height: 12),
        _huongCard('Hướng TỐT', b.tot, AppColors.good),
        const SizedBox(height: 12),
        _huongCard('Hướng XẤU', b.xau, AppColors.bad),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Thông tin mang tính tham khảo / tín ngưỡng dân gian.',
            style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  Widget _huongCard(String title, List<HuongInfo> list, Color color) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: color, fontSize: 15)),
          const SizedBox(height: 8),
          for (final h in list)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 78,
                      child: Text(h.huong,
                          style: const TextStyle(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.duTinh.name,
                            style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.5)),
                        Text(h.duTinh.y,
                            style: const TextStyle(
                                color: AppColors.inkSoft, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
