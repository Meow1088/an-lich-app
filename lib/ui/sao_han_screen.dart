import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/sao_han.dart';
import '../core/than_so.dart';
import '../data/profile_store.dart';
import 'ho_so_screen.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';
import 'widgets/empty_state.dart';
import 'widgets/person_picker.dart';

/// Sao hạn (cửu diệu) + Thần số học — đều lấy từ hồ sơ cá nhân.
class SaoHanScreen extends StatefulWidget {
  const SaoHanScreen({super.key});

  @override
  State<SaoHanScreen> createState() => _SaoHanScreenState();
}

class _SaoHanScreenState extends State<SaoHanScreen> {
  List<Profile> _people = [];
  String _selectedId = kSelfId;
  bool _loading = true;
  int _birthYear = 1990;
  int _viewYear = DateTime.now().year;
  bool _isNam = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Profile? get _selected {
    for (final p in _people) {
      if (p.id == _selectedId) return p;
    }
    return _people.isEmpty ? null : _people.first;
  }

  Future<void> _load() async {
    final all = await ProfileStore().loadAll();
    if (!mounted) return;
    setState(() {
      _people = all;
      _loading = false;
      if (all.isNotEmpty) {
        _selectedId = all.first.id;
        _applyPerson(all.first);
      }
    });
  }

  void _applyPerson(Profile p) {
    _selectedId = p.id;
    _birthYear =
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
      title: 'Sao hạn & Thần số',
      body: _loading
          ? const SizedBox.shrink()
          : (_people.isEmpty ? _need() : _content()),
    );
  }

  Widget _need() => EmptyState(
        title: 'Cần thông tin cá nhân',
        onPressed: _addProfile,
      );

  Widget _content() {
    final now = DateTime.now().year;
    final tuoi = _viewYear - _birthYear + 1;
    final sao = saoHanOf(tuoi, _isNam);
    final saoColor = sao.tot
        ? AppColors.good
        : (sao.xau ? AppColors.bad : AppColors.inkSoft);
    final p = _selected!;
    final so = soChuDao(p.birthDate.day, p.birthDate.month, p.birthDate.year);
    final ts = thanSoOf(so);

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
                    const Text('Xem sao hạn năm',
                        style: TextStyle(
                            color: AppColors.inkSoft,
                            fontWeight: FontWeight.w600)),
                    DropdownButton<int>(
                      value: _viewYear,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (var y = now - 1; y <= now + 10; y++)
                          DropdownMenuItem(value: y, child: Text('$y')),
                      ],
                      onChanged: (v) => setState(() => _viewYear = v!),
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
          fill: sao.tot
              ? AppColors.glassGoodFill
              : (sao.xau ? AppColors.glassBadFill : AppColors.glassStrong),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sao chiếu mệnh năm $_viewYear (tuổi $tuoi)',
                  style: const TextStyle(
                      color: AppColors.inkSoft, fontSize: 13)),
              const SizedBox(height: 2),
              Text('${sao.name} · ${sao.loaiLabel}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: saoColor)),
              const SizedBox(height: 8),
              Text(sao.tongQuan,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
              const SizedBox(height: 10),
              _lbl('Ảnh hưởng năm nay'),
              Text(sao.anhHuong,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
              const SizedBox(height: 10),
              _lbl('Lưu ý & hóa giải'),
              Text(sao.luuY,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Thần số học',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.jadeDark)),
        const SizedBox(height: 8),
        GlassCard(
          fill: AppColors.glassStrong,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.jade,
                child: Text('$so',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Số chủ đạo',
                        style: TextStyle(
                            color: AppColors.inkSoft, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(ts.tieuDe,
                        style: const TextStyle(
                            color: AppColors.jadeDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(ts.tongQuan,
                        style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 14,
                            height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _lbl('Điểm mạnh'),
              Text(ts.diemManh,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
              const SizedBox(height: 10),
              _lbl('Điểm yếu'),
              Text(ts.diemYeu,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
              const SizedBox(height: 10),
              _lbl('Sự nghiệp phù hợp'),
              Text(ts.suNghiep,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
              const SizedBox(height: 10),
              _lbl('Lời khuyên'),
              Text(ts.loiKhuyen,
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 14, height: 1.5)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Thông tin mang tính tham khảo / giải trí.',
            style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }
}

Widget _lbl(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(t,
          style: const TextStyle(
              color: AppColors.jade,
              fontWeight: FontWeight.w700,
              fontSize: 13)),
    );
