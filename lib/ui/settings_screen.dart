import 'package:flutter/material.dart';
import '../data/settings_store.dart';
import '../services/widget_service.dart';
import 'backup_screen.dart';
import 'pin_screen.dart';
import 'theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  final _store = SettingsStore();
  AppThemeMode _mode = ThemeController.mode;
  String _lightId = ThemeController.lightId;
  double _textScale = textScaleNotifier.value;
  bool _glassOn = glassEffectNotifier.value;
  bool? _pinEnabled; // null = đang tải
  bool _tyMuon = false;
  bool? _batteryOk; // null = không áp dụng/không đọc được -> ẩn ô

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBatteryState();
    _loadPinState();
    _store.getTyMuonSangHomSau().then((v) {
      if (mounted) setState(() => _tyMuon = v);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadBatteryState();
  }

  Future<void> _loadBatteryState() async {
    final ok = await WidgetService.isBatteryUnrestricted();
    if (mounted) setState(() => _batteryOk = ok);
  }

  Future<void> _loadPinState() async {
    final hash = await _store.getPinHash();
    if (mounted) setState(() => _pinEnabled = hash != null);
  }

  /// Bắt nhập đúng PIN hiện tại trước khi cho đổi/tắt (không cho hủy ngang).
  Future<bool> _verifyCurrentPin() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (ctx) => PinLockScreen(
          allowCancel: true,
          onUnlocked: () => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    return ok ?? false;
  }

  Future<void> _managePin() async {
    if (_pinEnabled != true) {
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PinSetupScreen()),
      );
      if (ok == true) _loadPinState();
      return;
    }
    final verified = await _verifyCurrentPin();
    if (!verified || !mounted) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.password, color: AppColors.jade),
              title: const Text('Đổi PIN'),
              onTap: () => Navigator.of(ctx).pop('change'),
            ),
            ListTile(
              leading: const Icon(Icons.lock_open, color: AppColors.bad),
              title: const Text('Tắt khóa PIN'),
              onTap: () => Navigator.of(ctx).pop('disable'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'change') {
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PinSetupScreen()),
      );
      if (ok == true) _loadPinState();
    } else if (action == 'disable') {
      await _store.setPinHash(null);
      _loadPinState();
    }
  }

  Future<void> _setTextScale(double v) async {
    setState(() => _textScale = v);
    textScaleNotifier.value = v;
    await _store.setTextScale(v);
  }

  Future<void> _setGlass(bool v) async {
    setState(() => _glassOn = v);
    glassEffectNotifier.value = v;
    await _store.setGlassEffect(v);
  }

  Future<void> _setTyMuon(bool v) async {
    setState(() => _tyMuon = v);
    await _store.setTyMuonSangHomSau(v);
  }

  Future<void> _setMode(AppThemeMode m) async {
    setState(() => _mode = m);
    ThemeController.setMode(m);
    await _store.setThemeMode(ThemeController.modeToString(m));
  }

  Future<void> _setLight(String id) async {
    setState(() => _lightId = id);
    ThemeController.setLightId(id);
    await _store.setLightThemeId(id);
  }

  @override
  Widget build(BuildContext context) {
    final onBg = AppTheme.current.onBg;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      children: [
        _SectionTitle('Giao diện', Icons.palette_outlined),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ModeControl(selected: _mode, onChanged: _setMode),
              const SizedBox(height: 14),
              const Text(
                'Nền',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 106,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: lightThemes.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final t = lightThemes[i];
                    return _ThemeThumb(
                      spec: t,
                      selected: _lightId == t.id,
                      onTap: () => _setLight(t.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionTitle('Đọc & hiệu năng', Icons.tune),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              _InlineControlTile(
                icon: Icons.format_size,
                title: 'Cỡ chữ',
                child: SegmentedButton<double>(
                  segments: const [
                    ButtonSegment(value: 1.0, label: Text('Vừa')),
                    ButtonSegment(value: 1.18, label: Text('Lớn')),
                    ButtonSegment(value: 1.35, label: Text('Rất lớn')),
                  ],
                  selected: {_textScale},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => _setTextScale(s.first),
                  style: _compactSegmentStyle(),
                ),
              ),
              const Divider(
                height: 1,
                indent: 56,
                color: AppColors.glassBorder,
              ),
              SwitchListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                value: _glassOn,
                onChanged: _setGlass,
                secondary: const Icon(Icons.blur_on, color: AppColors.jade),
                title: const Text(
                  'Hiệu ứng kính mờ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                subtitle: const Text(
                  'Tắt nếu máy cuộn không mượt.',
                  style: TextStyle(color: AppColors.inkSoft),
                ),
                activeThumbColor: AppColors.jade,
              ),
              const Divider(
                height: 1,
                indent: 56,
                color: AppColors.glassBorder,
              ),
              SwitchListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                value: _tyMuon,
                onChanged: _setTyMuon,
                secondary:
                    const Icon(Icons.nights_stay_outlined, color: AppColors.jade),
                title: const Text(
                  'Giờ Tý muộn tính sang ngày sau',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                subtitle: const Text(
                  'Sinh 23h–24h: lập lá số theo ngày hôm sau (mặc định: ngày hiện tại).',
                  style: TextStyle(color: AppColors.inkSoft),
                ),
                activeThumbColor: AppColors.jade,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionTitle('Dữ liệu', Icons.folder_copy_outlined),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _SettingsTile(
            icon: Icons.backup_outlined,
            title: 'Sao lưu & khôi phục',
            subtitle: 'Xuất/nhập hồ sơ, nhắc nhở và giao diện.',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const BackupScreen())),
          ),
        ),
        const SizedBox(height: 12),
        _SectionTitle('Bảo mật', Icons.shield_outlined),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Khóa PIN khi mở app',
            subtitle: _pinEnabled == null
                ? 'Đang tải…'
                : (_pinEnabled == true
                      ? 'Đang bật — chạm để đổi hoặc tắt.'
                      : 'Chưa đặt — chạm để bật khóa app.'),
            onTap: _pinEnabled == null ? () {} : _managePin,
          ),
        ),
        const SizedBox(height: 12),
        _SectionTitle('Ứng dụng', Icons.info_outline),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              const _InfoTile(
                icon: Icons.lock_outline,
                title: 'Riêng tư offline',
                subtitle:
                    'Không quảng cáo, không analytics, dữ liệu lưu trên máy.',
              ),
              const Divider(
                height: 1,
                indent: 56,
                color: AppColors.glassBorder,
              ),
              const _InfoTile(
                icon: Icons.notifications_active_outlined,
                title: 'Nhắc nhở âm lịch',
                subtitle: 'Tự tính lại ngày dương mỗi năm.',
              ),
              const Divider(
                height: 1,
                indent: 56,
                color: AppColors.glassBorder,
              ),
              const _InfoTile(
                icon: Icons.widgets_outlined,
                title: 'Widget Android',
                subtitle: 'Widget 4x2; iOS widget sẽ làm ở phase riêng.',
              ),
              if (_batteryOk != null) ...[
                const Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.glassBorder,
                ),
                _SettingsTile(
                  icon: Icons.battery_saver_outlined,
                  title: 'Widget tự đổi ngày',
                  subtitle: _batteryOk == true
                      ? 'Đã cho chạy nền — widget tự đổi ngày.'
                      : 'Samsung có thể cho app ngủ khiến widget đứng ngày. Chạm để mở cài đặt: Pin → Không hạn chế.',
                  onTap: WidgetService.openAppBatterySettings,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            'An Lịch - Offline - v1.1.0',
            style: TextStyle(color: onBg.withValues(alpha: 0.72), fontSize: 12),
          ),
        ),
      ],
    );
  }
}

ButtonStyle _compactSegmentStyle() {
  return ButtonStyle(
    visualDensity: VisualDensity.compact,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.jade
          : AppColors.inkSoft,
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final IconData icon;

  const _SectionTitle(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    final spec = AppTheme.current;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 2, 8),
      child: Row(
        children: [
          Icon(icon, color: spec.onBg, size: 18, shadows: onBgShadows(spec)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: spec.onBg,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              shadows: onBgShadows(spec),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeControl extends StatelessWidget {
  final AppThemeMode selected;
  final ValueChanged<AppThemeMode> onChanged;

  const _ModeControl({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Chế độ',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
          ),
        ),
        SegmentedButton<AppThemeMode>(
          segments: const [
            ButtonSegment(
              value: AppThemeMode.system,
              icon: Icon(Icons.brightness_auto, size: 18),
            ),
            ButtonSegment(
              value: AppThemeMode.light,
              icon: Icon(Icons.light_mode, size: 18),
            ),
            ButtonSegment(
              value: AppThemeMode.dark,
              icon: Icon(Icons.dark_mode, size: 18),
            ),
          ],
          selected: {selected},
          showSelectedIcon: false,
          onSelectionChanged: (s) => onChanged(s.first),
          style: _compactSegmentStyle(),
        ),
      ],
    );
  }
}

class _ThemeThumb extends StatelessWidget {
  final AppThemeSpec spec;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeThumb({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.jade : Colors.white70,
                  width: selected ? 2.5 : 1,
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: AppColors.jade.withValues(alpha: 0.34),
                      blurRadius: 8,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9.5),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(spec.bgAsset, fit: BoxFit.cover),
                    if (selected)
                      Container(
                        color: AppColors.jade.withValues(alpha: 0.18),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              spec.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineControlTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InlineControlTile({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.jade),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.jade),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.inkSoft),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.inkSoft),
      onTap: onTap,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.jade),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.inkSoft),
      ),
    );
  }
}
