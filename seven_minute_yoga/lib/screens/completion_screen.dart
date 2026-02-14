import 'package:flutter/material.dart';

import '../models/yoga_routine.dart';
import '../theme/colors.dart';
import '../theme/page_transitions.dart';
import '../widgets/ad_placeholder.dart';
import '../widgets/animated_button.dart';
import 'exercise_screen.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key, required this.routine});

  final YogaRoutine routine;

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _showContent = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Комплекс завершен')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F4EF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD3EADD)),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF2E6B5B),
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                opacity: _showContent ? 1 : 0,
                child: Column(
                  children: [
                    Text(
                      'Вы молодец!',
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '7 минут для себя сделаны.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const AdPlaceholderInterstitial(),
              const Spacer(),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                opacity: _showContent ? 1 : 0,
                child: AnimatedButton(
                  label: 'Повторить',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      AppPageRoute.fadeSlide(
                        ExerciseScreen(routine: widget.routine),
                      ),
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
