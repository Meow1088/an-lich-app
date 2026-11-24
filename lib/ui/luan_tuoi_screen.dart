import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/luan_tuoi.dart';
import '../data/profile_store.dart';
import 'ho_so_screen.dart';
import 'patterns/app_scaffold.dart';
import 'theme.dart';
import 'widgets/empty_state.dart';
import 'widgets/person_picker.dart';

/// Luận theo tuổi — chế độ 📖 Dễ hiểu. Xem nhanh theo NĂM sinh (con giáp, bản
/// mệnh, Tứ Hóa năm sinh), KHÔNG cần giờ sinh nên ai cũng xem được.
class LuanTuoiScreen extends StatefulWidget {
  const LuanTuoiScreen({super.key});

  @override
  State<LuanTuoiScreen> createState() => _LuanTuoiScreenState();
}

class _LuanTuoiScreenState extends State<LuanTuoiScreen> {
  List<Profile> _people = [];
  String _selectedId = kSelfId;
  bool _loading = true;

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
      if (all.isNotEmpty) _selectedId = all.first.id;
      _loading = false;
    });
  }

  Profile? get _selected {
    for (final p in _people) {
      if (p.id == _selectedId) return p;
    }
    return _people.isEmpty ? null : _people.first;
  }

  Future<void> _addProfile() async {
    final changed = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const HoSoScreen()));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Luận theo tuổi',
      body: _loading
          ? const SizedBox.shrink()
          : (_people.isEmpty ? _need() : _content(_selected!)),
    );
  }

  Widget _need() => EmptyState(
        title: 'Cần năm sinh của bạn',
        subtitle: 'Chế độ này chỉ cần năm sinh, không cần giờ.',
        onPressed: _addProfile,
      );

  Widget _content(Profile p) {
    final lunarYear =
        solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year).year;
    final r = luanTheoTuoi(lunarYear);
    final doan = luanTuoiVanXuoi(r).split('\n\n');

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
      children: [
        if (_people.length > 1) ...[
          PersonPicker(
            people: _people,
            selectedId: _selectedId,
            onSelected: (p) => setState(() => _selectedId = p.id),
          ),
          const SizedBox(height: 12),
        ],
        const Text('Xem nhanh theo tuổi — không cần giờ sinh.',
            style: TextStyle(color: AppColors.inkSoft, fontSize: 12.5)),
        const SizedBox(height: 10),

        GlassCard(
          fill: AppColors.glassStrong,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tuổi ${r.conVat} · ${r.canChiNam}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark)),
              const SizedBox(height: 10),
              for (var i = 0; i < doan.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                Text(doan[i],
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 14.5, height: 1.55)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(r.disclaimer,
            style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.45)),
      ],
    );
  }
}
