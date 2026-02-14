import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/routine_controller.dart';
import '../models/yoga_routine.dart';
import '../theme/colors.dart';
import '../theme/page_transitions.dart';
import '../widgets/animated_button.dart';
import '../widgets/pose_animation.dart';
import '../widgets/time_format.dart';
import 'completion_screen.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key, required this.routine});

  final YogaRoutine routine;

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _animateIn = true);
      ref
          .read(routineControllerProvider(widget.routine).notifier)
          .startOrResume();
    });
  }

  @override
  void dispose() {
    ref.read(routineControllerProvider(widget.routine).notifier).pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RoutineState>(routineControllerProvider(widget.routine), (
      previous,
      next,
    ) {
      final wasCompleted = previous?.isCompleted ?? false;
      if (!wasCompleted && next.isCompleted) {
        HapticFeedback.lightImpact();
        Navigator.of(context).pushReplacement(
          AppPageRoute.fadeSlide(CompletionScreen(routine: widget.routine)),
        );
      }

      if (previous != null && previous.currentIndex != next.currentIndex) {
        if (previous.isRunning) {
          HapticFeedback.lightImpact();
        }
      }
    });

    final state = ref.watch(routineControllerProvider(widget.routine));
    final controller = ref.read(
      routineControllerProvider(widget.routine).notifier,
    );
    final theme = Theme.of(context);
    final exercise = widget.routine.exercises[state.currentIndex];

    final total = exercise.duration;
    final remaining = state.remainingSeconds;
    final progress = total == 0 ? 0.0 : 1 - (remaining / total);

    final steps = exercise.steps;
    final autoStepIndex = _autoStepIndex(
      steps.length,
      total,
      remaining,
      state.hasStarted,
    );
    final stepIndex = state.manualStepIndex ?? autoStepIndex;
    final canPrev = stepIndex > 0;
    final canNext = stepIndex < steps.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Упражнение')),
      body: SafeArea(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          opacity: _animateIn ? 1 : 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            offset: _animateIn ? Offset.zero : const Offset(0, 0.04),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.18,
                          child: PoseAnimator(
                            pose: exercise.pose,
                            isRunning: state.isRunning,
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          tween: Tween<double>(begin: 0, end: progress),
                          builder: (context, value, _) {
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: 10,
                                backgroundColor: const Color(0xFFE6EDF5),
                                color: theme.colorScheme.primary,
                              ),
                            );
                          },
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            formatSeconds(remaining),
                            key: ValueKey(remaining),
                            style: theme.textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.06),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Column(
                      key: ValueKey(exercise.id),
                      children: [
                        Text(
                          exercise.title,
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exercise.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (steps.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: canPrev ? controller.previousStep : null,
                          icon: const Icon(Icons.chevron_left),
                          tooltip: 'Назад',
                        ),
                        ...List.generate(steps.length, (index) {
                          final isActive = index == stepIndex;
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => controller.setManualStepIndex(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 16 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : const Color(0xFFE0E6ED),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }),
                        IconButton(
                          onPressed: canNext ? controller.nextStep : null,
                          icon: const Icon(Icons.chevron_right),
                          tooltip: 'Вперёд',
                        ),
                        if (state.manualStepIndex != null)
                          TextButton(
                            onPressed: controller.clearManualStepIndex,
                            child: const Text('Авто'),
                          ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        steps[stepIndex],
                        key: ValueKey('step-$stepIndex-${exercise.id}'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedButton(
                          label: state.isRunning ? 'Пауза' : 'Продолжить',
                          onPressed: controller.toggle,
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedButton(
                          label: 'Пропустить',
                          onPressed: controller.skip,
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _autoStepIndex(int steps, int total, int remaining, bool started) {
    if (steps == 0 || !started || total == 0) {
      return 0;
    }
    final elapsed = (total - remaining).clamp(0, total);
    final stepDuration = total / steps;
    final index = (elapsed / stepDuration).floor();
    return index.clamp(0, steps - 1);
  }
}
