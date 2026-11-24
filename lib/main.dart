import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/settings_store.dart';
import 'services/notifications.dart';
import 'ui/pin_screen.dart';
import 'ui/splash_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();

  // Nạp giao diện đã lưu trước khi vẽ (tránh nháy theme).
  final store = SettingsStore();
  ThemeController.mode = ThemeController.modeFromString(
    await store.getThemeMode(),
  );
  ThemeController.lightId = await store.getLightThemeId();
  ThemeController.platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  ThemeController.resolve();
  textScaleNotifier.value = await store.getTextScale();
  glassEffectNotifier.value = await store.getGlassEffect();

  runApp(const LichAmApp());
}

class LichAmApp extends StatefulWidget {
  const LichAmApp({super.key});

  @override
  State<LichAmApp> createState() => _LichAmAppState();
}

class _LichAmAppState extends State<LichAmApp> with WidgetsBindingObserver {
  bool _wasBackgrounded = false;
  bool _pinScreenShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Khi hệ thống đổi sáng/tối → áp lại nếu đang ở chế độ "Hệ thống".
    ThemeController.setPlatformBrightness(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Khóa PIN (nếu đã đặt) mỗi khi app quay lại từ nền — không khóa ở lần
    // mở đầu tiên (Splash tự lo việc đó) hay khi chỉ thoáng mất focus.
    if (state == AppLifecycleState.paused) {
      _wasBackgrounded = true;
      return;
    }
    if (state != AppLifecycleState.resumed) return;
    if (!_wasBackgrounded || _pinScreenShowing) return;
    _wasBackgrounded = false;
    _maybeRelock();
  }

  Future<void> _maybeRelock() async {
    final hash = await SettingsStore().getPinHash();
    if (hash == null) return;
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return;
    _pinScreenShowing = true;
    await nav.push(
      MaterialPageRoute(
        builder: (_) => PinLockScreen(
          onUnlocked: () => rootNavigatorKey.currentState?.pop(),
        ),
      ),
    );
    _pinScreenShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeSpec>(
      valueListenable: appThemeNotifier,
      builder: (_, spec, _) {
        return MaterialApp(
          navigatorKey: rootNavigatorKey,
          title: 'An Lịch',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(spec),
          locale: const Locale('vi'),
          supportedLocales: const [Locale('vi'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => ValueListenableBuilder<double>(
            valueListenable: textScaleNotifier,
            builder: (context, scale, _) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
