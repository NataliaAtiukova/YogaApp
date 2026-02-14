import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/page_transitions.dart';
import 'about_screen.dart';
import 'home_screen.dart';
import 'stats_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  double _opacity = 1;

  void _onTap(int index) {
    if (index == _index) return;
    setState(() => _opacity = 0);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      setState(() {
        _index = index;
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _index == 0 ? '7 Минут Йоги' : 'Статистика';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _index == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      AppPageRoute.fadeSlide(const AboutScreen()),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        opacity: _opacity,
        child: IndexedStack(
          index: _index,
          children: const [HomeScreen(), StatsScreen()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
        backgroundColor: Colors.white,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
        ],
      ),
    );
  }
}
