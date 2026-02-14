import 'package:flutter/material.dart';

import '../models/yoga_routine.dart';
import 'time_format.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    required this.isSelected,
    required this.onTap,
  });

  final YogaRoutine routine;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? accent : const Color(0xFFE3E0D8),
              width: isSelected ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? accent.withValues(alpha: 0.15)
                      : const Color(0xFFF2EFEA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.self_improvement,
                  color: isSelected ? accent : const Color(0xFF6E6A65),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      routine.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6E6A65),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${routine.exercises.length} упражнений · ${formatMinutesShort(routine.totalDuration)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF8A857F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
