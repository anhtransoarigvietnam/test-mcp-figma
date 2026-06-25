import 'package:flutter/material.dart';

@immutable
abstract final class AppColorsPalette {
  // Base
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);

  // Red
  static const red200 = Color(0xFFFFB4AB);

  // Yellow
  static const yellow200 = Color(0xFFF3E5AB);
  static const yellow300 = Color(0xFFFFCC7A);
  static const yellow350 = Color(0xFFF2CA50);
  static const yellow400 = Color(0xFFD4AF37);
  static const yellow600 = Color(0xFFB68D27);
  static const yellow700 = Color(0xFF8A6D1C);

  // Gray
  static const gray100 = Color(0xFFE2E2E3);
  static const gray800 = Color(0xFF272727);
  static const gray900 = Color(0xFF191919);
}
