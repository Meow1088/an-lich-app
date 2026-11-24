import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../core/bao_cao_tu_vi.dart';
import '../core/noi_sinh_data.dart';
import '../core/tu_vi.dart';
import '../data/profile_store.dart';
import '../data/settings_store.dart';
import '../services/bao_cao_pdf.dart';
import 'ho_so_screen.dart';
import 'patterns/app_scaffold.dart';
import 'theme.dart';
import 'widgets/empty_state.dart';
import 'widgets/person_picker.dart';
import 'widgets/section_header.dart';
import 'widgets/star_rating.dart';

/// Màn "Hồ sơ vận trình" — báo cáo tử vi cá nhân dạng đọc + xuất PDF.
class BaoCaoScreen extends StatefulWidget {
  const BaoCaoScreen({super.key});

  @override
  State<BaoCaoScreen> createState() => _BaoCaoScreenState();
}

class _BaoCaoScreenState extends State<BaoCaoScreen> {
  final _store = ProfileStore();
  List<Profile> _people = [];
  String _selectedId = kSelfId;
  bool _loading = true;
  bool _exporting = false;
  bool _tyMuon = false; // cài đặt: giờ Tý muộn tính sang ngày sau

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
    final all = await _store.loadAll();
    final tyMuon = await SettingsStore().getTyMuonSangHomSau();
    if (mounted) {
      setState(() {
        _tyMuon = tyMuon;
        _people = all;
        if (all.isNotEmpty) _selectedId = all.first.id;
        _loading = false;
      });
    }
  }

  Future<void> _addProfile() async {
    final changed = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => HoSoScreen(initial: _selected)));
    if (changed == true) _load();
  }

  String _gioGhiChu(HourConfidence c) => switch (c) {
        HourConfidence.chinhXac => '',
        HourConfidence.uocLuong => ' (ước lượng)',
        HourConfidence.khongBiet => ' (không rõ — luận tổng quát)',
      };

  BaoCaoTuVi _baoCao(Profile p) {
    final la = lapLaSoTuDuong(
        ngayLapLaSo(
            birthDate: p.birthDate,
            gioPhut: p.gioPhut,
            noiSinh: p.noiSinh,
            tyMuonSangHomSau: _tyMuon),
        p.hourChi ?? 0,
        p.gender);
    return baoCaoTongQuan(la,
        name: p.name,
        birthDate: p.birthDate,
        genderLabel: p.gender.label,
        hourChi: p.hourChi,
        gioGhiChu: _gioGhiChu(p.hourConf));
  }

  /// Tên file PDF theo tên người (bỏ dấu, thay khoảng trắng) để mỗi người 1 file.
  String _pdfFilename() {
    final name = (_selected?.name ?? '').trim();
    if (name.isEmpty) return 'ho_so_van_trinh.pdf';
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
    return slug.isEmpty
        ? 'ho_so_van_trinh.pdf'
        : 'ho_so_van_trinh_$slug.pdf';
  }

  Future<void> _xuatPdf(BaoCaoTuVi bc) async {
    setState(() => _exporting = true);
    try {
      final bytes = await BaoCaoPdf.build(bc);
      await Printing.sharePdf(bytes: bytes, filename: _pdfFilename());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Không xuất được PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _selected;
    return AppScaffold(
      title: 'Hồ sơ vận trình',
      actions: [
        if (p != null)
          _exporting
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : IconButton(
                  tooltip: 'Xuất PDF',
                  onPressed: () => _xuatPdf(_baoCao(p)),
                  icon: const Icon(Icons.picture_as_pdf, color: AppColors.jade),
                ),
      ],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : p == null
              ? _noProfile()
              : _content(_baoCao(p)),
    );
  }

  Widget _noProfile() => EmptyState(
        icon: Icons.menu_book,
        iconSize: 44,
        title: 'Cần thông tin cá nhân để lập báo cáo',
        buttonIcon: Icons.person_add_alt_1,
        onPressed: _addProfile,
      );

  Widget _content(BaoCaoTuVi bc) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_people.length > 1) ...[
          PersonPicker(
            people: _people,
            selectedId: _selectedId,
            onSelected: (p) => setState(() => _selectedId = p.id),
          ),
          const SizedBox(height: 10),
        ],
        _hoSoCard(bc),
        const SizedBox(height: 10),
        _disclaimerCard(bc.disclaimer),
        const SizedBox(height: 10),
        _mucCard(bc.tomTat),
        for (final m in bc.mucs) _mucCard(m),
        if (bc.timeline.isNotEmpty) _timelineCard(bc.timeline),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _exporting ? null : () => _xuatPdf(bc),
          icon: const Icon(Icons.picture_as_pdf),
          label: Text(_exporting ? 'Đang tạo PDF…' : 'Xuất báo cáo PDF'),
          style: FilledButton.styleFrom(
              backgroundColor: AppColors.jade,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _hoSoCard(BaoCaoTuVi bc) => GlassCard(
        fill: AppColors.glassStrong,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bc.tieuDe,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.jadeDark,
                    fontSize: 18)),
            const SizedBox(height: 8),
            for (final e in bc.hoSo.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 13, height: 1.35),
                    children: [
                      TextSpan(
                          text: '${e.key}: ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.jadeDark)),
                      TextSpan(text: e.value),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _disclaimerCard(String text) => Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
        ),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.4)),
      );

  Widget _mucCard(BaoCaoMuc m) => GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              m.tieuDe,
              icon: m.icon,
              trailing: m.sao != null ? StarRating(m.sao!) : null,
            ),
            const SizedBox(height: 6),
            for (final d in m.doan)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(d,
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 13.5, height: 1.5)),
              ),
            for (final d in m.diem) _bar(d),
            if (m.nen.isNotEmpty) _box('Bạn nên', m.nen, AppColors.good),
            if (m.tranh.isNotEmpty)
              _box('Điểm cần lưu ý', m.tranh, AppColors.bad),
          ],
        ),
      );

  Widget _bar(MucDiem d) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            SizedBox(
                width: 120,
                child: Text(d.ten,
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 12.5))),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: d.sao / 5,
                  minHeight: 9,
                  backgroundColor: AppColors.glassBorder,
                  color: d.sao >= 4
                      ? AppColors.good
                      : (d.sao <= 2 ? AppColors.bad : AppColors.gold),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${d.sao}/5',
                style: const TextStyle(
                    color: AppColors.inkSoft, fontSize: 11.5)),
          ],
        ),
      );

  Widget _box(String tieuDe, List<String> items, Color mau) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
        decoration: BoxDecoration(
          color: mau.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: mau, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tieuDe,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13, color: mau)),
            const SizedBox(height: 3),
            for (final it in items)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('•  $it',
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 13, height: 1.45)),
              ),
          ],
        ),
      );

  Widget _timelineCard(List<MocVanHan> ts) => GlassCard(
        fill: AppColors.glassStrong,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader('Đại vận theo thập niên', icon: '📅'),
            const SizedBox(height: 8),
            for (final t in ts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 92,
                        child: Text(t.tuoi,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.jade,
                                fontSize: 12.5))),
                    StarRating(t.sao, fontSize: 12, letterSpacing: 0),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('${t.trongTam} — ${t.nhanXet}',
                          style: const TextStyle(
                              color: AppColors.inkSoft, fontSize: 12)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}
