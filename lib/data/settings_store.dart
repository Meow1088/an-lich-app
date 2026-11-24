import 'package:shared_preferences/shared_preferences.dart';

/// Lưu cài đặt người dùng (hiện tại: ngày sinh cho biorhythm).
class SettingsStore {
  static const _kBirth = 'birth_date';

  Future<DateTime?> getBirthDate() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_kBirth);
    return s == null ? null : DateTime.tryParse(s);
  }

  Future<void> setBirthDate(DateTime d) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kBirth, d.toIso8601String());
  }

  // ---- Giao diện (theme) ----
  static const _kThemeMode = 'theme_mode'; // system | light | dark
  static const _kLightTheme = 'light_theme_id';

  Future<String> getThemeMode() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kThemeMode, v);
  }

  Future<String> getLightThemeId() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kLightTheme) ?? 'ngoc_bich';
  }

  Future<void> setLightThemeId(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLightTheme, v);
  }

  // ---- Cỡ chữ (trợ năng) ----
  static const _kTextScale = 'text_scale'; // 1.0 / 1.18 / 1.35

  Future<double> getTextScale() async {
    final p = await SharedPreferences.getInstance();
    return p.getDouble(_kTextScale) ?? 1.0;
  }

  Future<void> setTextScale(double v) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_kTextScale, v);
  }

  // ---- Hiệu ứng kính mờ (hiệu năng — tắt cho máy yếu) ----
  static const _kGlassEffect = 'glass_effect';

  Future<bool> getGlassEffect() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kGlassEffect) ?? true;
  }

  Future<void> setGlassEffect(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kGlassEffect, v);
  }

  // ---- Hình nền (cũ) ----
  static const _kBgEnabled = 'bg_enabled';
  static const _kBgOpacity = 'bg_opacity';

  Future<bool> getBgEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kBgEnabled) ?? false;
  }

  Future<void> setBgEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kBgEnabled, v);
  }

  /// Độ mờ hình nền 0.05–1.0 (mặc định 0.25).
  Future<double> getBgOpacity() async {
    final p = await SharedPreferences.getInstance();
    return p.getDouble(_kBgOpacity) ?? 0.25;
  }

  Future<void> setBgOpacity(double v) async {
    final p = await SharedPreferences.getInstance();
    await p.setDouble(_kBgOpacity, v);
  }

  // ---- Onboarding lần đầu ----
  static const _kSeenOnboarding = 'seen_onboarding';

  Future<bool> getSeenOnboarding() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kSeenOnboarding) ?? false;
  }

  Future<void> setSeenOnboarding(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSeenOnboarding, v);
  }

  // ---- Khóa PIN mở app (chỉ lưu HASH, không lưu PIN gốc) ----
  static const _kPinHash = 'app_pin_hash';

  /// null = chưa đặt PIN (khóa app đang TẮT).
  Future<String?> getPinHash() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kPinHash);
  }

  /// Truyền null để TẮT khóa PIN (xóa hash đã lưu).
  Future<void> setPinHash(String? hash) async {
    final p = await SharedPreferences.getInstance();
    if (hash == null) {
      await p.remove(_kPinHash);
    } else {
      await p.setString(_kPinHash, hash);
    }
  }

  // ---- Giờ Tý muộn (23h–24h) tính sang ngày hôm sau khi lập lá số ----
  static const _kTyMuon = 'ty_muon_sang_hom_sau';

  Future<bool> getTyMuonSangHomSau() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kTyMuon) ?? false;
  }

  Future<void> setTyMuonSangHomSau(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kTyMuon, v);
  }
}
