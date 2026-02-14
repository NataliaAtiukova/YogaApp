import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/page_transitions.dart';
import '../widgets/animated_button.dart';
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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
                    Text('7 Минут Йоги', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Версия 1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Короткие комплексы для утреннего тонуса, работы в офисе и вечернего расслабления.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              AnimatedButton(
                label: 'Политика конфиденциальности',
                onPressed: () {
                  Navigator.push(
                    context,
                    AppPageRoute.fadeSlide(const PrivacyScreen()),
                  );
                },
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
