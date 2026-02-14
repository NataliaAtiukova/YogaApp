import 'package:flutter/material.dart';

import '../data/yoga_data.dart';
import '../models/yoga_routine.dart';
import '../widgets/ad_placeholder.dart';
import '../widgets/routine_card.dart';
import 'about_screen.dart';
import 'routine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YogaRoutine _selectedRoutine;

  @override
  void initState() {
    super.initState();
    _selectedRoutine = yogaRoutines.first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('7 Минут Йоги'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>
                Navigator.pushNamed(context, AboutScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Выберите комплекс',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: yogaRoutines.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final routine = yogaRoutines[index];
                    return RoutineCard(
                      routine: routine,
                      isSelected: routine.id == _selectedRoutine.id,
                      onTap: () => setState(() => _selectedRoutine = routine),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoutineScreen(routine: _selectedRoutine),
                    ),
                  );
                },
                child: const Text('Начать'),
              ),
              const SizedBox(height: 12),
              const AdPlaceholderBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
