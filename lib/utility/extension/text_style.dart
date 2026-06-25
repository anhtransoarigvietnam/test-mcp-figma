import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  /// Helpers for using variable fonts with the `wght` axis
  ///
  /// Flutter sets `fontWeight` as intent, but some variable font setups can
  /// require explicitly setting `fontVariations` for consistent rendering
  TextStyle withVariableWeight([FontWeight? weight]) {
    final resolvedWeight = weight ?? fontWeight ?? FontWeight.w400;
    final preservedVariations =
        fontVariations
            ?.where((variation) => variation.axis != 'wght')
            .toList() ??
        [];

    return copyWith(
      fontWeight: resolvedWeight,
      fontVariations: [
        ...preservedVariations,
        FontVariation('wght', resolvedWeight.value.toDouble()),
      ],
    );
  }
}
