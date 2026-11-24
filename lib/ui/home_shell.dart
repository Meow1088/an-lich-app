import 'package:flutter/material.dart';
import '../services/widget_service.dart';
import 'today_screen.dart';
import 'month_screen.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';
import 'tien_ich_screen.dart';
import 'theme.dart';

/// Khung chính của app: nền theme + 5 tab (NavigationBar).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => WidgetService.update());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetService.update();
    }
  }

  static const _titles = [
    'Hôm nay', 'Lịch tháng', 'Tiện ích', 'Nhắc nhở', 'Cài đặt'
  ];

  @override
  Widget build(BuildContext context) {
    // Lắng theme tại đây để đổi giao diện áp dụng NGAY (không cần chuyển tab).
    // MaterialApp cache route home nên build này không tự chạy lại khi đổi
    // theme; ValueListenableBuilder này tự rebuild khi appThemeNotifier đổi.
    return ValueListenableBuilder<AppThemeSpec>(
      valueListenable: appThemeNotifier,
      builder: (context, _, _) => _buildHome(),
    );
  }

  Widget _buildHome() {
    final pages = <Widget>[
      const TodayScreen(),
      const MonthScreen(),
      const TienIchScreen(),
      const RemindersScreen(),
      const SettingsScreen(),
    ];

    return Stack(
      children: [
        // Lớp nền cố định của theme — hiện xuyên qua mọi Scaffold trong suốt.
        appBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text(_titles[_index])),
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.today_outlined),
                  selectedIcon: Icon(Icons.today),
                  label: 'Hôm nay'),
              NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month),
                  label: 'Lịch'),
              NavigationDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: 'Tiện ích'),
              NavigationDestination(
                  icon: Icon(Icons.notifications_outlined),
                  selectedIcon: Icon(Icons.notifications),
                  label: 'Nhắc nhở'),
              NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Cài đặt'),
            ],
          ),
        ),
      ],
    );
  }
}
