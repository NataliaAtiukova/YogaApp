import 'package:flutter/material.dart';

import '../theme/colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Политика конфиденциальности')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Text(
            'Мы не собираем и не передаем персональные данные. '
            'Все упражнения и прогресс хранятся локально на устройстве. '
            'Рекламные блоки пока не активны и представлены заглушками.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
