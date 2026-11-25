import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary & Secondary Brand Colors
  static const Color primaryNavy = Color(0xFF0F172A);
  static const Color secondaryNavy = Color(0xFF1E293B);
  static const Color cardNavy = Color(0xFF1E293B);
  static const Color surfaceNavy = Color(0xFF0B132B);

  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color skyBlueLight = Color(0xFF7DD3FC);
  static const Color skyBlueDark = Color(0xFF0284C7);
  static const Color accentCyan = Color(0xFF06B6D4);

  // Background Gradients
  static const LinearGradient dayGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B192C),
      Color(0xFF1E3E62),
      Color(0xFF000000),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x3338BDF8),
      Color(0x111E293B),
    ],
  );

  // Weather Condition Accents
  static const Color sunnyGold = Color(0xFFFBBF24);
  static const Color rainBlue = Color(0xFF60A5FA);
  static const Color cloudGray = Color(0xFF94A3B8);
  static const Color stormPurple = Color(0xFFA855F7);
  static const Color snowIce = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // UI Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color favoriteRed = Color(0xFFF43F5E);
}
