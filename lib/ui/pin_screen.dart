import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../data/settings_store.dart';
import 'patterns/app_scaffold.dart';
import 'theme.dart';

/// Băm PIN + salt cố định (không cần bảo mật cấp ngân hàng — chỉ chặn người
/// khác cầm máy xem lén hồ sơ/tử vi). Luôn lưu hash, KHÔNG bao giờ lưu PIN gốc.
String hashPin(String pin) {
  final bytes = utf8.encode('an_lich_pin_salt_$pin');
  return sha256.convert(bytes).toString();
}

/// Bàn phím số + 4 chấm tiến trình, dùng chung cho mọi màn liên quan PIN.
/// Không tự xử lý đúng/sai — cha truyền [onComplete] và quyết định bước kế.
class PinPad extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? error;
  final Widget? leading;
  final ValueChanged<String> onComplete;

  const PinPad({
    super.key,
    required this.title,
    required this.onComplete,
    this.subtitle,
    this.error,
    this.leading,
  });

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _entered = '';

  @override
  void didUpdateWidget(covariant PinPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != null && widget.error != oldWidget.error) {
      // Có lỗi mới (vd PIN sai) -> xóa để người dùng nhập lại từ đầu.
      setState(() => _entered = '');
    }
  }

  void _tapDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() => _entered += d);
    if (_entered.length == 4) {
      final pin = _entered;
      widget.onComplete(pin);
    }
  }

  void _backspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leading != null) widget.leading!,
        const SizedBox(height: 14),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.jadeDark,
          ),
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
          ),
        ],
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final filled = i < _entered.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? AppColors.jade : Colors.transparent,
                border: Border.all(color: AppColors.jade, width: 1.5),
              ),
            );
          }),
        ),
        SizedBox(
          height: 22,
          child: widget.error == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.error!,
                    style: const TextStyle(
                      color: AppColors.bad,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 18),
        _NumPad(onDigit: _tapDigit, onBackspace: _backspace),
      ],
    );
  }
}

class _NumPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  const _NumPad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'back'],
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((k) {
            if (k.isEmpty) return const SizedBox(width: 64, height: 56);
            if (k == 'back') {
              return SizedBox(
                width: 64,
                height: 56,
                child: IconButton(
                  onPressed: onBackspace,
                  icon: const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.ink,
                  ),
                ),
              );
            }
            return SizedBox(
              width: 64,
              height: 56,
              child: TextButton(
                onPressed: () => onDigit(k),
                style: TextButton.styleFrom(shape: const CircleBorder()),
                child: Text(
                  k,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

/// Màn khóa: bắt buộc nhập đúng PIN mới đi tiếp. Dùng ở 2 chỗ:
/// (1) mở app lần đầu (Splash, [allowCancel]=false — không có đường lùi);
/// (2) xác thực trước khi đổi/tắt PIN trong Cài đặt ([allowCancel]=true).
class PinLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  final bool allowCancel;

  const PinLockScreen({
    super.key,
    required this.onUnlocked,
    this.allowCancel = false,
  });

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String? _error;

  Future<void> _check(String pin) async {
    final saved = await SettingsStore().getPinHash();
    if (saved != null && saved == hashPin(pin)) {
      widget.onUnlocked();
    } else if (mounted) {
      setState(() => _error = 'Sai PIN, thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: PinPad(
        title: 'Nhập PIN để mở An Lịch',
        error: _error,
        leading: const Icon(Icons.lock, size: 40, color: AppColors.jade),
        onComplete: _check,
      ),
    );
    if (widget.allowCancel) {
      return AppScaffold(title: 'Nhập PIN', body: body);
    }
    // Khóa thật (mở app / quay lại từ nền): không cho lùi ra ngoài.
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.glassStrong,
        body: SafeArea(child: body),
      ),
    );
  }
}

enum _SetupStep { enterNew, confirmNew }

/// Đặt PIN mới hoặc đổi PIN — nhập 2 lần khớp nhau mới lưu. Trả về `true`
/// qua `Navigator.pop` nếu lưu thành công.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  _SetupStep _step = _SetupStep.enterNew;
  String _firstPin = '';
  String? _error;

  Future<void> _handle(String pin) async {
    if (_step == _SetupStep.enterNew) {
      setState(() {
        _firstPin = pin;
        _step = _SetupStep.confirmNew;
        _error = null;
      });
      return;
    }
    if (pin == _firstPin) {
      await SettingsStore().setPinHash(hashPin(pin));
      if (mounted) Navigator.of(context).pop(true);
    } else {
      setState(() {
        _step = _SetupStep.enterNew;
        _firstPin = '';
        _error = 'Hai lần nhập không khớp, thử lại từ đầu.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Đặt PIN khóa app',
      body: Center(
        child: PinPad(
          key: ValueKey(_step),
          title: _step == _SetupStep.enterNew
              ? 'Nhập PIN mới (4 số)'
              : 'Nhập lại để xác nhận',
          error: _error,
          onComplete: _handle,
        ),
      ),
    );
  }
}
