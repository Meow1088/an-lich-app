import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/hop_tuoi.dart';
import '../core/lunar_calendar.dart';
import '../core/xem_tuoi.dart';
import '../data/profile_store.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';
import 'widgets/info_row.dart';
import 'widgets/person_picker.dart';
import 'widgets/section_header.dart';

/// Hợp tuổi vợ chồng + gợi ý tuổi xông đất. Năm A mặc định từ hồ sơ.
class HopTuoiScreen extends StatefulWidget {
  const HopTuoiScreen({super.key});

  @override
  State<HopTuoiScreen> createState() => _HopTuoiScreenState();
}

class _HopTuoiScreenState extends State<HopTuoiScreen> {
  int _yearA = 1990;
  int _yearB = 1990;
  List<Profile> _people = [];
  String _selectedId = kSelfId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await ProfileStore().loadAll();
    if (all.isEmpty || !mounted) return;
    final ly = solarToLunar(all.first.birthDate.day, all.first.birthDate.month,
            all.first.birthDate.year)
        .year;
    setState(() {
      _people = all;
      _selectedId = all.first.id;
      _yearA = ly;
      _yearB = ly;
    });
  }

  /// Chọn người → đặt làm "Tuổi 1" (gia chủ).
  void _applyPersonA(Profile p) {
    _selectedId = p.id;
    _yearA =
        solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year).year;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().year;
    final r = hopTuoiVoChong(_yearA, _yearB);
    final color = r.diem >= 1
        ? AppColors.good
        : (r.diem < 0 ? AppColors.bad : AppColors.inkSoft);
    final chiA = diaChi[yearChiIndex(_yearA)];
    final xong = chiXongDat(yearChiIndex(_yearA)).map((c) => diaChi[c]).join(', ');

    return AppScaffold(
      title: 'Hợp tuổi',
          body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            children: [
              if (_people.length > 1) ...[
                PersonPicker(
                  people: _people,
                  selectedId: _selectedId,
                  onSelected: (p) => setState(() => _applyPersonA(p)),
                ),
                const SizedBox(height: 12),
              ],
              GlassCard(
                child: Row(
                  children: [
                    Expanded(
                        child: _yp('Tuổi 1 (bạn)', _yearA, now,
                            (v) => setState(() => _yearA = v))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _yp('Tuổi 2 (bạn đời)', _yearB, now,
                            (v) => setState(() => _yearB = v))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                fill: r.diem >= 1
                    ? AppColors.glassGoodFill
                    : (r.diem < 0
                        ? AppColors.glassBadFill
                        : AppColors.glassStrong),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kết quả: ${r.ket}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: color)),
                    const SizedBox(height: 8),
                    InfoRow('Địa chi', r.chiQuanHe,
                        labelWidth: 120,
                        fontSize: 13.5,
                        gap: 0,
                        valueColor: _diemColor(r.chiDiem)),
                    const SizedBox(height: 4),
                    InfoRow('Ngũ hành mệnh', r.menhQuanHe,
                        labelWidth: 120,
                        fontSize: 13.5,
                        gap: 0,
                        valueColor: _diemColor(r.menhDiem)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader('Tuổi xông đất hợp với tuổi $chiA'),
                    const SizedBox(height: 6),
                    Text('Nên chọn người tuổi: $xong',
                        style: const TextStyle(
                            color: AppColors.good,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('(tam hợp + lục hợp với gia chủ)',
                        style:
                            TextStyle(color: AppColors.inkSoft, fontSize: 12)),
                  ],
                ),
              ),
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
          ),
    );
  }

  Color _diemColor(int pt) =>
      pt > 0 ? AppColors.good : (pt < 0 ? AppColors.bad : AppColors.inkSoft);

  Widget _yp(String label, int value, int max, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.inkSoft, fontWeight: FontWeight.w600)),
        DropdownButton<int>(
          value: value,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          items: [
            for (var y = max; y >= 1930; y--)
              DropdownMenuItem(value: y, child: Text('$y')),
          ],
          onChanged: (v) => onChanged(v!),
        ),
      ],
    );
  }
}
