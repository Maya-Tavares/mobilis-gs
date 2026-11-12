import 'package:flutter/material.dart';

/// Paleta e tema do Mobilis: verde-água e azul claro, tom de saúde e solidariedade.
class AppCores {
  static const Color primaria = Color(0xFF2E7D6E);
  static const Color primariaEscura = Color(0xFF1F5C51);
  static const Color secundaria = Color(0xFF4FA3D1);
  static const Color destaque = Color(0xFFFFD666);
  static const Color fundo = Color(0xFFF2F8F7);
  static const Color superficie = Colors.white;
  static const Color textoPrimario = Color(0xFF1E2B28);
  static const Color textoSecundario = Color(0xFF5B6B67);
  static const Color erro = Color(0xFFC0392B);
}

class AppEspacos {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double raio = 14;
}

class AppTheme {
  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: AppCores.primaria,
      primary: AppCores.primaria,
      secondary: AppCores.secundaria,
      surface: AppCores.superficie,
      error: AppCores.erro,
    );
    final raio = BorderRadius.circular(AppEspacos.raio);
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: AppCores.fundo,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppCores.primaria,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppCores.textoPrimario),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppCores.textoPrimario),
        bodyMedium: TextStyle(fontSize: 14, color: AppCores.textoPrimario),
        bodySmall: TextStyle(fontSize: 12, color: AppCores.textoSecundario),
      ),
      cardTheme: CardThemeData(
        color: AppCores.superficie,
        elevation: 1.5,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: raio),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: raio),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppCores.primaria,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppCores.primaria),
          shape: RoundedRectangleBorder(borderRadius: raio),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppCores.primaria),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppCores.superficie,
        border: OutlineInputBorder(borderRadius: raio),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppCores.primaria.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppCores.primaria,
        unselectedItemColor: AppCores.textoSecundario,
        backgroundColor: AppCores.superficie,
      ),
    );
  }
}
