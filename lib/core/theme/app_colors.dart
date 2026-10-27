import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- AstroVedham Master Brand Theme (Sacred Emerald & Gold) ---
  static const Color primaryGreen = Color(0xFF064E3B);
  static const Color sacredGold = Color(0xFFD97706);
  static const Color cardSurface = Color(0xFF0F766E);
  static const Color sheetBackground = Color(0xFFECFDF5);

  // --- Accents & Functional ---
  static const Color orangeLight = Color(0xFFFFF3E0);
  static const Color orangeDark = Color(0xFFB23C00);
  static const Color accentGold = Color(0xFFFFB300);

  static const Color greenAuspicious = Color(0xFF2E7D32);
  static const Color redInauspicious = Color(0xFFC62828);
  static const Color blueText = Color(0xFF1565C0);

  static const Color successGreen = Color(0xFF10B981);
  static const Color alertRed = Color(0xFFDC2626);

  // --- Text Colors (Light) ---
  static const Color primaryText = Color(0xFF022C22);
  static const Color secondaryText = Color(0xFF047857);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFD1FAE5);

  // --- Dark Theme Palette ---
  static const Color darkBackground = Color(0xFF022C22);
  static const Color darkSurface = Color(0xFF064E3B);
  static const Color darkBorder = Color(0xFF166534);
  static const Color darkTextPrimary = Color(0xFFECFDF5);
  static const Color darkTextSecondary = Color(0xFFA7F3D0);

  // --- Legacy Mappings & Compatibility ---
  static const Color primaryEmerald = primaryGreen;
  static const Color deepEmerald = darkBackground;
  static const Color antiqueGold = sacredGold;
  static const Color lightGold = orangeLight;
  static const Color background = sheetBackground;
  static const Color surface = white;
  static const Color surfaceElevated = lightBorder;
  static const Color border = lightBorder;
  static const Color divider = lightBorder;
  static const Color error = alertRed;
  static const Color success = successGreen;
  static const Color textHint = Color(0xFF68736F);
  static const Color borderDark = darkBorder;
  static const Color dividerDark = darkBorder;
  static const Color textPrimaryDark = darkTextPrimary;
  static const Color textSecondaryDark = darkTextSecondary;
  static const Color textHintDark = Color(0xFF68736F);
  static const Color primaryPurple = primaryGreen;
  static const Color softLavender = lightBorder;

  // New aliases for missing legacy colors
  static const Color textPrimary = Color(0xFF022C22);
  static const Color textSecondary = Color(0xFF047857);
  static const Color hintText = Color(0xFF68736F);
  static const Color jadeGreen = Color(0xFF0F766E);
  static const Color jadeDarkText = Color(0xFF022C22);
  static const Color metallicGold = sacredGold;
  static const Color jadeTextHint = Color(0xFFB8D8D3);
  static const Color primaryBackground = sheetBackground;
  static const Color premiumGold = sacredGold;
  static const Color warning = sacredGold;
  static const Color secondaryBackground = lightBorder;
  static const Color primaryIndigo = primaryGreen;
  static const Color primaryIndigoDark = darkBackground;
  static const Color premiumGoldLight = orangeLight;
  static const Color darkSurfaceElevated = darkBorder;
  static const Color offerBg = orangeLight;
  static const Color offerText = orangeDark;
  static const Color disabledBackground = Color(0xFFF0F0F8);
  static const Color disabledText = Color(0xFFA0A0B0);

  // --- Gradients ---
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [primaryGreen, Color(0xFF065F46)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [sacredGold, Color(0xFFB45309), Color(0xFF92400E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient celestialGradient = emeraldGradient;
  static const LinearGradient premiumGoldGradient = goldGradient;
  static const LinearGradient primaryGradient = emeraldGradient;
  static const LinearGradient premiumGradient = goldGradient;

  // --- Multi-Color Service Identity System ---
  static const Map<String, ServiceThemeColors> serviceThemes = {
    'life': ServiceThemeColors(
      primary: primaryGreen,
      secondary: sacredGold,
      background: sheetBackground,
      darkBackground: darkBackground,
    ),
    'super_life': ServiceThemeColors(
      primary: darkBackground,
      secondary: sacredGold,
      background: orangeLight,
      darkBackground: Color(0xFF2D2A1C),
    ),
    'marriage': ServiceThemeColors(
      primary: primaryGreen,
      secondary: Color(0xFFFCE4EC), // Subtle Rose
      background: Color(0xFFFFF1F4),
      darkBackground: darkBackground,
    ),
    'marriage_matching_lite': ServiceThemeColors(
      primary: primaryGreen,
      secondary: Color(0xFFF3E5F5), // Subtle Violet
      background: Color(0xFFF3E5F5),
      darkBackground: darkBackground,
    ),
    'marriage_matching_pro': ServiceThemeColors(
      primary: primaryGreen,
      secondary: sacredGold,
      background: sheetBackground,
      darkBackground: darkBackground,
    ),
    'single_page': ServiceThemeColors(
      primary: primaryGreen,
      secondary: Color(0xFFE3F2FD), // Subtle Blue
      background: Color(0xFFE3F2FD),
      darkBackground: darkBackground,
    ),
    'wealth': ServiceThemeColors(
      primary: primaryGreen,
      secondary: sacredGold,
      background: sheetBackground,
      darkBackground: darkBackground,
    ),
    'yearly': ServiceThemeColors(
      primary: primaryGreen,
      secondary: accentGold,
      background: orangeLight,
      darkBackground: darkBackground,
    ),
    'gemstones': ServiceThemeColors(
      primary: primaryGreen,
      secondary: Color(0xFFE0F7FA), // Cyan
      background: Color(0xFFE0F7FA),
      darkBackground: darkBackground,
    ),
    'numerology': ServiceThemeColors(
      primary: primaryGreen,
      secondary: Color(0xFFE8EAF6), // Indigo
      background: Color(0xFFE8EAF6),
      darkBackground: darkBackground,
    ),
    'astrologer': ServiceThemeColors(
      primary: primaryGreen,
      secondary: sacredGold,
      background: sheetBackground,
      darkBackground: darkBackground,
    ),
  };
}

class ServiceThemeColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color darkBackground;

  const ServiceThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.darkBackground,
  });
}
