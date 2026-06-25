import 'package:flutter/material.dart';
import 'package:test_mcp_figma/presentation/theme/app_colors_palette.dart';
import 'package:test_mcp_figma/presentation/theme/app_font_variation.dart';

@immutable
abstract final class AppTextPalette {
  // Font families
  static const String outfit = 'Outfit';

  // Outfit - 10
  static const TextStyle outfit10Bold = TextStyle(
    fontFamily: outfit,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    fontVariations: AppFontVariations.w700,
    height: 1.4,
    color: AppColorsPalette.white,
  );
}
