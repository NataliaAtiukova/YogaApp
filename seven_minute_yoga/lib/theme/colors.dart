import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF7FAFC);
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF2F6F6D);
  static const Color primarySoft = Color(0xFFEEF5F4);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE6ECF2);
  static const Color shadow = Color(0x1A1F2937);

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFF7FAFC), Color(0xFFE6F0FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFEFF4FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
