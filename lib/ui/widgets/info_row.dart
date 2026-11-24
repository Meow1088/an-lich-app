import 'package:flutter/material.dart';
import '../theme.dart';

/// Hàng "Nhãn — Giá trị" dùng chung trong các thẻ thông tin (GlassCard).
/// Nhãn xám nhạt bên trái, giá trị đậm canh phải. Gom từ các bản `_row` lặp
/// ở today/doi_ngay/tinh_tuoi để dùng một chỗ.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  /// Khoảng đệm dọc của hàng. Mặc định 6 (chuẩn hoá chung).
  final double gap;

  /// Màu giá trị — mặc định [AppColors.ink]. Dùng để tô tốt/xấu (vd hợp tuổi,
  /// xem tuổi) thay vì mỗi màn tự viết `_row`/`_infoRow` riêng.
  final Color valueColor;

  /// Bề rộng cố định cho nhãn thay vì canh phải giá trị (mặc định null =
  /// hành vi cũ: nhãn co giãn, giá trị canh phải).
  final double? labelWidth;

  /// Cỡ chữ — mặc định null = dùng cỡ mặc định của Theme (như trước).
  final double? fontSize;

  const InfoRow(
    this.label,
    this.value, {
    super.key,
    this.gap = 6,
    this.valueColor = AppColors.ink,
    this.labelWidth,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      label,
      style: TextStyle(color: AppColors.inkSoft, fontSize: fontSize),
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidth != null
              ? SizedBox(width: labelWidth, child: labelWidget)
              : labelWidget,
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: labelWidth != null ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
