import 'package:flutter/material.dart';
import '../../data/profile_store.dart';
import '../theme.dart';

/// Thanh chọn người (bản thân + người thân) đặt đầu mỗi tiện ích.
/// Chọn người nào → tiện ích tính lại theo người đó. Tự ẩn khi chỉ có 1 người.
///
/// Trạng thái "đang chọn" là CỤC BỘ theo màn (mặc định là người đầu = bản thân,
/// reset khi rời màn) — không giữ state toàn cục để tránh phụ thuộc ẩn.
class PersonPicker extends StatelessWidget {
  final List<Profile> people;
  final String selectedId;
  final ValueChanged<Profile> onSelected;

  const PersonPicker({
    super.key,
    required this.people,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (people.length <= 1) return const SizedBox.shrink();
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: people.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final p = people[i];
          return _PersonChip(
            profile: p,
            selected: p.id == selectedId,
            onTap: () => onSelected(p),
          );
        },
      ),
    );
  }
}

class _PersonChip extends StatefulWidget {
  final Profile profile;
  final bool selected;
  final VoidCallback onTap;
  const _PersonChip({
    required this.profile,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_PersonChip> createState() => _PersonChipState();
}

class _PersonChipState extends State<_PersonChip> {
  bool _down = false;

  String get _label {
    final p = widget.profile;
    if (p.isSelf) return 'Bản thân';
    return p.name.trim().isNotEmpty ? p.name.trim() : p.relation;
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    final p = widget.profile;
    final icon = p.isSelf
        ? Icons.person
        : (p.gender == Gender.nu ? Icons.face_3 : Icons.face_6);

    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        // Nhấn: co nhẹ cho cảm giác chạm (theo skill polish, không quá đà).
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(8, 6, 14, 6),
          decoration: BoxDecoration(
            color: sel ? AppColors.jade : AppColors.glassStrong,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: sel ? AppColors.jade : AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: sel
                    ? Colors.white.withValues(alpha: 0.24)
                    : AppColors.jade.withValues(alpha: 0.14),
                child: Icon(icon,
                    size: 18, color: sel ? Colors.white : AppColors.jade),
              ),
              const SizedBox(width: 8),
              Text(_label,
                  style: TextStyle(
                      color: sel ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
            ],
          ),
        ),
      ),
    );
  }
}
