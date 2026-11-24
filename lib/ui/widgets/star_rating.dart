import 'package:flutter/material.dart';
import '../theme.dart';

/// Chuỗi sao ★/☆ điểm 0-5 — gom từ 2 chỗ lặp trong bao_cao_screen.dart
/// (mục điểm sao ở tiêu đề + mốc vận hạn theo thập niên).
class StarRating extends StatelessWidget {
  final int sao; // 0..5
  final double fontSize;
  final double letterSpacing;

  const StarRating(
    this.sao, {
    super.key,
    this.fontSize = 14,
    this.letterSpacing = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '★' * sao + '☆' * (5 - sao),
      style: TextStyle(
        color: AppColors.gold,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
