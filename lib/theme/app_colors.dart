import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF060912);
  static const Color surface = Color(0xFF0D1117);
  static const Color card = Color(0xFF131B2E);
  static const Color cardBorder = Color(0xFF1E2D4E);

  // Brand
  static const Color primary = Color(0xFF00F5FF); // Cyan
  static const Color secondary = Color(0xFF7C3AED); // Purple
  static const Color accent = Color(0xFFFF2D78); // Pink/Magenta
  static const Color success = Color(0xFF00FF8C); // Green
  static const Color warning = Color(0xFFFFB800); // Amber

  // Text
  static const Color textPrimary = Color(0xFFE8EAED);
  static const Color textSecondary = Color(0xFF8892B0);
  static const Color textMuted = Color(0xFF4A5568);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F5FF), Color(0xFF0066FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFFF2D78)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF131B2E), Color(0xFF0D1117)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
