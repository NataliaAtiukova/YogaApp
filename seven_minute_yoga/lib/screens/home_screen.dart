import 'package:flutter/material.dart';

import '../data/yoga_data.dart';
import '../theme/colors.dart';
import '../theme/page_transitions.dart';
import '../widgets/ad_placeholder.dart';
import '../widgets/routine_card.dart';
import 'routine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _animateIn = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      opacity: _animateIn ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        offset: _animateIn ? Offset.zero : const Offset(0, 0.04),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            Text('Добро пожаловать', style: theme.textTheme.displaySmall),
            const SizedBox(height: 6),
            Text(
              'Выберите короткий комплекс на 7 минут.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ...yogaRoutines.map(
              (routine) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RoutineCard(
                  routine: routine,
                  onStart: () {
                    Navigator.push(
                      context,
                      AppPageRoute.fadeSlide(RoutineScreen(routine: routine)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            const AdPlaceholderBanner(),
          ],
        ),
      ),
    );
  }
}
