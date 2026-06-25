Summary: Theme configuration, Colors Palette, Text Palette, and Dimensions.

# Theme System

The design system is located in `lib/presentation/theme/`.

## 1. AppTheme

The application uses Material 3 and enforces Dark Mode by default.

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

### Rules

* Always use `AppTheme.darkTheme`.
* Do not create custom `ThemeData` instances.
* Do not override global theme configurations unless explicitly required.

---

## 2. Colors Palette

Never hardcode color values.

Always use colors from `AppColorsPalette`.

### Example

```dart
Container(
  color: AppColorsPalette.yellow400,
)
```

### Available Color Groups

#### Base

```dart
AppColorsPalette.black
AppColorsPalette.white
AppColorsPalette.transparent
```

#### Red

```dart
AppColorsPalette.red200
AppColorsPalette.red700
```

#### Accent

```dart
AppColorsPalette.cyan400
AppColorsPalette.cyan200
```

#### Green

```dart
AppColorsPalette.green400
```

#### Yellow

```dart
AppColorsPalette.yellow200
AppColorsPalette.yellow300
AppColorsPalette.yellow350
AppColorsPalette.yellow400
AppColorsPalette.yellow600
AppColorsPalette.yellow700
```

#### Gray

```dart
AppColorsPalette.gray100
AppColorsPalette.gray150
AppColorsPalette.gray200
AppColorsPalette.gray300
AppColorsPalette.gray400
AppColorsPalette.gray450
AppColorsPalette.gray500
AppColorsPalette.gray600
AppColorsPalette.gray800
AppColorsPalette.gray900
```

#### Beige

```dart
AppColorsPalette.beige200
```

#### Brown

```dart
AppColorsPalette.brown900
```

### Color Rules

* Never use `Color(0xFF...)` directly in widgets.
* Never use `Colors.black`, `Colors.white`, `Colors.grey`, etc.
* Always prefer `AppColorsPalette`.

---

## 3. Text Palette

Typography is managed through `AppTextPalette`.

Never create inline `TextStyle` objects unless absolutely necessary.

### Example

```dart
Text(
  'Total Coins',
  style: AppTextPalette.outfit10SemiBold,
)
```

### Example with Modification

```dart
Text(
  'Total Coins',
  style: AppTextPalette.outfit10SemiBold.copyWith(
    color: AppColorsPalette.yellow400,
  ),
)
```

### Available Font Families

```dart
AppTextPalette.outfit
AppTextPalette.manrope
AppTextPalette.inter
AppTextPalette.cormorant
AppTextPalette.notoSerif
```

### Typography Rules

* Always start from an existing style in `AppTextPalette`.
* Prefer `.copyWith()` for minor customizations.
* Do not create ad-hoc font sizes, weights, or font families.
* Reuse predefined typography tokens whenever possible.
* Use `AppTextPalette.textTheme` when integrating with Material widgets.

---

## 4. Spacing and Dimensions

Dimensions, margins, spacing, border radius values, and standard component sizes are defined in:

```text
lib/utility/constant/dimension_constant.dart
```

Use `DimensionConstants` instead of hardcoded numeric values whenever available.

### Example

```dart
Padding(
  padding: EdgeInsets.all(DimensionConstants.spacing16),
)
```

### Dimension Rules

* Avoid magic numbers.
* Reuse existing spacing tokens.
* Keep spacing consistent across screens.

---

# Design System Rules

## DO

✅ Use `AppColorsPalette` for all colors.

✅ Use `AppTextPalette` for all typography.

✅ Use `DimensionConstants` for spacing and sizing.

✅ Use `.copyWith()` when a slight variation is required.

## DON'T

❌ Hardcode color values.

❌ Hardcode font families.

❌ Create arbitrary text styles.

❌ Use `Colors.*` directly.

❌ Introduce custom spacing values when a design token already exists.
