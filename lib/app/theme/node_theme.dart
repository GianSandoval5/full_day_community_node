import 'package:flutter/material.dart';

abstract final class NodeColors {
  static const background = Color(0xFF071321);
  static const surface = Color(0xFF0E1D30);
  static const flutterBlue = Color(0xFF42A5F5);
  static const cyan = Color(0xFF36D9F2);
  static const firebaseAmber = Color(0xFFFFCA28);
  static const success = Color(0xFF48D99A);
}

abstract final class NodeTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: NodeColors.flutterBlue,
      brightness: Brightness.dark,
      surface: NodeColors.surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: NodeColors.background,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: NodeColors.surface.withValues(alpha: 0.94),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.045),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
    );
  }
}
