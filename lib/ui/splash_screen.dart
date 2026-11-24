import 'package:flutter/material.dart';
import '../data/settings_store.dart';
import 'theme.dart';
import 'home_shell.dart';
import 'onboarding_screen.dart';
import 'pin_screen.dart';

/// Màn khởi động: logo hoa sen fade + phóng nhẹ, rồi điều hướng tới Onboarding
/// (lần đầu) hoặc Home. Tối thiểu ~1.3s để tránh nháy.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 850))
      ..forward();
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.82, end: 1.0)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack));
    _go();
  }

  Future<void> _go() async {
    final seen = await SettingsStore().getSeenOnboarding();
    final pinHash = await SettingsStore().getPinHash();
    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;

    Widget dest = seen ? const HomeShell() : const OnboardingScreen();
    // Đã đặt PIN + đã qua onboarding -> bắt nhập PIN trước khi vào Home.
    // (Lần đầu cài app luôn cho qua onboarding thẳng, chưa có PIN để hỏi.)
    if (pinHash != null && seen) {
      final home = dest;
      dest = PinLockScreen(
        // Dùng navigator toàn app (không dùng context của Splash — màn này
        // sẽ bị thay thế/dispose ngay sau pushReplacement bên dưới).
        onUnlocked: () => rootNavigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => home),
        ),
      );
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => dest));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = AppTheme.current;
    return Stack(
      children: [
        appBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        color: spec.glassStrong,
                        shape: BoxShape.circle,
                        border: Border.all(color: spec.glassBorder, width: 1),
                      ),
                      child: const Icon(Icons.spa,
                          size: 68, color: AppColors.jade),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'An Lịch',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: spec.onBg,
                        shadows: onBgShadows(spec),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Lịch âm · Tử vi · Phong thủy',
                      style: TextStyle(
                        fontSize: 14,
                        color: spec.onBgSoft,
                        shadows: onBgShadows(spec),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
