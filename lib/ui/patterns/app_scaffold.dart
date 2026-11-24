import 'package:flutter/material.dart';
import '../theme.dart';

/// Khung màn chuẩn: nền theme (đặt dưới) + Scaffold trong suốt + AppBar tiêu đề.
/// Gom phần boilerplate `Stack[ appBackground(), Scaffold(transparent, AppBar) ]`
/// lặp ở mọi màn con để dùng một chỗ.
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        appBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text(title), actions: actions, leading: leading),
          body: body,
        ),
      ],
    );
  }
}
