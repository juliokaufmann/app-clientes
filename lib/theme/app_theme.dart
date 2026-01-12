import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais
  static const Color primaryBlack = Color(0xFF000000);
  static const Color accentBlue = Color(0xFF4FC3F7); // Azul claro
  static const Color lightBlue = Color(0xFF81D4FA); // Azul mais claro
  static const Color darkGray = Color(0xFF1A1A1A);
  static const Color mediumGray = Color(0xFF2C2C2C);
  static const Color lightGray = Color(0xFF3A3A3A);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFB0B0B0);

  // URL do logo
  static const String logoUrl =
      'https://files.jestor.com/eb70c879e8464a17834bd824e4f5fe59/8ugl7jbac6nv0x1_xyo9j/46d2f2e1-da38-40ad-89b2-f0e77d8c3c1a__37797marcacindapagrupo03.webp';

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlack,
      scaffoldBackgroundColor: primaryBlack,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: lightBlue,
        surface: darkGray,
        background: primaryBlack,
        error: Color(0xFFE57373),
        onPrimary: textWhite,
        onSecondary: primaryBlack,
        onSurface: textWhite,
        onBackground: textWhite,
        onError: textWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: accentBlue),
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: mediumGray,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: primaryBlack,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentBlue,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: textGray),
        hintStyle: const TextStyle(color: textGray),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: textWhite,
        iconColor: accentBlue,
      ),
      iconTheme: const IconThemeData(
        color: accentBlue,
      ),
    );
  }
}
