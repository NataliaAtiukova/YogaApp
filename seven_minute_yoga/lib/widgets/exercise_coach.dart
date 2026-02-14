import 'package:flutter/material.dart';

import '../models/exercise.dart';
import 'pose_animation.dart';
import 'time_format.dart';

class ExerciseCoachCard extends StatelessWidget {
  const ExerciseCoachCard({
    super.key,
    required this.exercise,
    required this.remainingSeconds,
    required this.isRunning,
    required this.hasStarted,
    required this.manualStepIndex,
    required this.onStepSelected,
    required this.onAuto,
    required this.onPrev,
    required this.onNext,
  });

  final Exercise exercise;
  final int remainingSeconds;
  final bool isRunning;
  final bool hasStarted;
  final int? manualStepIndex;
  final ValueChanged<int> onStepSelected;
  final VoidCallback onAuto;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = exercise.steps;
    final total = exercise.duration;
    final elapsed = (total - remainingSeconds).clamp(0, total);
    final int autoStepIndex = _stepIndex(
      steps.length,
      total,
      elapsed,
      hasStarted,
    );
    final int stepIndex = manualStepIndex ?? autoStepIndex;
    final bool canGoPrev = stepIndex > 0;
    final bool canGoNext = stepIndex < steps.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6E1DA)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFF3F2EE),
                            const Color(0xFFEFF4F1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: PoseAnimator(
                          pose: exercise.pose,
                          isRunning: isRunning,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hasStarted
                        ? formatSeconds(remainingSeconds)
                        : formatSeconds(exercise.duration),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasStarted ? 'Идет выполнение' : 'Нажмите «Старт» ниже',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF8A857F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: canGoPrev ? onPrev : null,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Назад',
              ),
              ...List.generate(steps.length, (index) {
                final isActive = index == stepIndex;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onStepSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    width: isActive ? 18 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.colorScheme.primary
                          : const Color(0xFFE0DBD3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
              IconButton(
                onPressed: canGoNext ? onNext : null,
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Вперёд',
              ),
              if (manualStepIndex != null) ...[
                const Spacer(),
                TextButton(onPressed: onAuto, child: const Text('Авто')),
              ],
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              steps.isEmpty ? '' : steps[stepIndex],
              key: ValueKey('step-$stepIndex-${exercise.id}'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6E6A65),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _stepIndex(int steps, int total, int elapsed, bool hasStarted) {
    if (steps == 0) {
      return 0;
    }
    if (!hasStarted || total == 0) {
      return 0;
    }
    final stepDuration = total / steps;
    final index = (elapsed / stepDuration).floor();
    return index.clamp(0, steps - 1);
  }
}
