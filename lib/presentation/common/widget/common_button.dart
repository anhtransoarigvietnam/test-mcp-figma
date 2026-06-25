import 'package:flutter/material.dart';
import 'package:test_mcp_figma/presentation/theme/app_colors_palette.dart';
import 'package:test_mcp_figma/presentation/theme/app_text_palette.dart';

/// Shared app button with 2 visual variants:
/// - [CommonButton.filled]
/// - [CommonButton.outline]
///
/// The button is considered disabled when [onPressed] is `null`.
class CommonButton extends StatelessWidget {
  /// Creates a filled button.
  ///
  /// Example:
  /// `CommonButton.filled(text: 'Send question', trailingIcon: const Icon(Icons.send_rounded), onTap: _onSend)`
  const CommonButton.filled({
    this.text,
    this.textStyle,
    this.onPressed,
    this.cornerRadius = 120,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.leadingIcon,
    this.trailingIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.height = 56,
    this.width,
    this.iconSpacingFromText,
    this.boxShadow,
    super.key,
  }) : _isFilled = true;

  /// Creates an outlined button.
  ///
  /// Example:
  /// `CommonButton.outline(text: 'Delete history', leadingIcon: const Icon(Icons.delete_outline), borderColor: AppColorsPalette.red, onTap: _onDelete)`
  const CommonButton.outline({
    this.text,
    this.textStyle,
    this.onPressed,
    this.cornerRadius = 120,
    this.backgroundColor = Colors.transparent,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.leadingIcon,
    this.trailingIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    this.borderColor,
    this.borderWidth = 1,
    this.height = 56,
    this.width,
    this.iconSpacingFromText,
    this.boxShadow,
    super.key,
  }) : _isFilled = false;

  /// Corner radius of the button shape.
  final double cornerRadius;

  /// Enabled background color.
  final Color? backgroundColor;

  /// Label text.
  final String? text;

  /// Optional override for label style.
  final TextStyle? textStyle;

  /// Private property indicating filled/outline shape of the button.
  final bool _isFilled;

  /// Disabled background color.
  final Color? disabledBackgroundColor;

  /// Disabled label color.
  final Color? disabledTextColor;

  /// Optional icon shown on the left.
  final Widget? leadingIcon;

  /// Optional icon shown on the right.
  final Widget? trailingIcon;

  /// Tap callback; `null` means disabled.
  final VoidCallback? onPressed;

  /// Inner content padding.
  final EdgeInsetsGeometry padding;

  /// Border color (mainly for outline variant).
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Fixed button height.
  final double height;

  /// Optional fixed button width.
  final double? width;

  /// Distance between icon and text when icons should sit near label.
  ///
  /// - `null`: icons stay on far edges.
  /// - `non-null`: icons render next to text with this spacing.
  final double? iconSpacingFromText;

  /// Shadow for the button.
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    final Color resolvedDisabledBackground =
        disabledBackgroundColor ?? AppColorsPalette.transparent;

    final Color resolvedDisabledText =
        disabledTextColor ??
        (_isFilled ? AppColorsPalette.white : AppColorsPalette.black);
    final Color resolvedBackground = isEnabled
        ? (backgroundColor ??
              (_isFilled ? AppColorsPalette.yellow400 : AppColorsPalette.white))
        : resolvedDisabledBackground;
    final Color resolvedTextColor = isEnabled
        ? (_isFilled ? AppColorsPalette.white : AppColorsPalette.black)
        : resolvedDisabledText;
    final Color resolvedBorder = isEnabled
        ? (borderColor ?? AppColorsPalette.yellow400)
        : resolvedDisabledText;

    final BorderSide? side = !_isFilled
        ? BorderSide(color: resolvedBorder, width: borderWidth)
        : null;

    final TextStyle resolvedTextStyle =
        (textStyle ?? AppTextPalette.outfit10Bold).copyWith(
          color: textStyle?.color ?? resolvedTextColor,
        );
    final Widget? resolvedLabel = text != null
        ? Text(
            text!,
            style: resolvedTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        : null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(cornerRadius),
      child: InkWell(
        onTap: onPressed,
        highlightColor: resolvedTextColor.withValues(alpha: 0.4),
        splashColor: resolvedTextColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(cornerRadius),
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: resolvedBackground,
            borderRadius: BorderRadius.circular(cornerRadius),
            border: side == null ? null : Border.fromBorderSide(side),
            boxShadow: boxShadow,
          ),
          child: Padding(
            padding: padding,
            child: _buildContent(resolvedLabel ?? const SizedBox.shrink()),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Widget resolvedLabel) {
    // If there is only leading button => use it
    if (text == null && leadingIcon != null && trailingIcon == null) {
      return Center(child: leadingIcon!);
    }

    // If there is only trailing button => use it
    if (text == null && trailingIcon != null && leadingIcon == null) {
      return Center(child: trailingIcon!);
    }

    if (iconSpacingFromText != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            leadingIcon!,
            SizedBox(width: iconSpacingFromText),
          ],
          Flexible(child: resolvedLabel),
          if (trailingIcon != null) ...[
            SizedBox(width: iconSpacingFromText),
            trailingIcon!,
          ],
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: leadingIcon ?? const SizedBox.shrink(),
          ),
        ),
        Expanded(flex: 6, child: Center(child: resolvedLabel)),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: trailingIcon ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
