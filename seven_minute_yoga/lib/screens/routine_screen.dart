import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/routine_controller.dart';
import '../models/yoga_routine.dart';
import '../theme/colors.dart';
import '../theme/page_transitions.dart';
import '../widgets/exercise_tile.dart';
import '../widgets/time_format.dart';
import 'exercise_screen.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key, required this.routine});

  final YogaRoutine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routineControllerProvider(routine));
    final controller = ref.read(routineControllerProvider(routine).notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(routine.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              routine.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Text('Прогресс комплекса', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: state.progress),
              builder: (context, value, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    color: theme.colorScheme.primary,
                    backgroundColor: const Color(0xFFE6EDF5),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              '${state.currentIndex + 1} из ${routine.exercises.length} · ${formatMinutesShort(routine.totalDuration)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(routine.exercises.length, (index) {
              final exercise = routine.exercises[index];
              final isCurrent = index == state.currentIndex;
              final isCompleted =
                  index < state.currentIndex || state.isCompleted;
              final isRunning = state.isRunning && isCurrent;
              final actionLabel = isCurrent
                  ? (isRunning
                        ? 'Пауза'
                        : (state.hasStarted ? 'Продолжить' : 'Начать'))
                  : 'Открыть';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExerciseTile(
                  exercise: exercise,
                  isCurrent: isCurrent,
                  isCompleted: isCompleted,
                  remainingSeconds: isCurrent
                      ? state.remainingSeconds
                      : exercise.duration,
                  actionLabel: actionLabel,
                  onAction: () {
                    controller.selectExercise(index);
                    Navigator.push(
                      context,
                      AppPageRoute.fadeSlide(ExerciseScreen(routine: routine)),
                    );
                  },
                  actionEnabled: true,
                  onTap: () {
                    controller.selectExercise(index);
                    Navigator.push(
                      context,
                      AppPageRoute.fadeSlide(ExerciseScreen(routine: routine)),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
