import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../theme/colors.dart';
import 'animated_button.dart';
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
        : const Color(0xFFE4EAF1);
    final cardColor = isCurrent ? const Color(0xFFFDFEFE) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: isCurrent ? 1.6 : 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(exercise.icon, color: AppColors.primary, size: 28),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
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
                            color: const Color(0xFFE7F4EF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Готово',
                            style: theme.textTheme.bodyMedium?.copyWith(
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 120,
                        child: AnimatedButton(
                          label: actionLabel,
                          onPressed: actionEnabled ? onAction : () {},
                        ),
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
