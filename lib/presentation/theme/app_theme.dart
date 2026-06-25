import 'package:flutter/material.dart';
import 'package:test_mcp_figma/presentation/theme/app_colors_palette.dart';

/// [ThemeData] for this application
abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsPalette.black,
    );
  }
}
