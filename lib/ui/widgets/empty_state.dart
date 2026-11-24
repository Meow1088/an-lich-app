import 'package:flutter/material.dart';
import '../theme.dart';

/// Trạng thái "cần hồ sơ cá nhân" trong 1 GlassCard giữa màn — gom từ 5 bản
/// gần như giống hệt nhau ở bat_trach/luan_tuoi/sao_han/tu_vi/bao_cao_screen
/// (icon + tiêu đề + phụ đề tuỳ chọn + nút "Thêm hồ sơ").
class EmptyState extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String title;
  final String? subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  /// Icon trên nút — null = nút chữ đơn giản (khớp bản gốc bat_trach/luan_tuoi/sao_han).
  final IconData? buttonIcon;

  const EmptyState({
    super.key,
    this.icon = Icons.person_add_alt_1,
    this.iconSize = 40,
    required this.title,
    this.subtitle,
    this.buttonLabel = 'Thêm hồ sơ',
    required this.onPressed,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: AppColors.jade,
      foregroundColor: Colors.white,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: AppColors.jade),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.jadeDark,
                  fontSize: 16,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
                ),
              ],
              const SizedBox(height: 12),
              buttonIcon != null
                  ? FilledButton.icon(
                      onPressed: onPressed,
                      style: buttonStyle,
                      icon: Icon(buttonIcon),
                      label: Text(buttonLabel),
                    )
                  : FilledButton(
                      onPressed: onPressed,
                      style: buttonStyle,
                      child: Text(buttonLabel),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
