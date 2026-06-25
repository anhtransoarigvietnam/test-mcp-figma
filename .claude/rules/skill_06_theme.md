---
description: Flutter theme skill
paths:
-e   - **/*_test.dart
  - **/test/**
---
Summary: Theme configuration, Colors Palette, and Text Palette.

# Theme System

The design system is located in `lib/presentation/theme/`.

## 1. AppTheme
The main theme provider using Material 3. It enforces a dark mode by default.
```dart
abstract final class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: AppTextPalette.textTheme,
      scaffoldBackgroundColor: AppColorsPalette.black,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColorsPalette.yellow350,
      ),
    );
  }
}
```

## 2. Colors Palette
Never hardcode colors. Use `AppColorsPalette`.

```dart
// Example usage:
Container(color: AppColorsPalette.yellow400)
```
*(Colors like `yellow400`, `gray300`, `black` are defined as static constants in `app_colors_palette.dart`)*

## 3. Text Palette
Text styles are managed through `AppTextPalette`. It defines specific semantics like `headline1`, `body1`, etc.

```dart
// Example usage:
Text(
  'Total Coins',
  style: AppTextPalette.textTheme.headlineMedium?.copyWith(
    color: AppColorsPalette.white,
  ),
)
```

## 4. Spacing and Dimensions
Dimensions, margins, and standard heights are found in `DimensionConstants` (`lib/utility/constant/dimension_constant.dart`).
