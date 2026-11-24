import 'package:flutter/material.dart';
import '../data/settings_store.dart';
import 'theme.dart';
import 'home_shell.dart';

/// Màn giới thiệu lần đầu (4 trang). Lưu cờ seen_onboarding để chỉ hiện 1 lần.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnbItem {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;
  const _OnbItem(this.icon, this.color, this.title, this.desc);
}

const _items = <_OnbItem>[
  _OnbItem(Icons.calendar_month, AppColors.jade, 'Lịch Âm – Dương',
      'Xem ngày âm/dương, can chi, nạp âm, tiết khí, ngày tốt – xấu và giờ hoàng đạo. Tính bằng thuật toán Hồ Ngọc Đức (UTC+7).'),
  _OnbItem(Icons.auto_awesome, AppColors.gold, 'Tử vi & gợi ý mỗi ngày',
      'Lá số Tử vi đẩu số 12 cung kèm luận giải Cơ bản / Chuyên sâu, và tử vi hằng ngày theo hồ sơ của bạn.'),
  _OnbItem(Icons.explore, AppColors.jadeSoft, 'Tiện ích phong thủy',
      'Xem ngày theo việc, xem tuổi làm nhà, bát trạch – la bàn, sao hạn, thần số, hợp tuổi và văn khấn đầy đủ.'),
  _OnbItem(Icons.lock_outline, AppColors.good, 'Riêng tư tuyệt đối',
      'Hoạt động offline 100%. Không quảng cáo, không thu thập dữ liệu cá nhân. Mọi tính toán đều ở trên máy bạn.'),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int _page = 0;

  Future<void> _finish() async {
    await SettingsStore().setSeenOnboarding(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  void _next() {
    if (_page >= _items.length - 1) {
      _finish();
    } else {
      _pc.nextPage(
          duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = AppTheme.current;
    final last = _page == _items.length - 1;
    return Stack(
      children: [
        appBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _finish,
                    child: Text('Bỏ qua',
                        style: TextStyle(color: spec.onBgSoft)),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pc,
                    itemCount: _items.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, i) => _buildPage(_items[i]),
                  ),
                ),
                _dots(spec),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.jade,
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: _next,
                      child: Text(last ? 'Bắt đầu' : 'Tiếp',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dots(AppThemeSpec spec) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_items.length, (i) {
        final on = i == _page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: on ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: on ? AppColors.jade : spec.onBgSoft.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        );
      }),
    );
  }

  Widget _buildPage(_OnbItem it) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              color: it.color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(it.icon, size: 58, color: it.color),
          ),
          const SizedBox(height: AppSpacing.xxl),
          GlassCard(
            child: Column(
              children: [
                Text(
                  it.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.jadeDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  it.desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
