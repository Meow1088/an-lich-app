import 'package:flutter/material.dart';
import '../core/lunar_calendar.dart';
import '../core/van_han_12_thang.dart';
import '../data/profile_store.dart';
import 'ho_so_screen.dart';
import 'patterns/app_scaffold.dart';
import 'theme.dart';
import 'widgets/empty_state.dart';
import 'widgets/person_picker.dart';
import 'widgets/star_rating.dart';

class VanHan12ThangScreen extends StatefulWidget {
  const VanHan12ThangScreen({super.key});

  @override
  State<VanHan12ThangScreen> createState() => _VanHan12ThangScreenState();
}

class _VanHan12ThangScreenState extends State<VanHan12ThangScreen> {
  List<Profile> _people = [];
  String _selectedId = kSelfId;
  bool _loading = true;
  int _viewYear = DateTime.now().year;
  int _expandedMonth = -1;

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
      }
    });
  }

  Future<void> _addProfile() async {
    final changed = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const HoSoScreen()));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dự báo 12 tháng',
      body: _loading
          ? const SizedBox.shrink()
          : (_people.isEmpty ? _needProfile() : _content()),
    );
  }

  Widget _needProfile() => EmptyState(
        title: 'Cần thông tin cá nhân',
        onPressed: _addProfile,
      );

  Widget _content() {
    final p = _selected!;
    final birthLunarYear =
        solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year).year;
    final isNam = p.gender == Gender.nam;

    final res = vanHan12Thang(
      birthDate: p.birthDate,
      birthLunarYear: birthLunarYear,
      isNam: isNam,
      lunarYearTarget: _viewYear,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
      children: [
        if (_people.length > 1) ...[
          PersonPicker(
            people: _people,
            selectedId: _selectedId,
            onSelected: (prof) => setState(() => _selectedId = prof.id),
          ),
          const SizedBox(height: 12),
        ],
        _yearSelector(),
        const SizedBox(height: 12),
        _summaryCard(res),
        const SizedBox(height: 16),
        Text(
          'Dự báo chi tiết 12 tháng âm lịch',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.jadeDark,
          ),
        ),
        const SizedBox(height: 8),
        ...res.thangs.map((t) => _monthCard(t)),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Lưu ý: Nội dung mang tính chất tham khảo & tín ngưỡng dân gian.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.inkSoft,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _yearSelector() {
    final currentY = DateTime.now().year;
    final years = [currentY - 1, currentY, currentY + 1];

    return Row(
      children: [
        Text(
          'Năm xem: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 8),
        Wrap(
          spacing: 8,
          children: years.map((y) {
            final isSel = y == _viewYear;
            return ChoiceChip(
              label: Text(
                'Năm $y',
                style: TextStyle(
                  color: isSel ? Colors.white : AppColors.ink,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSel,
              selectedColor: AppColors.jadeDark,
              backgroundColor: AppColors.gold.withValues(alpha: 0.2),
              onSelected: (_) => setState(() => _viewYear = y),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _summaryCard(VanHan12ThangResult res) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: AppColors.gold, size: 20),
              const SizedBox(width: 6),
              Text(
                'Tổng quan vận trình năm ${res.lunarYear} (${res.canChiYear})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.jadeDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            res.tongQuanNam,
            style: TextStyle(fontSize: 13.5, height: 1.45, color: AppColors.ink),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.good.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tháng Cát',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.good,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        res.thangCat.isEmpty
                            ? 'Không có'
                            : 'Tháng ${res.thangCat.join(', ')}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.good,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.bad.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tháng Cần Chú Ý',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bad,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        res.thangXau.isEmpty
                            ? 'Không có'
                            : 'Tháng ${res.thangXau.join(', ')}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bad,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _monthCard(VanHanThang t) {
    final isExp = _expandedMonth == t.thangAm;

    Color badgeBg;
    Color badgeText;
    if (t.isCat) {
      badgeBg = AppColors.good.withValues(alpha: 0.15);
      badgeText = AppColors.good;
    } else if (t.isXau) {
      badgeBg = AppColors.bad.withValues(alpha: 0.15);
      badgeText = AppColors.bad;
    } else {
      badgeBg = AppColors.gold.withValues(alpha: 0.2);
      badgeText = AppColors.ink;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        child: InkWell(
          onTap: () {
            setState(() {
              _expandedMonth = isExp ? -1 : t.thangAm;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.jadeDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Tháng ${t.thangAm}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${t.canChiThang} (${t.napAmThang.name})',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t.nhatDinh,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: badgeText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Rating 4 phương diện
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ratingItem('Tài lộc', t.taiLocSao),
                  _ratingItem('Công danh', t.congDanhSao),
                  _ratingItem('Sức khỏe', t.sucKhoeSao),
                  _ratingItem('Tình cảm', t.tinhCamSao),
                ],
              ),
              if (isExp) ...[
                const Divider(height: 20),
                Text(
                  'Nhận định chi tiết:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.jadeDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.moTaChiTiet,
                  style: TextStyle(
                      fontSize: 13, height: 1.4, color: AppColors.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lời khuyên:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.jadeDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.loiKhuyen,
                  style: TextStyle(
                      fontSize: 13, height: 1.4, color: AppColors.ink),
                ),
              ],
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  isExp ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.inkSoft,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingItem(String label, int sao) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.5, color: AppColors.inkSoft),
        ),
        const SizedBox(height: 2),
        StarRating(sao, fontSize: 11, letterSpacing: 0),
      ],
    );
  }
}
