import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/routine_controller.dart';
import '../models/yoga_routine.dart';
import '../widgets/exercise_coach.dart';
import '../widgets/exercise_tile.dart';
import '../widgets/time_format.dart';
import 'completion_screen.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key, required this.routine});

  final YogaRoutine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<RoutineState>(routineControllerProvider(routine), (
      previous,
      next,
    ) {
      final wasCompleted = previous?.isCompleted ?? false;
      if (!wasCompleted && next.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CompletionScreen(routine: routine),
            ),
          );
        });
      }
    });

    final state = ref.watch(routineControllerProvider(routine));
    final controller = ref.read(routineControllerProvider(routine).notifier);
    final theme = Theme.of(context);
    final currentExercise = routine.exercises[state.currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(routine.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                routine.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6E6A65),
                ),
              ),
              const SizedBox(height: 18),
              ExerciseCoachCard(
                exercise: currentExercise,
                remainingSeconds: state.remainingSeconds,
                isRunning: state.isRunning,
                hasStarted: state.hasStarted,
                manualStepIndex: state.manualStepIndex,
                onStepSelected: controller.setManualStepIndex,
                onAuto: controller.clearManualStepIndex,
                onPrev: controller.previousStep,
                onNext: controller.nextStep,
              ),
              const SizedBox(height: 18),
              Text(
                'Прогресс комплекса',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                tween: Tween<double>(begin: 0, end: state.progress),
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 10,
                      color: theme.colorScheme.primary,
                      backgroundColor: const Color(0xFFEDE8DF),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                '${state.currentIndex + 1} из ${routine.exercises.length} · ${formatMinutesShort(routine.totalDuration)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF8A857F),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: routine.exercises.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final exercise = routine.exercises[index];
                    final isCurrent = index == state.currentIndex;
                    final isCompleted =
                        index < state.currentIndex || state.isCompleted;
                    final isRunning = state.isRunning && isCurrent;
                    final actionLabel = isCurrent
                        ? (isRunning
                              ? 'Пауза'
                              : (state.hasStarted ? 'Продолжить' : 'Старт'))
                        : 'Выбрать';
                    return ExerciseTile(
                      exercise: exercise,
                      isCurrent: isCurrent,
                      isCompleted: isCompleted,
                      remainingSeconds: isCurrent
                          ? state.remainingSeconds
                          : exercise.duration,
                      actionLabel: actionLabel,
                      onAction: isCurrent
                          ? controller.toggle
                          : () => controller.selectExercise(index),
                      actionEnabled: true,
                      onTap: () => controller.selectExercise(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
