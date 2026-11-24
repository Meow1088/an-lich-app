import 'package:flutter/material.dart';
import 'theme.dart';

/// Nút dấu "?" nhỏ — bấm hiện popup giải thích ngắn gọn, dễ hiểu.
class HelpIcon extends StatelessWidget {
  final String title;
  final String content;
  const HelpIcon({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFFF1F8F3),
          title: Text(title,
              style: const TextStyle(
                  color: AppColors.jadeDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 17)),
          content: SingleChildScrollView(
            child: Text(content,
                style: const TextStyle(
                    color: AppColors.ink, fontSize: 15, height: 1.55)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đã hiểu'),
            ),
          ],
        ),
      ),
      customBorder: const CircleBorder(),
      child: const Padding(
        padding: EdgeInsets.all(3),
        child: Icon(Icons.help_outline, size: 17, color: AppColors.inkSoft),
      ),
    );
  }
}
