import 'package:flutter/material.dart';
import '../theme.dart';

/// Tiêu đề mục trong 1 GlassCard — chữ đậm màu jadeDark, icon/emoji tuỳ chọn
/// bên trái, widget phụ (badge/sao) tuỳ chọn bên phải. Gom từ các tiêu đề
/// `Text(..., fontWeight: w700/w800, color: AppColors.jadeDark)` lặp lại
/// trong nhiều màn (hợp tuổi, xem tuổi, hồ sơ vận trình...).
class SectionHeader extends StatelessWidget {
  final String title;
  final String? icon; // emoji, vd '📅'
  final Widget? trailing;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const SectionHeader(
    this.title, {
    super.key,
    this.icon,
    this.trailing,
    this.fontSize = 15.5,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (icon != null) ...[
            Text(icon!, style: TextStyle(fontSize: fontSize + 1.5)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.jadeDark,
                fontSize: fontSize,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
