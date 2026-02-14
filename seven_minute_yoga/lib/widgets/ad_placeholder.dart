import 'package:flutter/material.dart';

class AdPlaceholderBanner extends StatelessWidget {
  const AdPlaceholderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdContainer(height: 64, label: 'AdMob Banner (placeholder)');
  }
}

class AdPlaceholderInterstitial extends StatelessWidget {
  const AdPlaceholderInterstitial({super.key});

  @override
  Widget build(BuildContext context) {
    return _AdContainer(height: 140, label: 'Interstitial Ad (placeholder)');
  }
}

class _AdContainer extends StatelessWidget {
  const _AdContainer({required this.height, required this.label});

  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0DBD3)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: const Color(0xFF7C7770),
        ),
      ),
    );
  }
}
