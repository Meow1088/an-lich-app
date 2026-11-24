import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/lunar_calendar.dart';
import '../core/xem_tuoi.dart';
import '../data/profile_store.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';
import 'widgets/info_row.dart';
import 'widgets/person_picker.dart';
import 'widgets/section_header.dart';

/// Xem tuổi làm nhà: chọn năm sinh + năm xem -> Kim Lâu / Hoang Ốc / Tam Tai.
/// Mặc định lấy năm sinh từ hồ sơ cá nhân (vẫn cho đổi để xem người khác).
class XemTuoiScreen extends StatefulWidget {
  const XemTuoiScreen({super.key});

  @override
  State<XemTuoiScreen> createState() => _XemTuoiScreenState();
}

class _XemTuoiScreenState extends State<XemTuoiScreen> {
  late int _birth;
  late int _viewYear;
  List<Profile> _people = [];
  String _selectedId = kSelfId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().year;
    _birth = 1990;
    _viewYear = now;
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final all = await ProfileStore().loadAll();
    if (all.isEmpty || !mounted) return;
    setState(() {
      _people = all;
      _applyPerson(all.first);
    });
  }

  /// Chọn người → prefill năm sinh (âm lịch để khớp can chi/tuổi).
  void _applyPerson(Profile p) {
    _selectedId = p.id;
    _birth =
        solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year).year;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().year;
    final r = xemTuoiLamNha(_birth, _viewYear);
    final chi = yearChiIndex(_birth);
    final conGiap = diaChi[chi];
    final tamHop = tamHopOf(chi).map((c) => diaChi[c]).join(', ');
    final xung = tuHanhXungOf(chi)
        .where((c) => c != chi)
        .map((c) => diaChi[c])
        .join(', ');

    return AppScaffold(
      title: 'Xem tuổi làm nhà',
          body: ListView(
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
                      child: _yearPicker('Năm sinh', _birth, 1930, now,
                          (v) => setState(() => _birth = v)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _yearPicker('Năm xem', _viewYear, now, now + 15,
                          (v) => setState(() => _viewYear = v)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                fill: r.tot ? AppColors.glassGoodFill : AppColors.glassBadFill,
                borderColor:
                    r.tot ? AppColors.glassGoodBorder : AppColors.glassBadBorder,
                child: Row(
                  children: [
                    Icon(r.tot ? Icons.check_circle : Icons.warning_amber_rounded,
                        color: r.tot ? AppColors.good : AppColors.bad, size: 34),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.tot
                                ? 'Tuổi đẹp làm nhà năm $_viewYear'
                                : 'Năm $_viewYear không đẹp để làm nhà',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: r.tot ? AppColors.good : AppColors.bad),
                          ),
                          Text('Tuổi mụ: ${r.tuoiMu} · $conGiap',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.ink)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  children: [
                    _checkRow('Kim Lâu', !r.kimLau.pham,
                        r.kimLau.pham ? 'Phạm Kim Lâu ${r.kimLau.loai}' : 'Không phạm'),
                    const Divider(height: 18, color: AppColors.glassBorder),
                    _checkRow('Hoang Ốc', r.hoangOc.tot, r.hoangOc.cung),
                    const Divider(height: 18, color: AppColors.glassBorder),
                    _checkRow('Tam Tai', !r.tamTai,
                        r.tamTai ? 'Phạm Tam Tai' : 'Không phạm'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader('Tuổi $conGiap'),
                    const SizedBox(height: 8),
                    InfoRow('Tam hợp', tamHop,
                        labelWidth: 110,
                        fontSize: 13.5,
                        gap: 0,
                        valueColor: AppColors.good),
                    const SizedBox(height: 4),
                    InfoRow('Tứ hành xung', xung,
                        labelWidth: 110,
                        fontSize: 13.5,
                        gap: 0,
                        valueColor: AppColors.bad),
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

  Widget _yearPicker(
      String label, int value, int min, int max, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.inkSoft, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        DropdownButton<int>(
          value: value,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          items: [
            for (var y = max; y >= min; y--)
              DropdownMenuItem(value: y, child: Text('$y')),
          ],
          onChanged: (v) => onChanged(v!),
        ),
      ],
    );
  }

  Widget _checkRow(String label, bool ok, String detail) {
    final color = ok ? AppColors.good : AppColors.bad;
    return Row(
      children: [
        Icon(ok ? Icons.check_circle : Icons.cancel, color: color, size: 20),
        const SizedBox(width: 10),
        SizedBox(
            width: 84,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.ink, fontWeight: FontWeight.w700))),
        Expanded(
          child: Text(detail,
              textAlign: TextAlign.right,
              style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

}
