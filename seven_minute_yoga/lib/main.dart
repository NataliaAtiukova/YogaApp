import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/about_screen.dart';
import 'screens/home_screen.dart';
import 'screens/privacy_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: SevenMinuteYogaApp()));
}

class SevenMinuteYogaApp extends StatelessWidget {
  const SevenMinuteYogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.manropeTextTheme(baseTheme.textTheme).apply(
      bodyColor: const Color(0xFF1F1F1F),
      displayColor: const Color(0xFF1F1F1F),
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2F6F6D),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '7 Минут Йоги',
      theme: baseTheme.copyWith(
        colorScheme: colorScheme,
        textTheme: textTheme,
        scaffoldBackgroundColor: const Color(0xFFF8F6F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.zero,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      routes: {
        AboutScreen.routeName: (_) => const AboutScreen(),
        PrivacyScreen.routeName: (_) => const PrivacyScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
