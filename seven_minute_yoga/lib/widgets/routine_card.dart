import 'package:flutter/material.dart';

import '../models/yoga_routine.dart';
import '../theme/colors.dart';
import 'animated_button.dart';
import 'time_format.dart';

class RoutineCard extends StatefulWidget {
  const RoutineCard({super.key, required this.routine, required this.onStart});

  final YogaRoutine routine;
  final VoidCallback onStart;

  @override
  State<RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onStart,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.routine.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  widget.routine.description,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Text(
                  '${widget.routine.exercises.length} упражнений · ${formatMinutesShort(widget.routine.totalDuration)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedButton(label: 'Начать', onPressed: widget.onStart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
