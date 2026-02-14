import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/stats_service.dart';
import '../theme/colors.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
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
    final summaryAsync = ref.watch(statsSummaryProvider);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      opacity: _animateIn ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        offset: _animateIn ? Offset.zero : const Offset(0, 0.04),
        child: summaryAsync.when(
          data: (summary) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              physics: const BouncingScrollPhysics(),
              children: [
                _StatGrid(summary: summary),
                const SizedBox(height: 20),
                Text('Последние 7 дней', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _StatsChart(days: summary.last7Days),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Не удалось загрузить статистику',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.summary});

  final StatsSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Дней занятий',
                value: summary.totalDays.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Комплексов',
                value: summary.totalSessions.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Калории',
                value: summary.totalCalories.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(label: 'Серия', value: '${summary.streak} дн'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              value,
              key: ValueKey(value),
              style: theme.textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsChart extends StatefulWidget {
  const _StatsChart({required this.days});

  final List<DailyStat> days;

  @override
  State<_StatsChart> createState() => _StatsChartState();
}

class _StatsChartState extends State<_StatsChart> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxMinutes = widget.days.fold<int>(
      0,
      (max, day) => day.minutes > max ? day.minutes : max,
    );
    final scale = maxMinutes == 0 ? 1 : maxMinutes;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widget.days.map((day) {
          final height = (day.minutes / scale) * 120;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  height: _animate ? height : 0,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _weekdayLabel(day.date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _weekdayLabel(DateTime date) {
    const labels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return labels[date.weekday - 1];
  }
}
