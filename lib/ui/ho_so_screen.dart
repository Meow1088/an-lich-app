import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/gio_sinh_chuan.dart';
import '../core/hoang_dao.dart' show gioChiNames, gioRanges;
import '../core/lunar_calendar.dart';
import '../core/noi_sinh_data.dart';
import '../data/profile_store.dart';
import 'theme.dart';
import 'patterns/app_scaffold.dart';

/// Các quan hệ gợi ý sẵn khi thêm người thân ('Khác' → nhập tự do).
const List<String> _relationChoices = [
  'Bố',
  'Mẹ',
  'Vợ/Chồng',
  'Con',
  'Anh/Chị/Em',
  'Ông/Bà',
  'Bạn bè',
  'Khác',
];

/// Nhập / sửa hồ sơ cá nhân. Ngày sinh DƯƠNG LỊCH.
///
/// - [isSelf] = true (mặc định): hồ sơ CHÍNH CHỦ — tự lưu vào store, pop(true).
/// - [isSelf] = false: hồ sơ NGƯỜI THÂN — không tự lưu, pop trả về [Profile]
///   để màn quản lý người thân lưu (giữ 1 chỗ ghi dữ liệu người thân).
class HoSoScreen extends StatefulWidget {
  final Profile? initial;
  final bool isSelf;
  const HoSoScreen({super.key, this.initial, this.isSelf = true});

  @override
  State<HoSoScreen> createState() => _HoSoScreenState();
}

class _HoSoScreenState extends State<HoSoScreen> {
  final _store = ProfileStore();
  late TextEditingController _name;
  late TextEditingController _relationOther;
  late DateTime _dob;
  late Gender _gender;
  late HourConfidence _conf;
  late String _relation; // 1 trong _relationChoices (chỉ khi người thân)
  int _hourVal = 0; // 0..11 (dùng khi biết chính xác / ước lượng)
  int? _gioPhut; // phút từ 00:00, null = không nhập
  String? _noiSinh; // tên tỉnh trong kNoiSinh, null = không rõ

  bool get _isRelative => !widget.isSelf;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _name = TextEditingController(text: p?.name ?? '');
    _dob = p?.birthDate ?? DateTime(1990, 1, 1);
    _gender = p?.gender ?? Gender.nam;
    _conf = p?.hourConf ?? HourConfidence.khongBiet;
    _hourVal = p?.hourChi ?? 0;
    _gioPhut = p?.gioPhut;
    _noiSinh = p?.noiSinh;
    // Quan hệ hiện tại có nằm trong danh sách gợi ý không? Nếu không → 'Khác'.
    final rel = p?.relation ?? 'Bố';
    if (_relationChoices.contains(rel)) {
      _relation = rel;
      _relationOther = TextEditingController();
    } else {
      _relation = 'Khác';
      _relationOther = TextEditingController(text: rel);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _relationOther.dispose();
    super.dispose();
  }

  String get _title => widget.isSelf
      ? 'Thông tin cá nhân'
      : (widget.initial == null ? 'Thêm người thân' : 'Sửa người thân');

  /// Nhãn quan hệ cuối cùng cho người thân ('Khác' → lấy chữ tự nhập).
  String get _resolvedRelation {
    if (widget.isSelf) return kSelfRelation;
    if (_relation == 'Khác') {
      final t = _relationOther.text.trim();
      return t.isEmpty ? 'Người thân' : t;
    }
    return _relation;
  }

  Future<void> _pickDob() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      locale: const Locale('vi'),
    );
    if (d != null) {
      setState(() {
        _dob = d;
        _autoChi();
      });
    }
  }

  /// Kết quả quy giờ chuẩn / giờ mặt trời; null khi chưa nhập giờ:phút hoặc không rõ nơi sinh.
  KetQuaGioSinh? get _kq {
    final gp = _gioPhut;
    final ns = timNoiSinh(_noiSinh);
    if (gp == null || ns == null) return null;
    return chuanHoaGioSinh(
        DateTime(_dob.year, _dob.month, _dob.day, gp ~/ 60, gp % 60),
        vung: ns.vung,
        kinhDo: ns.kinhDo);
  }

  /// Có giờ:phút → tự đặt chi giờ chuẩn (người dùng vẫn đổi tay được sau đó).
  void _autoChi() {
    final gp = _gioPhut;
    if (gp == null) return;
    _hourVal = _kq?.chiChuan ?? chiCuaGio(gp ~/ 60, gp % 60);
  }

  Future<void> _pickGioPhut() async {
    final gp = _gioPhut;
    final t = await showTimePicker(
      context: context,
      initialTime: gp == null
          ? const TimeOfDay(hour: 12, minute: 0)
          : TimeOfDay(hour: gp ~/ 60, minute: gp % 60),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (t != null) {
      setState(() {
        _gioPhut = t.hour * 60 + t.minute;
        _autoChi();
      });
    }
  }

  Future<void> _save() async {
    final pr = Profile(
      id: widget.isSelf ? kSelfId : (widget.initial?.id ?? ProfileStore.newId()),
      relation: _resolvedRelation,
      name: _name.text.trim(),
      birthDate: _dob,
      gender: _gender,
      hourChi: _conf == HourConfidence.khongBiet ? null : _hourVal,
      hourConf: _conf,
      gioPhut: _conf == HourConfidence.khongBiet ? null : _gioPhut,
      noiSinh: _conf == HourConfidence.khongBiet ? null : _noiSinh,
    );
    if (widget.isSelf) {
      await _store.save(pr);
      if (mounted) Navigator.of(context).pop(true);
    } else {
      // Người thân: trả hồ sơ về cho màn quản lý lưu.
      if (mounted) Navigator.of(context).pop(pr);
    }
  }

  String _hourHint(HourConfidence c) => switch (c) {
        HourConfidence.chinhXac =>
          'Giờ sinh chính xác giúp lập lá số 12 cung đúng nhất.',
        HourConfidence.uocLuong =>
          'Chọn giờ gần đúng cũng được; một số cung/hạn có thể lệch đôi chút.',
        HourConfidence.khongBiet =>
          'Không có giờ sinh, lá số chỉ luận tổng quát (độ chính xác ~60–70%).',
      };

  @override
  Widget build(BuildContext context) {
    final lunar = solarToLunar(_dob.day, _dob.month, _dob.year);
    final canChi = canChiOfYear(lunar.year);
    final menh = napAmOfYear(lunar.year).name;

    return AppScaffold(
      title: _title,
      actions: [
        IconButton(
          tooltip: 'Lưu',
          onPressed: _save,
          icon: const Icon(Icons.check, color: AppColors.jade),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
        children: [
          if (_isRelative) _relationCard(),
          if (_isRelative) const SizedBox(height: 12),
          _identityCard(),
          const SizedBox(height: 12),
          _hourCard(),
          const SizedBox(height: 12),
          _previewCard(canChi, menh),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(widget.isSelf ? 'Lưu hồ sơ' : 'Lưu người thân'),
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.jade,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48)),
          ),
        ],
      ),
    );
  }

  // --- Quan hệ (chỉ người thân) ---
  Widget _relationCard() => GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Lbl('Quan hệ với bạn'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in _relationChoices)
                  ChoiceChip(
                    label: Text(r),
                    selected: _relation == r,
                    onSelected: (_) => setState(() => _relation = r),
                    showCheckmark: false,
                    selectedColor: AppColors.jade,
                    labelStyle: TextStyle(
                      color:
                          _relation == r ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    backgroundColor: AppColors.glassStrong,
                    side: BorderSide(
                        color: _relation == r
                            ? AppColors.jade
                            : AppColors.glassBorder),
                  ),
              ],
            ),
            if (_relation == 'Khác') ...[
              const SizedBox(height: 10),
              TextField(
                controller: _relationOther,
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: Cháu, Đồng nghiệp…',
                  isDense: true,
                ),
              ),
            ],
          ],
        ),
      );

  // --- Danh tính: tên + ngày sinh + giới tính ---
  Widget _identityCard() => GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Lbl(_isRelative ? 'Họ tên người thân' : 'Họ tên (tùy chọn)'),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Ví dụ: Nguyễn Văn A',
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            const _Lbl('Ngày sinh (dương lịch)'),
            InkWell(
              onTap: _pickDob,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.cake_outlined,
                        size: 20, color: AppColors.jade),
                    const SizedBox(width: 10),
                    Text('${_dob.day}/${_dob.month}/${_dob.year}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFeatures: [FontFeature.tabularFigures()],
                            color: AppColors.ink)),
                    const Spacer(),
                    const Icon(Icons.edit_calendar,
                        size: 18, color: AppColors.inkSoft),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const _Lbl('Giới tính'),
            const SizedBox(height: 4),
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.nam, label: Text('Nam')),
                ButtonSegment(value: Gender.nu, label: Text('Nữ')),
              ],
              selected: {_gender},
              onSelectionChanged: (s) => setState(() => _gender = s.first),
            ),
          ],
        ),
      );

  // --- Giờ sinh ---
  Widget _hourCard() => GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Lbl('Giờ sinh (cho lá số tử vi)'),
            const SizedBox(height: 4),
            SegmentedButton<HourConfidence>(
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: const [
                ButtonSegment(
                    value: HourConfidence.chinhXac, label: Text('Chính xác')),
                ButtonSegment(
                    value: HourConfidence.uocLuong, label: Text('Ước lượng')),
                ButtonSegment(
                    value: HourConfidence.khongBiet, label: Text('Không biết')),
              ],
              selected: {_conf},
              onSelectionChanged: (s) => setState(() => _conf = s.first),
            ),
            if (_conf != HourConfidence.khongBiet) ...[
              const SizedBox(height: 8),
              DropdownButton<int>(
                value: _hourVal,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: [
                  for (var i = 0; i < 12; i++)
                    DropdownMenuItem(
                        value: i,
                        child: Text('${gioChiNames[i]} (${gioRanges[i]}h)')),
                ],
                onChanged: (v) => setState(() => _hourVal = v ?? 0),
              ),
              ..._gioPhutRows(),
            ],
            const SizedBox(height: 6),
            Text(_hourHint(_conf),
                style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    fontStyle: FontStyle.italic)),
          ],
        ),
      );

  // --- Giờ:phút + nơi sinh (không bắt buộc) và các gợi ý đi kèm ---
  List<Widget> _gioPhutRows() {
    final gp = _gioPhut;
    final kq = _kq;
    const small = TextStyle(
        color: AppColors.inkSoft, fontSize: 12, fontStyle: FontStyle.italic);
    final ns = timNoiSinh(_noiSinh);
    String? infoMui;
    if (gp != null && kq != null && kq.chiChuan != chiCuaGio(gp ~/ 60, gp % 60)) {
      final mui = muiGioGiay(
          DateTime(_dob.year, _dob.month, _dob.day, gp ~/ 60, gp % 60),
          ns!.vung);
      final hh = kq.gioChuan.hour.toString().padLeft(2, '0');
      final mm = kq.gioChuan.minute.toString().padLeft(2, '0');
      infoMui = 'Giờ đồng hồ lúc đó là UTC+${mui ~/ 3600}, đã quy về giờ chuẩn $hh:$mm.';
    }
    return [
      const SizedBox(height: 8),
      InkWell(
        onTap: _pickGioPhut,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.schedule, size: 20, color: AppColors.jade),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  gp == null
                      ? 'Giờ:phút (không bắt buộc)'
                      : '${(gp ~/ 60).toString().padLeft(2, '0')}:${(gp % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                      fontSize: gp == null ? 14 : 16,
                      fontWeight: gp == null ? FontWeight.w500 : FontWeight.w700,
                      color: gp == null ? AppColors.inkSoft : AppColors.ink),
                ),
              ),
              if (gp != null)
                IconButton(
                  tooltip: 'Xóa giờ:phút',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _gioPhut = null),
                  icon: const Icon(Icons.clear, size: 18),
                ),
            ],
          ),
        ),
      ),
      const _Lbl('Nơi sinh'),
      DropdownButton<String?>(
        value: ns?.ten,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: [
          const DropdownMenuItem<String?>(value: null, child: Text('Không rõ')),
          for (final n in kNoiSinh)
            DropdownMenuItem<String?>(value: n.ten, child: Text(n.ten)),
        ],
        onChanged: (v) => setState(() {
          _noiSinh = v;
          _autoChi();
        }),
      ),
      if (infoMui != null) Text(infoMui, style: small),
      if (kq != null && kq.satRanh) ...[
        const SizedBox(height: 4),
        Text(
            'Theo giờ mặt trời ở ${ns!.ten}, giờ sinh rơi vào giờ ${gioChiNames[kq.chiMatTroi]} '
            '(lệch ${kq.lechMatTroiPhut >= 0 ? '+' : '-'}${kq.lechMatTroiPhut.abs().round()} phút). '
            'Sát ranh giới giờ — chỉ để tham khảo.',
            style: small),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() => _hourVal = kq.chiMatTroi),
            child: Text('Dùng giờ ${gioChiNames[kq.chiMatTroi]}'),
          ),
        ),
      ],
    ];
  }

  // --- Xem trước năm sinh âm lịch + mệnh ---
  Widget _previewCard(String canChi, String menh) => GlassCard(
        fill: AppColors.glassStrong,
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.jade, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Năm sinh âm lịch: $canChi · Mệnh $menh',
                style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5),
              ),
            ),
          ],
        ),
      );
}

class _Lbl extends StatelessWidget {
  final String text;
  const _Lbl(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: AppColors.inkSoft, fontWeight: FontWeight.w600, fontSize: 13));
}
