import 'package:flutter/material.dart';

import '../core/noi_sinh_data.dart';
import '../core/tu_vi.dart';
import '../core/tu_vi_dien_giai.dart';
import '../core/tu_vi_tong_hop.dart';
import '../data/profile_store.dart';
import '../data/settings_store.dart';
import 'ho_so_screen.dart';
import 'theme.dart';
import 'widgets/empty_state.dart';
import 'widgets/person_picker.dart';

/// Màn Tử Vi Đẩu Số: lập lá số 12 cung từ hồ sơ (ngày sinh + giờ + giới tính),
/// vẽ địa bàn 4×4 và diễn giải từng cung. Nội dung mang tính tham khảo.
class TuViScreen extends StatefulWidget {
  const TuViScreen({super.key});

  @override
  State<TuViScreen> createState() => _TuViScreenState();
}

class _TuViScreenState extends State<TuViScreen> {
  final _store = ProfileStore();
  List<Profile> _people = [];
  String _selectedId = kSelfId;
  bool _loading = true;
  int _gioChi = 0; // 0..11
  bool _tyMuon = false; // cài đặt: giờ Tý muộn tính sang ngày sau
  CheDoXem _cheDo = CheDoXem.coBan; // mặc định: ngôn ngữ đời thường

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
        if (all.isNotEmpty) _applyPerson(all.first);
        _loading = false;
      });
    }
  }

  /// Chọn người → lập lại lá số, đặt giờ mặc định theo giờ sinh của người đó.
  void _applyPerson(Profile p) {
    _selectedId = p.id;
    _gioChi = p.hourChi ?? 0;
  }

  Future<void> _addProfile() async {
    final changed = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => HoSoScreen(initial: _selected)));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _JadeBg()),
        Scaffold(
          appBar: AppBar(title: const Text('Tử vi đẩu số')),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : _people.isEmpty
                  ? _noProfile()
                  : _content(_selected!),
        ),
      ],
    );
  }

  Widget _noProfile() => EmptyState(
        icon: Icons.auto_awesome,
        iconSize: 44,
        title: 'Cần thông tin cá nhân để lập lá số',
        subtitle: 'Ngày sinh dương lịch + giờ sinh + giới tính.',
        buttonIcon: Icons.person_add_alt_1,
        onPressed: _addProfile,
      );

  Widget _content(Profile p) {
    final la = lapLaSoTuDuong(
        ngayLapLaSo(
            birthDate: p.birthDate,
            gioPhut: p.gioPhut,
            noiSinh: p.noiSinh,
            tyMuonSangHomSau: _tyMuon),
        _gioChi,
        p.gender);
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_people.length > 1) ...[
          PersonPicker(
            people: _people,
            selectedId: _selectedId,
            onSelected: (p) => setState(() => _applyPerson(p)),
          ),
          const SizedBox(height: 12),
        ],
        _header(p, la),
        const SizedBox(height: 12),
        if (p.hourConf != HourConfidence.chinhXac) ...[
          _confBanner(p),
          const SizedBox(height: 12),
        ],
        _gioPicker(p),
        const SizedBox(height: 12),
        _cheDoToggle(),
        const SizedBox(height: 12),
        _board(la),
        const SizedBox(height: 14),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Luận giải cung Mệnh',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark,
                      fontSize: 15)),
              const SizedBox(height: 2),
              Text(
                  '${saoChuoi(diemCung(la.cungMenh))}  '
                  '(${diemCung(la.cungMenh)}/5)',
                  style: const TextStyle(
                      color: AppColors.gold, fontSize: 14, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text(dienGiaiMenh(la, mode: _cheDo),
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 13.5, height: 1.45)),
              if (boSaoCung(la.cungMenh) != null) ...[
                const SizedBox(height: 8),
                _tag('Bộ sao', boSaoCung(la.cungMenh)!),
              ],
              if (cachCucMenh(la).isNotEmpty) ...[
                const SizedBox(height: 8),
                _tag('Cách cục', cachCucMenh(la)),
              ],
              _viSaoTile(la.cungMenh),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _vanHanCard(la),
        const SizedBox(height: 12),
        _chuDeCard(la),
        const SizedBox(height: 12),
        _tongKetCard(la),
        const SizedBox(height: 12),
        const Text(
          'Chạm vào một cung để xem chi tiết. Tử vi đẩu số mang tính tham khảo / '
          'tín ngưỡng, không phải khẳng định khoa học.',
          style: TextStyle(
              color: AppColors.inkSoft, fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _header(Profile p, LaSoTuVi la) {
    final name = p.name.isEmpty ? 'Hồ sơ của bạn' : p.name;
    return GlassCard(
      fill: AppColors.glassStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.jadeDark,
                  fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            '${p.gender.label} · DL ${p.birthDate.day}/${p.birthDate.month}/${p.birthDate.year} · '
            'ÂL ${la.lunar.day}/${la.lunar.month}/${la.lunar.year}',
            style: const TextStyle(color: AppColors.ink, fontSize: 13),
          ),
          Text(
            'Năm ${la.canChiNam} · ${la.cucTen} · ${la.amDuongMenh}',
            style: const TextStyle(color: AppColors.ink, fontSize: 13),
          ),
          Text('Mệnh chủ: ${la.menhChu}  ·  Thân chủ: ${la.thanChu}',
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 12.5)),
        ],
      ),
    );
  }

  Widget _confBanner(Profile p) {
    final khong = p.hourConf == HourConfidence.khongBiet;
    final msg = khong
        ? 'Bạn chưa cho biết giờ sinh nên lá số đang lấy giờ mặc định (Tý) — '
            'độ chính xác chỉ khoảng 60–70%. Bổ sung giờ sinh để luận đúng 12 cung.'
        : 'Giờ sinh là ước lượng — một số cung và vận hạn có thể lệch. '
            'Nếu nhớ chính xác hơn, hãy cập nhật ở hồ sơ.';
    return GlassCard(
      fill: AppColors.glassStrong,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(msg,
                style: const TextStyle(
                    color: AppColors.ink, fontSize: 12.5, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _gioPicker(Profile p) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 20, color: AppColors.jade),
          const SizedBox(width: 10),
          const Text('Giờ sinh',
              style: TextStyle(
                  color: AppColors.jadeDark, fontWeight: FontWeight.w700)),
          const Spacer(),
          DropdownButton<int>(
            value: _gioChi,
            underline: const SizedBox.shrink(),
            items: [
              for (var i = 0; i < 12; i++)
                DropdownMenuItem(value: i, child: Text(gioLabels[i])),
            ],
            onChanged: (v) => setState(() => _gioChi = v ?? 0),
          ),
        ],
      ),
    );
  }

  Widget _cheDoToggle() {
    return Align(
      alignment: Alignment.centerRight,
      child: SegmentedButton<CheDoXem>(
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          textStyle: WidgetStatePropertyAll(
              const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
        ),
        segments: const [
          ButtonSegment(value: CheDoXem.coBan, label: Text('Cơ bản')),
          ButtonSegment(value: CheDoXem.chuyenSau, label: Text('Chuyên sâu')),
        ],
        selected: {_cheDo},
        onSelectionChanged: (s) => setState(() => _cheDo = s.first),
      ),
    );
  }

  Widget _tag(String label, String value) => RichText(
        text: TextSpan(
          style: const TextStyle(
              color: AppColors.ink, fontSize: 13.5, height: 1.4),
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.jadeDark)),
            TextSpan(text: value),
          ],
        ),
      );

  /// Bảng minh bạch "Vì sao có nhận định này?" — liệt kê các sao làm căn cứ,
  /// để người mới đọc kết luận còn người am hiểu vẫn kiểm chứng được.
  Widget _viSaoTile(CungTuVi cung) {
    final l = luanCung(cung);
    final lines = <String>[
      if (l.chinhTinh.isNotEmpty)
        'Sao chính: ${l.chinhTinh.map((s) => s.dacTinh != null ? '${s.ten} (${trangThaiCoBan(s.dacTinh!)})' : s.ten).join(', ')}'
      else
        'Cung không có sao chính — xét thêm cung đối diện.',
      if (l.tuHoa.isNotEmpty)
        'Ảnh hưởng nổi bật: ${l.tuHoa.map((t) => t.split('—').first.trim()).join('; ')}',
      if (l.saoTot.isNotEmpty)
        'Sao hỗ trợ: ${l.saoTot.map((s) => s.ten).join(', ')}',
      if (l.saoXau.isNotEmpty)
        'Sao cần lưu ý: ${l.saoXau.map((s) => s.ten).join(', ')}',
    ];
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 6),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: const Text('Vì sao có nhận định này?',
            style: TextStyle(
                color: AppColors.jade,
                fontWeight: FontWeight.w700,
                fontSize: 13.5)),
        children: [
          for (final t in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $t',
                  style: const TextStyle(
                      color: AppColors.inkSoft, fontSize: 12.5, height: 1.4)),
            ),
        ],
      ),
    );
  }

  Widget _vanHanCard(LaSoTuVi la) {
    final v = vanHanNam(la);
    return GlassCard(
      fill: AppColors.glassStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vận hạn năm ${v.namCanChi}',
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.jadeDark,
                  fontSize: 15)),
          const SizedBox(height: 4),
          Text('Tuổi mụ ${v.tuoiMu} · Đại vận ${v.daiHanCung} '
              '(${v.daiHanTu}–${v.daiHanTu + 9} tuổi)',
              style: const TextStyle(color: AppColors.inkSoft, fontSize: 12.5)),
          const SizedBox(height: 8),
          Text(v.nhanXet,
              style: const TextStyle(
                  color: AppColors.ink, fontSize: 13.5, height: 1.45)),
        ],
      ),
    );
  }

  String _xungChieu(LaSoTuVi la, CungTuVi cung) {
    final ten = doiCungCua(cung.tenCung);
    final doi = la.cung.firstWhere((c) => c.tenCung == ten, orElse: () => cung);
    final ct = doi.chinhTinh.map((s) => s.ten).join(', ');
    if (ct.isEmpty) {
      return 'mượn ảnh hưởng cung $ten (đối diện); cung đối cũng vô chính diệu '
          'nên cần xét thêm sao phụ.';
    }
    return 'cung vô chính diệu — mượn chính tinh cung $ten (đối diện): $ct.';
  }

  Widget _chuDeCard(LaSoTuVi la) {
    final items = chamChuDe(la);
    return GlassCard(
      fill: AppColors.glassStrong,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chấm theo chủ đề',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.jadeDark,
                  fontSize: 15)),
          const SizedBox(height: 10),
          for (final c in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(c.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      SizedBox(
                          width: 84,
                          child: Text(c.ten,
                              style: const TextStyle(
                                  color: AppColors.ink,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5))),
                      Text(saoChuoi(c.sao),
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 15,
                              letterSpacing: 1)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 1),
                    child: Text(c.nhanXet,
                        style: const TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 12.5,
                            height: 1.35)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tongKetCard(LaSoTuVi la) {
    final tk = tongKet(la);
    Widget block(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: AppColors.ink, fontSize: 13.5, height: 1.4),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.jadeDark)),
                TextSpan(text: value),
              ],
            ),
          ),
        );
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng kết',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.jadeDark,
                  fontSize: 15)),
          const SizedBox(height: 6),
          block('👍 Điểm mạnh', tk.diemManh.join(', ')),
          block('⚠ Điểm cần lưu ý', tk.diemYeu.join(', ')),
          block('💼 Nghề hợp', tk.ngheHop.join(', ')),
          block('🧭 Lời khuyên', tk.loiKhuyen),
        ],
      ),
    );
  }

  // Địa bàn 4×4: vị trí cung theo địa chi.
  static const List<List<int>> _layout = [
    [6, 7, 8, 9], // Tỵ Ngọ Mùi Thân
    [5, 0, 0, 10], // Thìn [   ] Dậu
    [4, 0, 0, 11], // Mão  [   ] Tuất
    [3, 2, 1, 12], // Dần Sửu Tý Hợi
  ];

  Widget _board(LaSoTuVi la) {
    return LayoutBuilder(builder: (context, c) {
      final cellW = c.maxWidth / 4;
      final cellH = cellW * 1.42;
      CungTuVi cung(int v) => la.cung.firstWhere((x) => x.viTri == v);
      Widget cell(int v) => SizedBox(
            width: cellW,
            height: cellH,
            child: _CungCell(cung: cung(v), onTap: () => _showCung(la, cung(v))),
          );

      return Column(
        children: [
          Row(children: [for (final v in _layout[0]) cell(v)]),
          SizedBox(
            height: cellH * 2,
            child: Row(
              children: [
                Column(children: [cell(5), cell(4)]),
                Expanded(child: _centerInfo(la)),
                Column(children: [cell(10), cell(11)]),
              ],
            ),
          ),
          Row(children: [for (final v in _layout[3]) cell(v)]),
        ],
      );
    });
  }

  Widget _centerInfo(LaSoTuVi la) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.jade.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('LÁ SỐ TỬ VI',
                style: TextStyle(
                    color: AppColors.jadeDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 1)),
            const SizedBox(height: 6),
            Text(la.canChiNam,
                style: const TextStyle(
                    color: AppColors.jade,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
            Text(la.cucTen,
                style: const TextStyle(color: AppColors.ink, fontSize: 12)),
            const SizedBox(height: 4),
            Text(la.amDuongMenh,
                style: const TextStyle(color: AppColors.inkSoft, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showCung(LaSoTuVi la, CungTuVi cung) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.62,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, ctrl) => GlassCard(
          radius: 24,
          fill: AppColors.glassStrong,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: ListView(
            controller: ctrl,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                      color: AppColors.glassBorder,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cung ${cung.tenCung}${cung.laThan ? ' (Thân)' : ''}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.jadeDark,
                          fontSize: 18),
                    ),
                  ),
                  Text('${cung.chi} · ĐH ${cung.daiHanTu}',
                      style: const TextStyle(
                          color: AppColors.inkSoft, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 10),
              _saoChips(cung),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                ),
                child: Text(ketLuanCung(cung),
                    style: const TextStyle(
                        color: AppColors.ink, fontSize: 13.5, height: 1.4)),
              ),
              if (boSaoCung(cung) != null) ...[
                const SizedBox(height: 10),
                _tag('Bộ sao', boSaoCung(cung)!),
              ],
              if (cung.voChinhDieu) ...[
                const SizedBox(height: 10),
                _tag('Xung chiếu', _xungChieu(la, cung)),
              ],
              const SizedBox(height: 12),
              Text(dienGiaiCung(cung, mode: _cheDo),
                  style: const TextStyle(
                      color: AppColors.ink, fontSize: 13.5, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saoChips(CungTuVi cung) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final s in cung.sao)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _saoBg(s),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              s.dacTinh != null ? '${s.ten} (${s.dacTinh})' : s.ten,
              style: TextStyle(
                  fontSize: 12,
                  color: _saoFg(s),
                  fontWeight:
                      s.laChinhTinh ? FontWeight.w800 : FontWeight.w500),
            ),
          ),
      ],
    );
  }
}

Color _saoBg(SaoTuVi s) {
  if (s.laChinhTinh) return AppColors.jade.withValues(alpha: 0.14);
  if (s.nhom == NhomSao.tuHoa) return AppColors.gold.withValues(alpha: 0.18);
  if (s.nhom == NhomSao.sat) return AppColors.bad.withValues(alpha: 0.12);
  if (s.nhom == NhomSao.phuTinhTot) return AppColors.good.withValues(alpha: 0.12);
  return Colors.white.withValues(alpha: 0.45);
}

Color _saoFg(SaoTuVi s) {
  if (s.laChinhTinh) return AppColors.jadeDark;
  if (s.nhom == NhomSao.tuHoa) return const Color(0xFF8A6D12);
  if (s.nhom == NhomSao.sat) return AppColors.bad;
  return AppColors.ink;
}

/// Một ô cung trên địa bàn.
class _CungCell extends StatelessWidget {
  final CungTuVi cung;
  final VoidCallback onTap;
  const _CungCell({required this.cung, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final chinh = cung.chinhTinh;
    final phu = cung.sao
        .where((s) => !s.laChinhTinh && s.nhom != NhomSao.khac)
        .take(4)
        .map((s) => s.ten)
        .toList();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: cung.laThan
                ? AppColors.jade
                : AppColors.glassBorder,
            width: cung.laThan ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chính tinh.
            Expanded(
              child: chinh.isEmpty
                  ? const Text('Vô chính diệu',
                      style: TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 10.5,
                          fontStyle: FontStyle.italic))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final s in chinh)
                          Text(
                            s.dacTinh != null
                                ? '${s.ten}·${s.dacTinh![0]}'
                                : s.ten,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.jadeDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5),
                          ),
                        if (phu.isNotEmpty)
                          Text(phu.join(' '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.inkSoft, fontSize: 9.5)),
                      ],
                    ),
            ),
            // Chân ô: tên cung + chi + tuần/triệt.
            Row(
              children: [
                Expanded(
                  child: Text(cung.tenCung,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.jade,
                          fontWeight: FontWeight.w700,
                          fontSize: 10)),
                ),
                if (cung.tuan)
                  const Text('T ', style: _markStyle),
                if (cung.triet)
                  const Text('Tr ', style: _markStyle),
                Text(cung.chi,
                    style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static const _markStyle = TextStyle(
      color: AppColors.bad, fontSize: 9, fontWeight: FontWeight.w700);
}

/// Nền jade tái dùng cho route đẩy ra (giống các màn con khác).
class _JadeBg extends StatelessWidget {
  const _JadeBg();
  @override
  Widget build(BuildContext context) {
    return Image.asset(AppTheme.current.bgAsset, fit: BoxFit.cover);
  }
}
