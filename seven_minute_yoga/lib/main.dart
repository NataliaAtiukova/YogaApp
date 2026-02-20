import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/about_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/splash_screen.dart';
import 'services/ads_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AdsService.instance.initialize();
  runApp(const ProviderScope(child: SevenMinuteYogaApp()));
}

class SevenMinuteYogaApp extends StatelessWidget {
  const SevenMinuteYogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '7 Минут Йоги',
      theme: AppTheme.lightTheme(),
      home: const SplashScreen(),
      routes: {
        AboutScreen.routeName: (_) => const AboutScreen(),
        PrivacyScreen.routeName: (_) => const PrivacyScreen(),
      },
    );
  }
}
