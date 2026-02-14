import 'package:flutter/material.dart';

import '../models/yoga_routine.dart';
import '../widgets/ad_placeholder.dart';
import 'routine_screen.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key, required this.routine});

  final YogaRoutine routine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Комплекс завершен')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вы молодец',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Комплекс "${routine.title}" выполнен. Подышите спокойно и расслабьтесь.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6E6A65),
                ),
              ),
              const SizedBox(height: 20),
              const AdPlaceholderInterstitial(),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoutineScreen(routine: routine),
                    ),
                  );
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
