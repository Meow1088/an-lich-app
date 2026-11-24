import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/glossary.dart';
import '../core/lunar_calendar.dart';
import '../core/tu_vi_ngay.dart';
import '../data/profile_store.dart';
import 'help_icon.dart';
import 'ho_so_screen.dart';
import 'theme.dart';

/// Thẻ "Tử vi hôm nay" trên màn Hôm nay — cá nhân hóa theo hồ sơ.
class TuViNgayCard extends StatefulWidget {
  const TuViNgayCard({super.key});

  @override
  State<TuViNgayCard> createState() => _TuViNgayCardState();
}

class _TuViNgayCardState extends State<TuViNgayCard> {
  Profile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStore().load();
    if (mounted) {
      setState(() {
        _profile = p;
        _loading = false;
      });
    }
  }

  Future<void> _addProfile() async {
    final ok = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const HoSoScreen()));
    if (ok == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    final p = _profile;

    if (p == null) {
      return GestureDetector(
        onTap: _addProfile,
        child: GlassCard(
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.jade, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                    'Thêm thông tin cá nhân để xem Tử vi hằng ngày của bạn',
                    style: TextStyle(
                        color: AppColors.jadeDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5)),
              ),
              const Icon(Icons.chevron_right, color: AppColors.inkSoft),
            ],
          ),
        ),
      );
    }

    final lunar =
        solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year);
    final conGiap = canChiOfYear(lunar.year);
    final tv = tuViNgay(p.birthDate, lunar.year, DateTime.now());
    final ten = p.name.isEmpty ? 'bạn' : p.name;

    return GlassCard(
      fill: AppColors.glassStrong,
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.gold, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Tử vi hôm nay · tuổi $conGiap',
                    style: const TextStyle(
                        color: AppColors.jadeDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ),
              HelpIcon(title: 'Tử vi hằng ngày', content: explain('tu_vi_ngay')),
            ],
          ),
          const SizedBox(height: 6),
          Text('Chào $ten, ${tv.tongQuan}',
              style: const TextStyle(
                  color: AppColors.ink, fontSize: 13.5, height: 1.5)),
          const SizedBox(height: 10),
          for (final m in tv.mucs) _MucRow(m: m),
        ],
      ),
    );
  }
}

class _MucRow extends StatelessWidget {
  final TuViMuc m;
  const _MucRow({required this.m});

  @override
  Widget build(BuildContext context) {
    final color = m.tot
        ? AppColors.good
        : (m.xau ? AppColors.bad : AppColors.inkSoft);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(m.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 78,
                        child: Text(m.label,
                            style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5))),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Icon(
                              i < m.sao ? Icons.star : Icons.star_border,
                              size: 15,
                              color: color),
                      ],
                    ),
                  ],
                ),
                Text(m.moTa,
                    style: const TextStyle(
                        color: AppColors.inkSoft, fontSize: 12.5, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
