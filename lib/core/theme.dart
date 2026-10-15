import 'package:flutter/material.dart';

class NColors {
  static const ink = Color(0xFF111827);
  static const midnight = Color(0xFF141B33);
  static const neon = Color(0xFFCEFB6E);
  static const violet = Color(0xFF8666F7);
  static const canvas = Color(0xFFF7F8F6);
  static const slate = Color(0xFF7A8190);
  static const line = Color(0xFFE8EAE7);
}

ThemeData makeTheme(bool dark) {
  const radius = Radius.circular(22);
  final primary = dark ? const Color(0xFF131821) : NColors.canvas;
  final surface = dark ? const Color(0xFF1B2230) : Colors.white;
  final text = dark ? const Color(0xFFF2F5F7) : NColors.ink;
  return ThemeData(
    useMaterial3: true,
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: primary,
    colorScheme: ColorScheme.fromSeed(seedColor: NColors.violet,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: NColors.violet, surface: surface),
    appBarTheme: AppBarTheme(backgroundColor: primary, foregroundColor: text,
      surfaceTintColor: Colors.transparent, elevation: 0),
    cardTheme: CardThemeData(color: surface, shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(radius))),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: text, fontSize: 37, fontWeight: FontWeight.w900, height: 1.08, letterSpacing: -1.7),
      headlineLarge: TextStyle(color: text, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.9),
      headlineMedium: TextStyle(color: text, fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: -0.65),
      titleLarge: TextStyle(color: text, fontSize: 19, fontWeight: FontWeight.w800, letterSpacing: -0.4),
      titleMedium: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3),
      bodyLarge: TextStyle(color: text, fontSize: 15, height: 1.5),
      bodyMedium: TextStyle(color: text, fontSize: 13.5, height: 1.48),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      hintStyle: const TextStyle(color: NColors.slate),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
    ),
    dividerColor: dark ? const Color(0xFF303847) : NColors.line,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    ),
  );
}
