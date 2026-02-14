import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Text(
            'Мы не собираем и не передаем персональные данные. '
            'Все упражнения и прогресс хранятся локально на устройстве. '
            'Рекламные блоки пока не активны и представлены заглушками.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF6E6A65),
            ),
          ),
        ),
      ),
    );
  }
}
