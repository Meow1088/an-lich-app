import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/biorhythm.dart';
import '../data/settings_store.dart';
import 'patterns/app_scaffold.dart';
import 'theme.dart';

const _maxYears = 100; // phạm vi thang năm: năm sinh .. +100 năm (101 năm)
const _pxPerDay = 12.0; // độ "giãn" của biểu đồ (px mỗi ngày) để thấy rõ sóng
const _chartHeight = 250.0;

class BiorhythmScreen extends StatefulWidget {
  const BiorhythmScreen({super.key});

  @override
  State<BiorhythmScreen> createState() => _BiorhythmScreenState();
}

class _BiorhythmScreenState extends State<BiorhythmScreen> {
  final _store = SettingsStore();
  final _hscroll = ScrollController();
  DateTime? _birth;
  bool _loading = true;

  bool _byMonth = false; // false = Theo năm (mặc định), true = Theo tháng
  int _year = 0; // năm đang xem (thang năm)
  int _month = 1; // tháng đang xem (thang tháng), trong năm hiện tại
  int _todayYear = 0;
  bool _needScroll = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _hscroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final b = await _store.getBirthDate();
    final today = DateTime.now();
    _todayYear = today.year;
    if (b != null) {
      _year = today.year.clamp(b.year, b.year + _maxYears);
      _month = today.month;
    }
    setState(() {
      _birth = b;
      _loading = false;
    });
  }

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(now.year - 25, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Chọn ngày sinh',
    );
    if (picked != null) {
      await _store.setBirthDate(picked);
      setState(() {
        _birth = picked;
        _year = now.year.clamp(picked.year, picked.year + _maxYears);
        _month = now.month;
        _needScroll = true;
      });
    }
  }

  void _setMode(bool byMonth) {
    if (byMonth == _byMonth) return;
    setState(() {
      _byMonth = byMonth;
      _needScroll = true;
    });
  }

  void _shift(int delta) {
    setState(() {
      if (_byMonth) {
        _month = (_month + delta).clamp(1, 12);
      } else {
        _year = (_year + delta).clamp(_birth!.year, _birth!.year + _maxYears);
      }
      _needScroll = true;
    });
  }

  bool get _canPrev => _byMonth ? _month > 1 : _year > _birth!.year;
  bool get _canNext =>
      _byMonth ? _month < 12 : _year < _birth!.year + _maxYears;

  ({DateTime start, int len, String label}) _window() {
    if (_byMonth) {
      final start = DateTime(_todayYear, _month, 1);
      final len = DateTime(_todayYear, _month + 1, 0).day;
      return (start: start, len: len, label: 'Tháng $_month/$_todayYear');
    }
    final start = DateTime(_year, 1, 1);
    final len = DateTime(_year + 1, 1, 1).difference(start).inDays;
    return (start: start, len: len, label: 'Năm $_year');
  }

  void _autoScroll(double chartW, double cardW, DateTime start, int len) {
    if (!_needScroll) return;
    _needScroll = false;
    if (!_hscroll.hasClients) return;
    final off = daysSinceBirth(start, DateTime.now());
    var target = 0.0;
    if (off >= 0 && off < len) target = off * _pxPerDay - cardW / 2;
    final maxOff = math.max(0.0, chartW - cardW);
    _hscroll.jumpTo(target.clamp(0.0, maxOff));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: 'Nhịp Sinh Học', body: _body(context));
  }

  Widget _body(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_birth == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cake, size: 56, color: AppColors.inkSoft),
            const SizedBox(height: 12),
            const Text('Nhập ngày sinh để xem đồ thị nhịp sinh học',
                style: TextStyle(color: AppColors.ink)),
            const SizedBox(height: 12),
            FilledButton.icon(
                onPressed: _pickBirth,
                icon: const Icon(Icons.edit_calendar),
                label: const Text('Chọn ngày sinh')),
          ],
        ),
      );
    }

    final today = DateTime.now();
    final days = daysSinceBirth(_birth!, today);
    final win = _window();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: ListTile(
            leading: const Icon(Icons.cake, color: AppColors.jade),
            title: Text(
                'Ngày sinh: ${_birth!.day}/${_birth!.month}/${_birth!.year}',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.ink)),
            subtitle: Text('Đã sống $days ngày',
                style: const TextStyle(color: AppColors.inkSoft)),
            trailing:
                TextButton(onPressed: _pickBirth, child: const Text('Đổi')),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text('Theo năm')),
              ButtonSegment(value: true, label: Text('Theo tháng')),
            ],
            selected: {_byMonth},
            onSelectionChanged: (s) => _setMode(s.first),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              color: AppColors.jadeDark,
              onPressed: _canPrev ? () => _shift(-1) : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(win.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.jadeDark)),
            ),
            IconButton(
              color: AppColors.jadeDark,
              onPressed: _canNext ? () => _shift(1) : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 4),
        GlassCard(
          child: LayoutBuilder(
            builder: (ctx, c) {
              final cardW = c.maxWidth;
              final chartW = math.max(cardW, win.len * _pxPerDay);
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _autoScroll(chartW, cardW, win.start, win.len));
              return SizedBox(
                height: _chartHeight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _hscroll,
                  child: SizedBox(
                      width: chartW,
                      height: _chartHeight,
                      child: _chart(win)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text('Vuốt trái/phải để xem trọn chu kỳ · ◄ ► đổi mốc',
              style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
        ),
        const SizedBox(height: 16),
        const Text('Giải thích 3 nhịp sinh học',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.jadeDark)),
        const SizedBox(height: 10),
        for (final cat in _cats)
          _CatCard(cat: cat, birth: _birth!, today: today),
      ],
    );
  }

  Widget _chart(({DateTime start, int len, String label}) win) {
    final maxX = (win.len - 1).toDouble();
    final todayOffset = daysSinceBirth(win.start, DateTime.now());
    final hasToday = todayOffset >= 0 && todayOffset < win.len;

    List<FlSpot> spots(int period) => [
          for (var d = 0; d < win.len; d++)
            FlSpot(d.toDouble(),
                cycleValue(_birth!, win.start.add(Duration(days: d)), period)),
        ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 12, 4),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX,
          minY: -1.1,
          maxY: 1.1,
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 22,
                getTitlesWidget: (v, _) {
                  final date = win.start.add(Duration(days: v.toInt()));
                  // Theo tháng: vạch theo ngày (1,5,10,15,20,25).
                  // Theo năm: vạch theo tháng (T1..T12) tại đầu mỗi tháng.
                  final show = _byMonth
                      ? (date.day == 1 || date.day % 5 == 0)
                      : date.day == 1;
                  if (!show) return const SizedBox.shrink();
                  final label = _byMonth ? '${date.day}' : 'T${date.month}';
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(label,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.inkSoft)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(verticalLines: [
            if (hasToday)
              VerticalLine(
                x: todayOffset.toDouble(),
                color: AppColors.jadeDark,
                strokeWidth: 2,
                dashArray: [5, 3],
                label: VerticalLineLabel(
                  show: true,
                  alignment: Alignment.topCenter,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.jadeDark,
                      fontWeight: FontWeight.bold),
                  labelResolver: (_) => 'Nay',
                ),
              ),
          ]),
          lineBarsData: [
            _bar(spots(physicalPeriod), _cats[0].color),
            _bar(spots(emotionalPeriod), _cats[1].color),
            _bar(spots(intellectualPeriod), _cats[2].color),
          ],
        ),
      ),
    );
  }

  LineChartBarData _bar(List<FlSpot> spots, Color color) => LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 2.4,
        dotData: const FlDotData(show: false),
      );
}

/// Mô tả một nhịp sinh học.
class _Cat {
  final String name;
  final int period;
  final Color color;
  final String meaning; // ý nghĩa chung
  final String high; // lời khuyên khi cao
  final String low; // lời khuyên khi thấp
  const _Cat(
      this.name, this.period, this.color, this.meaning, this.high, this.low);
}

const _cats = <_Cat>[
  _Cat(
      'Thể chất',
      physicalPeriod,
      Color(0xFFE53935),
      'Sức lực, thể trạng và sức bền của cơ thể.',
      'Cơ thể sung sức — hợp tập luyện, thi đấu, làm việc nặng.',
      'Dễ mệt, sức đề kháng yếu — nên nghỉ ngơi và giữ sức.'),
  _Cat(
      'Cảm xúc',
      emotionalPeriod,
      Color(0xFF1E88E5),
      'Tâm trạng, tình cảm, sự nhạy cảm và cảm hứng sáng tạo.',
      'Tinh thần phấn chấn — hợp gặp gỡ, giao tiếp, việc sáng tạo.',
      'Dễ cáu gắt, nhạy cảm — tránh quyết định lúc nóng giận.'),
  _Cat(
      'Trí tuệ',
      intellectualPeriod,
      Color(0xFF43A047),
      'Khả năng tư duy, tập trung, ghi nhớ và ra quyết định.',
      'Đầu óc minh mẫn — hợp học tập, tính toán, ký kết quan trọng.',
      'Khó tập trung — nên hoãn các quyết định lớn nếu có thể.'),
];

class _CatCard extends StatelessWidget {
  final _Cat cat;
  final DateTime birth;
  final DateTime today;
  const _CatCard(
      {required this.cat, required this.birth, required this.today});

  @override
  Widget build(BuildContext context) {
    final v = cycleValue(birth, today, cat.period);
    final vTomorrow =
        cycleValue(birth, today.add(const Duration(days: 1)), cat.period);
    final slope = vTomorrow - v;
    final pct = (v * 100).round();
    final critical = v.abs() < 0.15;
    final phase = _phase(v, slope, critical);
    final advice = critical
        ? 'Ngày chuyển pha — nên thận trọng, tránh việc gắng sức/áp lực cao.'
        : (v >= 0 ? cat.high : cat.low);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        radius: 16,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                        color: cat.color,
                        borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: 8),
                Text('${cat.name} (${cat.period} ngày)',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.ink)),
                const Spacer(),
                Text('$pct%',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: v >= 0 ? AppColors.good : AppColors.bad)),
              ],
            ),
            const SizedBox(height: 4),
            Text(phase,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: v >= 0 ? AppColors.good : AppColors.bad)),
            const SizedBox(height: 6),
            Text(cat.meaning,
                style: const TextStyle(fontSize: 13, color: AppColors.inkSoft)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.tips_and_updates_outlined,
                    size: 16, color: AppColors.gold),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(advice,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.ink)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _phase(double v, double slope, bool critical) {
    if (critical) return 'Ngày tới hạn (đang đổi pha)';
    if (v >= 0.9) return 'Đỉnh cao của chu kỳ';
    if (v <= -0.9) return 'Đáy của chu kỳ';
    if (v > 0) return slope >= 0 ? 'Cao · đang lên' : 'Cao · đang xuống';
    return slope >= 0 ? 'Thấp · đang lên' : 'Thấp · đang xuống';
  }
}
