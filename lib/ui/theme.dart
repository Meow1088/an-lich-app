import 'dart:ui';
import 'package:flutter/material.dart';

/// Bảng màu lõi (chữ TRONG thẻ kính). Giữ nguyên ý nghĩa cũ — thẻ kính luôn
/// sáng nên các màu này đọc tốt trên mọi nền (kể cả nền tối).
class AppColors {
  AppColors._();

  // --- Lõi xanh ngọc ---
  static const jade = Color(0xFF1E6E4F); // primary
  static const jadeDark = Color(0xFF154E39); // tiêu đề trong thẻ
  static const jadeSoft = Color(0xFF3E8E6B);

  // --- Màu ngữ nghĩa ---
  static const good = Color(0xFF2E7D5B); // Tốt / Hoàng đạo / Nên
  static const bad = Color(0xFFC0392B); // Xấu / Hắc đạo / Tránh
  static const gold = Color(0xFFC9A227); // lễ / sự kiện

  // --- Chữ trên nền kính ---
  static const ink = Color(0xFF1F352B);
  static const inkSoft = Color(0xFF55675C);

  // --- Bề mặt kính mờ (giá trị mặc định/fallback) ---
  static const glassFill = Color(0x7AFFFFFF); // trắng ~48% (trong hơn trước)
  static const glassStrong = Color(0xABFFFFFF); // trắng ~67%
  static const glassBorder = Color(0x66FFFFFF); // trắng ~40%

  // --- Kính nhuốm màu cho banner ngày tốt/xấu ---
  static const glassGoodFill = Color(0x666FCF97);
  static const glassGoodBorder = Color(0x99409A6B);
  static const glassBadFill = Color(0x66E08A82);
  static const glassBadBorder = Color(0x99C0392B);

  // --- Kính nhuốm vàng cho card lễ lớn ---
  static const glassGoldFill = Color(0x80E9CF7A);
  static const glassGoldBorder = Color(0x99C9A227);
}

/// Khoảng cách chuẩn (spacing) dùng chung — thay cho các số padding/gap rải
/// rác trong từng màn. Giá trị khớp với cách dùng hiện có (không đổi giao diện).
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  /// Lề ngang mặc định của nội dung màn hình.
  static const double screen = 16;

  /// Padding mặc định bên trong GlassCard.
  static const double card = 18;
}

/// Bo góc chuẩn (radius) dùng chung.
class AppRadius {
  AppRadius._();
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20; // bo góc mặc định của GlassCard
  static const double pill = 999;
}

/// Đặc tả 1 giao diện (theme): ảnh nền + màu chữ-trên-nền + sắc độ thẻ kính
/// + màu thanh điều hướng. Thẻ kính giữ sáng cho mọi theme nên chữ trong thẻ
/// (AppColors.ink/jade...) luôn đọc tốt; chỉ phần nằm TRỰC TIẾP trên nền
/// (tiêu đề mục, AppBar, nav) mới đổi theo theme.
class AppThemeSpec {
  final String id;
  final String name;
  final String bgAsset;
  final bool dark;

  // Chữ/biểu tượng nằm trực tiếp trên nền
  final Color onBg;
  final Color onBgSoft;

  // Thẻ kính mặc định (GlassCard không truyền fill)
  final Color glassFill;
  final Color glassStrong;
  final Color glassBorder;

  // Thanh điều hướng dưới
  final Color navFill;
  final Color navIconSel;
  final Color navIconUnsel;
  final Color navLabel;
  final Color navIndicator;

  const AppThemeSpec({
    required this.id,
    required this.name,
    required this.bgAsset,
    required this.dark,
    required this.onBg,
    required this.onBgSoft,
    required this.glassFill,
    required this.glassStrong,
    required this.glassBorder,
    required this.navFill,
    required this.navIconSel,
    required this.navIconUnsel,
    required this.navLabel,
    required this.navIndicator,
  });
}

// Sắc thẻ kính sáng dùng chung cho các theme nền sáng.
const _lightGlassFill = Color(0x7AFFFFFF); // ~48%
const _lightGlassStrong = Color(0xABFFFFFF); // ~67%
const _lightGlassBorder = Color(0x66FFFFFF);

// Thanh nav sáng (nền sáng).
const _lightNavFill = Color(0xCCFFFFFF);

/// Danh sách 5 theme. Theme[0] = mặc định "Ngọc bích" (nền cũ).
const List<AppThemeSpec> appThemes = [
  AppThemeSpec(
    id: 'ngoc_bich',
    name: 'Ngọc bích',
    bgAsset: 'assets/bg/jade_landscape.jpg',
    dark: false,
    onBg: AppColors.jadeDark,
    onBgSoft: AppColors.inkSoft,
    glassFill: _lightGlassFill,
    glassStrong: _lightGlassStrong,
    glassBorder: _lightGlassBorder,
    navFill: _lightNavFill,
    navIconSel: AppColors.jade,
    navIconUnsel: AppColors.inkSoft,
    navLabel: AppColors.jadeDark,
    navIndicator: Color(0x291E6E4F),
  ),
  AppThemeSpec(
    id: 'sen_ngoc',
    name: 'Sen ngọc',
    bgAsset: 'assets/bg/bg_sen_ngoc.jpg',
    dark: false,
    onBg: AppColors.jadeDark,
    onBgSoft: AppColors.inkSoft,
    glassFill: _lightGlassFill,
    glassStrong: _lightGlassStrong,
    glassBorder: _lightGlassBorder,
    navFill: _lightNavFill,
    navIconSel: AppColors.jade,
    navIconUnsel: AppColors.inkSoft,
    navLabel: AppColors.jadeDark,
    navIndicator: Color(0x291E6E4F),
  ),
  AppThemeSpec(
    id: 'hoang_kim',
    name: 'Hoàng kim',
    bgAsset: 'assets/bg/bg_hoang_kim.jpg',
    dark: false,
    onBg: Color(0xFF5A3A0C), // nâu đậm trên nền vàng
    onBgSoft: Color(0xFF7A5E2A),
    glassFill: Color(0x82FFFFFF), // ~51% (nền vàng rực, cần đậm hơn chút)
    glassStrong: Color(0xB8FFF9EC),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xD6FFF6E2),
    navIconSel: Color(0xFFB8860B),
    navIconUnsel: Color(0xFF8A6A2A),
    navLabel: Color(0xFF5A3A0C),
    navIndicator: Color(0x33B8860B),
  ),
  AppThemeSpec(
    id: 'bach_ngoc',
    name: 'Bạch ngọc',
    bgAsset: 'assets/bg/bg_bach_ngoc.jpg',
    dark: false,
    onBg: AppColors.jadeDark,
    onBgSoft: AppColors.inkSoft,
    glassFill: Color(0x70FFFFFF), // ~44% (nền sáng, có thể trong hơn)
    glassStrong: _lightGlassStrong,
    glassBorder: _lightGlassBorder,
    navFill: _lightNavFill,
    navIconSel: AppColors.jade,
    navIconUnsel: AppColors.inkSoft,
    navLabel: AppColors.jadeDark,
    navIndicator: Color(0x291E6E4F),
  ),
  AppThemeSpec(
    id: 'tu_van',
    name: 'Tử Vân',
    bgAsset: 'assets/bg/bg_tu_van.jpg',
    dark: false,
    onBg: Color(0xFF4A2A6E), // tím hoàng gia đậm trên đỉnh sáng
    onBgSoft: Color(0xFF6E4F92),
    glassFill: Color(0x82FCF8FF), // trắng ánh lilac ~51%
    glassStrong: Color(0xC2F9F3FF),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xD8F3ECFB),
    navIconSel: Color(0xFF7E3FBF), // thạch anh tím
    navIconUnsel: Color(0xFF8F77AC),
    navLabel: Color(0xFF4A2A6E),
    navIndicator: Color(0x337E3FBF),
  ),
  AppThemeSpec(
    id: 'hong_van',
    name: 'Hồng Vân',
    bgAsset: 'assets/bg/bg_hong_van.jpg',
    dark: false,
    onBg: Color(0xFF7A2E47), // hồng mận đậm trên ráng đông
    onBgSoft: Color(0xFF9A586B),
    glassFill: Color(0x82FFFAF6), // trắng ánh ấm ~51%
    glassStrong: Color(0xC2FFF6EF),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xD8FFF1EC),
    navIconSel: Color(0xFFC75C7A), // hồng ngọc
    navIconUnsel: Color(0xFFB08A92),
    navLabel: Color(0xFF7A2E47),
    navIndicator: Color(0x33C75C7A),
  ),
  AppThemeSpec(
    id: 'kim_lien',
    name: 'Kim Liên',
    bgAsset: 'assets/bg/bg_kim_lien.jpg',
    dark: false,
    onBg: Color(0xFF5C3B00),
    onBgSoft: Color(0xFF8A681E),
    glassFill: Color(0x84FFF8E6),
    glassStrong: Color(0xC7FFF4D6),
    glassBorder: Color(0x8CFFFFFF),
    navFill: Color(0xDDFBE8B8),
    navIconSel: Color(0xFFC28A00),
    navIconUnsel: Color(0xFF8B6B2E),
    navLabel: Color(0xFF5C3B00),
    navIndicator: Color(0x38C28A00),
  ),
  AppThemeSpec(
    id: 'truc_lien',
    name: 'Trúc Liên',
    bgAsset: 'assets/bg/bg_truc_lien.jpg',
    dark: false,
    onBg: Color(0xFFEAF6E8),
    onBgSoft: Color(0xFFC7DCCB),
    glassFill: Color(0x92F4FFF7),
    glassStrong: Color(0xCEF7FFF9),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xDC173F31),
    navIconSel: Color(0xFFE7D58C),
    navIconUnsel: Color(0xBFEAF6E8),
    navLabel: Color(0xFFEAF6E8),
    navIndicator: Color(0x38E7D58C),
  ),
  AppThemeSpec(
    id: 'dao_lien',
    name: 'Đào Liên',
    bgAsset: 'assets/bg/bg_dao_lien.jpg',
    dark: false,
    onBg: Color(0xFF7A3149),
    onBgSoft: Color(0xFF9D6574),
    glassFill: Color(0x86FFF7F2),
    glassStrong: Color(0xC7FFF2EC),
    glassBorder: Color(0x8CFFFFFF),
    navFill: Color(0xDDFBE0E4),
    navIconSel: Color(0xFFD05C7B),
    navIconUnsel: Color(0xFFAD7D88),
    navLabel: Color(0xFF7A3149),
    navIndicator: Color(0x38D05C7B),
  ),
  AppThemeSpec(
    id: 'nguyet_lien',
    name: 'Nguyệt Liên',
    bgAsset: 'assets/bg/bg_nguyet_lien.jpg',
    dark: true,
    onBg: Color(0xFFE9F8F0),
    onBgSoft: Color(0xFFC2D8D0),
    glassFill: Color(0x9EF4FBF8),
    glassStrong: Color(0xCAF7FEFB),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xDD0B2A2D),
    navIconSel: Color(0xFFEADFA8),
    navIconUnsel: Color(0xBFE9F8F0),
    navLabel: Color(0xFFE9F8F0),
    navIndicator: Color(0x38EADFA8),
  ),
  AppThemeSpec(
    id: 'bach_hoa',
    name: 'Bạch Hoa',
    bgAsset: 'assets/bg/bg_bach_hoa.jpg',
    dark: false,
    onBg: Color(0xFF4A5A55),
    onBgSoft: Color(0xFF7A8580),
    glassFill: Color(0x72FFFFFF),
    glassStrong: Color(0xB8FFFFFF),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xDDF9F8F3),
    navIconSel: Color(0xFF9C7A1F),
    navIconUnsel: Color(0xFF7A8580),
    navLabel: Color(0xFF4A5A55),
    navIndicator: Color(0x339C7A1F),
  ),
  AppThemeSpec(
    id: 'da_nguyet',
    name: 'Dạ nguyệt',
    bgAsset: 'assets/bg/bg_da_nguyet.jpg',
    dark: true,
    onBg: Color(0xFFEAF4EC), // chữ kem sáng trên nền đêm
    onBgSoft: Color(0xFFB8CFC6),
    glassFill: Color(0x9EF2FAF6), // thẻ sáng hơi đục để chữ tối đọc rõ
    glassStrong: Color(0xCAF4FBF8),
    glassBorder: Color(0x80FFFFFF),
    navFill: Color(0xD60E2A22), // nav tối
    navIconSel: Color(0xFFEAD79A),
    navIconUnsel: Color(0xB3EAF4EC),
    navLabel: Color(0xFFEAF4EC),
    navIndicator: Color(0x33EAD79A),
  ),
];

/// Theme hiện hành + notifier để cả app rebuild khi đổi theme.
final ValueNotifier<AppThemeSpec> appThemeNotifier =
    ValueNotifier<AppThemeSpec>(appThemes.first);

/// Hệ số cỡ chữ toàn app (trợ năng). 1.0 = vừa, 1.18 = lớn, 1.35 = rất lớn.
final ValueNotifier<double> textScaleNotifier = ValueNotifier<double>(1.0);

/// Hiệu ứng kính mờ (BackdropFilter) — tắt để tăng mượt trên máy yếu.
/// Mặc định BẬT (giữ nguyên giao diện hiện tại).
final ValueNotifier<bool> glassEffectNotifier = ValueNotifier<bool>(true);

/// Navigator toàn app — dùng để đẩy màn khóa PIN đè lên bất kỳ màn nào khi
/// app quay lại từ nền (không có BuildContext sẵn ở nơi lắng vòng đời).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppTheme {
  AppTheme._();
  static AppThemeSpec get current => appThemeNotifier.value;

  static AppThemeSpec byId(String id) =>
      appThemes.firstWhere((t) => t.id == id, orElse: () => appThemes.first);
}

/// Chế độ sáng/tối do người dùng chọn.
enum AppThemeMode { system, light, dark }

/// 4 nền SÁNG người dùng chọn được (Dạ nguyệt là nền TỐI, dùng tự động ở chế
/// độ Tối / Hệ thống-tối nên không nằm trong danh sách chọn nền sáng).
const String darkThemeId = 'da_nguyet';
List<AppThemeSpec> get lightThemes =>
    appThemes.where((t) => t.id != darkThemeId).toList();

/// Bộ điều khiển theme: kết hợp chế độ (system/light/dark) + nền sáng đã chọn
/// + độ sáng hệ thống → ra theme hiệu lực (đẩy vào [appThemeNotifier]).
class ThemeController {
  ThemeController._();

  static AppThemeMode mode = AppThemeMode.system;
  static String lightId = 'ngoc_bich';
  static Brightness platformBrightness = Brightness.light;

  static bool get isDarkEffective =>
      mode == AppThemeMode.dark ||
      (mode == AppThemeMode.system && platformBrightness == Brightness.dark);

  /// Tính lại theme hiệu lực và phát cho toàn app.
  static void resolve() {
    appThemeNotifier.value = isDarkEffective
        ? AppTheme.byId(darkThemeId)
        : AppTheme.byId(lightId);
  }

  static void setMode(AppThemeMode m) {
    mode = m;
    resolve();
  }

  static void setLightId(String id) {
    lightId = id;
    resolve();
  }

  static void setPlatformBrightness(Brightness b) {
    if (platformBrightness == b) return;
    platformBrightness = b;
    resolve();
  }

  static String modeLabel(AppThemeMode m) => switch (m) {
    AppThemeMode.system => 'Hệ thống',
    AppThemeMode.light => 'Sáng',
    AppThemeMode.dark => 'Tối',
  };

  static AppThemeMode modeFromString(String? s) => switch (s) {
    'light' => AppThemeMode.light,
    'dark' => AppThemeMode.dark,
    _ => AppThemeMode.system,
  };

  static String modeToString(AppThemeMode m) => m.name;
}

/// Lớp nền cố định của theme — dùng chung cho mọi màn (thay ảnh hard-code).
Widget appBackground() => Positioned.fill(
  child: Image.asset(AppTheme.current.bgAsset, fit: BoxFit.cover),
);

/// Bóng nhẹ cho chữ nằm TRỰC TIẾP trên nền (tiêu đề mục, AppBar). Nền tối →
/// bóng đen tăng tương phản; nền sáng → quầng trắng mảnh để tách khỏi ảnh.
List<Shadow> onBgShadows(AppThemeSpec spec) => spec.dark
    ? const [
        Shadow(color: Color(0xB3000000), blurRadius: 6, offset: Offset(0, 1)),
      ]
    : const [Shadow(color: Color(0xB3FFFFFF), blurRadius: 4)];

/// Chuyển cảnh chung cho mọi route: fade + trượt lên nhẹ (kín đáo, mượt).
class _FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.025),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

ThemeData buildAppTheme(AppThemeSpec spec) {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.jade,
    primary: AppColors.jade,
    secondary: AppColors.gold,
    brightness: Brightness.light,
  ).copyWith(onSurface: AppColors.ink);

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.iOS: _FadeSlidePageTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: spec.onBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: spec.onBg,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        shadows: onBgShadows(spec),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: spec.navFill,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: spec.navIndicator,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: spec.navLabel,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? spec.navIconSel
              : spec.navIconUnsel,
        ),
      ),
    ),
  );
}

/// Giữ tương thích chỗ gọi cũ: trả theme của giao diện hiện hành.
ThemeData buildJadeTheme() => buildAppTheme(AppTheme.current);

/// Thẻ "kính mờ" tái dùng — viên gạch chính của giao diện. Mặc định lấy sắc
/// kính theo theme hiện hành (đổi 1 chỗ áp dụng toàn app).
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? fill;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.radius = AppRadius.lg,
    this.fill,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // Lắng theme để thẻ kính tự đổi sắc NGAY khi đổi giao diện, kể cả khi nằm
    // trong tab đang ẩn (IndexedStack) — không cần widget cha dựng lại.
    return ValueListenableBuilder<AppThemeSpec>(
      valueListenable: appThemeNotifier,
      builder: (context, spec, _) => ValueListenableBuilder<bool>(
        valueListenable: glassEffectNotifier,
        builder: (context, blurOn, _) {
          // Tắt hiệu ứng: bỏ BackdropFilter (mỗi thẻ 1 saveLayer — nặng trên
          // máy yếu), fill mặc định chuyển sang glassStrong đậm hơn cho dễ đọc.
          final box = Container(
            padding: padding,
            decoration: BoxDecoration(
              color: fill ?? (blurOn ? spec.glassFill : spec.glassStrong),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: borderColor ?? spec.glassBorder,
                width: 1,
              ),
            ),
            child: child,
          );
          if (!blurOn) return box;
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: box,
            ),
          );
        },
      ),
    );
  }
}
