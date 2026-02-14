import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool fullWidth;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = widget.isPrimary ? AppColors.primary : AppColors.surface;
    final foreground = widget.isPrimary ? Colors.white : AppColors.primary;
    final border = widget.isPrimary ? Colors.transparent : AppColors.border;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onPressed,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: widget.fullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border),
              boxShadow: widget.isPrimary
                  ? [
                      const BoxShadow(
                        color: Color(0x1F2F6F6D),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}
