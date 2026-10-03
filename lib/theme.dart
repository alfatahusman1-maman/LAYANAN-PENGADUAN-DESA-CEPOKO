import 'package:flutter/material.dart';

abstract final class CepokoColors {
  static const green = Color(0xFF1E5631);
  static const greenDeep = Color(0xFF163829);
  static const greenLight = Color(0xFFF0F4EB);
  static const tan = Color(0xFF8D6E63);
  static const paper = Color(0xFFFFFEFA);
  static const canvas = Color(0xFFF5F6F1);
  static const line = Color(0xFFE4E8DF);
  static const ink = Color(0xFF202920);
  static const muted = Color(0xFF697366);
  static const sand = Color(0xFFE8D9B9);
  static const error = Color(0xFF9B493E);

  // Extended palette for premium UI
  static const greenMint = Color(0xFFE8F5E9);
  static const greenSoft = Color(0xFF99D4A4);
  static const warmAmber = Color(0xFFE65100);
  static const amberLight = Color(0xFFFFF3E0);
  static const resolvedGreen = Color(0xFF2E7D32);
  static const processEarth = Color(0xFFEFEBE9);

  // Gradient presets
  static const splashGradientTop = Color(0xFF1A4A2C);
  static const splashGradientBottom = Color(0xFF0D2818);

  static LinearGradient get heroGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [splashGradientTop, greenDeep, splashGradientBottom],
      );

  static LinearGradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [green, greenDeep],
      );
}

/// Premade shadow styles for consistent elevation.
abstract final class CepokoShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: CepokoColors.ink.withValues(alpha: .05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: CepokoColors.green.withValues(alpha: .12),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get fab => [
        BoxShadow(
          color: CepokoColors.green.withValues(alpha: .25),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];
}

ThemeData buildCepokoTheme() {
  const green = CepokoColors.green;
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: CepokoColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: green,
      brightness: Brightness.light,
      surface: CepokoColors.paper,
    ).copyWith(primary: green, secondary: CepokoColors.tan),
    fontFamily: 'sans-serif',
    appBarTheme: const AppBarTheme(
      backgroundColor: CepokoColors.paper,
      surfaceTintColor: Colors.transparent,
      foregroundColor: CepokoColors.ink,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFBFCF9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      hintStyle: const TextStyle(color: Color(0xFF959C91), fontSize: 13),
      labelStyle: const TextStyle(color: CepokoColors.muted, fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CepokoColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CepokoColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: green, width: 1.5),
      ),
    ),
    dividerColor: CepokoColors.line,
    navigationBarTheme: NavigationBarThemeData(
      height: 66,
      backgroundColor: CepokoColors.paper,
      surfaceTintColor: Colors.transparent,
      indicatorColor: const Color(0xFFEAF0E4),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontSize: 10,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        );
      }),
    ),
  );
}
