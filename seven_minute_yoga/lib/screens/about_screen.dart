import 'package:flutter/material.dart';

import 'privacy_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('О приложении')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/icons/app_icon.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '7 Минут Йоги',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Версия 1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF8A857F),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Короткие комплексы для утреннего тонуса, работы в офисе и вечернего расслабления.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6E6A65),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: () =>
                    Navigator.pushNamed(context, PrivacyScreen.routeName),
                child: const Text('Политика конфиденциальности'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
