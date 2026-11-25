import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const Color primary = Color(0xFF16A36A);
  static const Color background = Color(0xFFF5F8F7);
  static const Color dark = Color(0xFF14251F);
  static const Color secondary = Color(0xFF64756D);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: dark,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
