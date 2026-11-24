import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/lunar_calendar.dart';
import '../data/profile_store.dart';
import 'bao_cao_screen.dart';
import 'bat_trach_screen.dart';
import 'biorhythm_screen.dart';
import 'cung_le_screen.dart';
import 'doi_ngay_screen.dart';
import 'hop_tuoi_screen.dart';
import 'kien_thuc_screen.dart';
import 'luan_tuoi_screen.dart';
import 'nguoi_than_screen.dart';
import 'sao_han_screen.dart';
import 'theme.dart';
import 'tinh_tuoi_screen.dart';
import 'tu_vi_screen.dart';
import 'van_han_12_thang_screen.dart';
import 'xem_ngay_tot_screen.dart';
import 'xem_tuoi_screen.dart';
import 'xuat_hanh_screen.dart';

/// Trung tâm tiện ích (lưới) — gom các công cụ phong thủy / trạch nhật.
/// Đầu màn là THẺ HỒ SƠ cá nhân; mọi tính năng xoay quanh người trong hồ sơ.
class TienIchScreen extends StatefulWidget {
  const TienIchScreen({super.key});

  @override
  State<TienIchScreen> createState() => _TienIchScreenState();
}

class _TienIchScreenState extends State<TienIchScreen> {
  final _store = ProfileStore();
  Profile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await _store.load();
    if (mounted) {
      setState(() {
        _profile = p;
        _loading = false;
      });
    }
  }

  Future<void> _editProfile() async {
    // Mở màn quản lý hồ sơ + người thân; luôn tải lại vì có thể đã sửa bất kỳ ai.
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NguoiThanScreen()));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <_Tile>[
      _Tile(
        'Xem ngày tốt',
        Icons.event_available,
        AppColors.good,
        () => const XemNgayTotScreen(),
      ),
      _Tile(
        'Hướng xuất hành',
        Icons.explore,
        AppColors.jade,
        () => const XuatHanhScreen(),
      ),
      _Tile(
        'Xem tuổi làm nhà',
        Icons.home_work_outlined,
        AppColors.gold,
        () => const XemTuoiScreen(),
      ),
      _Tile(
        'Phong thủy bát trạch',
        Icons.explore_outlined,
        AppColors.jadeSoft,
        () => const BatTrachScreen(),
      ),
      _Tile(
        'Cúng lễ',
        Icons.temple_buddhist_outlined,
        AppColors.gold,
        () => const CungLeScreen(),
      ),
      _Tile(
        'Hợp tuổi',
        Icons.favorite_border,
        AppColors.bad,
        () => const HopTuoiScreen(),
      ),
      _Tile(
        'Tử vi đẩu số',
        Icons.stars,
        AppColors.jadeDark,
        () => const TuViScreen(),
      ),
      _Tile(
        'Luận theo tuổi',
        Icons.auto_stories,
        AppColors.jade,
        () => const LuanTuoiScreen(),
      ),
      _Tile(
        'Hồ sơ vận trình',
        Icons.menu_book,
        AppColors.jade,
        () => const BaoCaoScreen(),
      ),
      _Tile(
        'Sao hạn & Thần số',
        Icons.star_border,
        AppColors.jadeSoft,
        () => const SaoHanScreen(),
      ),
      _Tile(
        'Dự báo 12 tháng',
        Icons.calendar_month,
        AppColors.gold,
        () => const VanHan12ThangScreen(),
      ),
      _Tile(
        'Góc kiến thức',
        Icons.lightbulb_outline,
        AppColors.gold,
        () => const KienThucScreen(),
      ),
      _Tile(
        'Đổi ngày Âm–Dương',
        Icons.swap_horiz,
        AppColors.jade,
        () => const DoiNgayScreen(),
      ),
      _Tile(
        'Tính tuổi · ngày',
        Icons.cake_outlined,
        AppColors.jadeSoft,
        () => const TinhTuoiScreen(),
      ),
      _Tile(
        'Nhịp sinh học',
        Icons.monitor_heart_outlined,
        AppColors.bad,
        () => const BiorhythmScreen(),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!_loading) _ProfileHeader(profile: _profile, onTap: _editProfile),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.92,
          children: [for (final t in tiles) _TileCard(t)],
        ),
        const SizedBox(height: 14),
        const Text(
          'Thông tin phong thủy mang tính tham khảo / tín ngưỡng dân gian.',
          style: TextStyle(
            color: AppColors.inkSoft,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Profile? profile;
  final VoidCallback onTap;
  const _ProfileHeader({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = profile;
    if (p == null) {
      return GestureDetector(
        onTap: onTap,
        child: GlassCard(
          child: Row(
            children: [
              const Icon(
                Icons.person_add_alt_1,
                color: AppColors.jade,
                size: 32,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thêm thông tin cá nhân',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.jadeDark,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Để cá nhân hóa xem tuổi, tử vi, phong thủy...',
                      style: TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.inkSoft),
            ],
          ),
        ),
      );
    }

    final lunar = solarToLunar(
      p.birthDate.day,
      p.birthDate.month,
      p.birthDate.year,
    );
    final nowLunar = solarToLunar(
      DateTime.now().day,
      DateTime.now().month,
      DateTime.now().year,
    );
    final tuoi = nowLunar.year - lunar.year + 1;
    final conGiap = diaChi[(lunar.year + 8) % 12];
    final canChi = canChiOfYear(lunar.year);
    final menh = napAmOfYear(lunar.year).name;
    final title = p.name.isEmpty ? 'Hồ sơ của bạn' : p.name;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        fill: AppColors.glassStrong,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.jade.withValues(alpha: 0.16),
              child: Icon(
                p.gender == Gender.nu ? Icons.face_3 : Icons.face_6,
                color: AppColors.jade,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${p.gender.label} · ${p.birthDate.day}/${p.birthDate.month}/${p.birthDate.year} · $tuoi tuổi',
                    style: const TextStyle(color: AppColors.ink, fontSize: 13),
                  ),
                  Text(
                    'Tuổi $conGiap ($canChi) · Mệnh $menh',
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: AppColors.inkSoft, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Tile {
  final String label;
  final IconData icon;
  final Color color;
  final Widget Function() builder;
  const _Tile(this.label, this.icon, this.color, this.builder);
}

class _TileCard extends StatelessWidget {
  final _Tile tile;
  const _TileCard(this.tile);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => tile.builder()));
      },
      child: GlassCard(
        radius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tile.icon, size: 28, color: tile.color),
            const SizedBox(height: 7),
            Text(
              tile.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
                height: 1.15,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
