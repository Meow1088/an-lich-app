import 'package:flutter/material.dart';
import '../core/can_chi.dart';
import '../core/lunar_calendar.dart';
import '../data/profile_store.dart';
import 'ho_so_screen.dart';
import 'patterns/app_scaffold.dart';
import 'theme.dart';

/// Quản lý hồ sơ: chính chủ (bản thân) + danh sách người thân.
/// Thêm/sửa/xoá người thân; mỗi tiện ích sau đó cho chọn xem theo từng người.
class NguoiThanScreen extends StatefulWidget {
  const NguoiThanScreen({super.key});

  @override
  State<NguoiThanScreen> createState() => _NguoiThanScreenState();
}

class _NguoiThanScreenState extends State<NguoiThanScreen> {
  final _store = ProfileStore();
  Profile? _self;
  List<Profile> _relatives = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final self = await _store.load();
    final rel = await _store.loadRelatives();
    if (!mounted) return;
    setState(() {
      _self = self;
      _relatives = rel;
      _loading = false;
    });
  }

  Future<void> _editSelf() async {
    final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(
        builder: (_) => HoSoScreen(initial: _self, isSelf: true)));
    if (ok == true) _load();
  }

  Future<void> _addRelative() async {
    final pr = await Navigator.of(context).push<Profile>(
        MaterialPageRoute(builder: (_) => const HoSoScreen(isSelf: false)));
    if (pr != null) {
      await _store.upsertRelative(pr);
      _load();
    }
  }

  Future<void> _editRelative(Profile r) async {
    final pr = await Navigator.of(context).push<Profile>(MaterialPageRoute(
        builder: (_) => HoSoScreen(initial: r, isSelf: false)));
    if (pr != null) {
      await _store.upsertRelative(pr);
      _load();
    }
  }

  Future<void> _deleteRelative(Profile r) async {
    final label = r.name.trim().isNotEmpty ? r.name.trim() : r.relation;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá người thân?'),
        content: Text('Xoá "$label" khỏi danh sách? Không thể hoàn tác.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Huỷ')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.bad),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _store.deleteRelative(r.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hồ sơ & người thân',
      body: _loading
          ? const SizedBox.shrink()
          : (_self == null ? _needSelf() : _list()),
    );
  }

  Widget _needSelf() => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_add_alt_1,
                    size: 42, color: AppColors.jade),
                const SizedBox(height: 10),
                const Text('Thêm thông tin của bạn trước',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.jadeDark,
                        fontSize: 16)),
                const SizedBox(height: 6),
                const Text('Có hồ sơ của bạn rồi mới thêm được người thân.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.inkSoft, fontSize: 13)),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _editSelf,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm hồ sơ của bạn'),
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.jade,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _list() => ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        children: [
          _PersonRow(
            profile: _self!,
            strong: true,
            onEdit: _editSelf,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text('Người thân',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.jadeDark,
                      fontSize: 15.5)),
              const SizedBox(width: 8),
              if (_relatives.isNotEmpty)
                Text('(${_relatives.length})',
                    style: const TextStyle(
                        color: AppColors.inkSoft, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          if (_relatives.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Chưa có người thân nào. Thêm bố mẹ, vợ/chồng, con… để xem tử vi, xem tuổi, sao hạn cho từng người.',
                style: TextStyle(
                    color: AppColors.inkSoft, fontSize: 13, height: 1.45),
              ),
            ),
          for (final r in _relatives) ...[
            _PersonRow(
              profile: r,
              onEdit: () => _editRelative(r),
              onDelete: () => _deleteRelative(r),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: _addRelative,
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Thêm người thân'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.jade,
              side: const BorderSide(color: AppColors.jade),
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      );
}

/// Hàng tóm tắt 1 người: avatar + tên/quan hệ + năm sinh · con giáp · mệnh.
class _PersonRow extends StatelessWidget {
  final Profile profile;
  final bool strong;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  const _PersonRow({
    required this.profile,
    required this.onEdit,
    this.strong = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final lunar = solarToLunar(p.birthDate.day, p.birthDate.month, p.birthDate.year);
    final conGiap = diaChi[(lunar.year + 8) % 12];
    final canChi = canChiOfYear(lunar.year);
    final menh = napAmOfYear(lunar.year).name;
    final title = p.isSelf
        ? (p.name.trim().isEmpty ? 'Bản thân' : p.name.trim())
        : (p.name.trim().isEmpty ? p.relation : p.name.trim());
    final icon = p.isSelf
        ? Icons.person
        : (p.gender == Gender.nu ? Icons.face_3 : Icons.face_6);

    return GestureDetector(
      onTap: onEdit,
      child: GlassCard(
        fill: strong ? AppColors.glassStrong : null,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.jade.withValues(alpha: 0.16),
              child: Icon(icon, color: AppColors.jade),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.jadeDark,
                                fontSize: 16)),
                      ),
                      const SizedBox(width: 8),
                      _RelationTag(p.isSelf ? 'Bản thân' : p.relation),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${p.gender.label} · ${p.birthDate.day}/${p.birthDate.month}/${p.birthDate.year}',
                    style: const TextStyle(color: AppColors.ink, fontSize: 13),
                  ),
                  Text('Tuổi $conGiap ($canChi) · Mệnh $menh',
                      style: const TextStyle(
                          color: AppColors.inkSoft, fontSize: 12.5)),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                tooltip: 'Xoá',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.inkSoft, size: 22),
              )
            else
              const Icon(Icons.edit, color: AppColors.inkSoft, size: 20),
          ],
        ),
      ),
    );
  }
}

class _RelationTag extends StatelessWidget {
  final String text;
  const _RelationTag(this.text);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.jade.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.jade,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      );
}
