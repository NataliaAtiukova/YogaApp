import 'package:flutter/material.dart';

import '../models/exercise.dart';
import 'time_format.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.isCurrent,
    required this.isCompleted,
    required this.remainingSeconds,
    required this.actionLabel,
    required this.onAction,
    required this.actionEnabled,
    required this.onTap,
  });

  final Exercise exercise;
  final bool isCurrent;
  final bool isCompleted;
  final int remainingSeconds;
  final String actionLabel;
  final VoidCallback onAction;
  final bool actionEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isCurrent
        ? theme.colorScheme.primary
        : const Color(0xFFE9E5DD);
    final cardColor = isCurrent ? const Color(0xFFFFFBF4) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: isCurrent ? 2 : 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2EE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3E7E1)),
              ),
              child: Icon(
                exercise.icon,
                color: const Color(0xFF2F6F6D),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          exercise.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F3EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Готово',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF2E6B5B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6E6A65),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          isCurrent
                              ? formatSeconds(remainingSeconds)
                              : formatSeconds(exercise.duration),
                          key: ValueKey(
                            isCurrent ? remainingSeconds : exercise.duration,
                          ),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: actionEnabled ? onAction : null,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(108, 40),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(actionLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
