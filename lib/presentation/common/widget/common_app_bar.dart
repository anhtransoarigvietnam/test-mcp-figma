import 'package:flutter/material.dart';
import 'package:test_mcp_figma/presentation/common/widget/common_button.dart';
import 'package:test_mcp_figma/presentation/theme/app_colors_palette.dart';
import 'package:test_mcp_figma/presentation/theme/app_text_palette.dart';
import 'package:test_mcp_figma/utility/constant/asset_constant.dart';

/// A common app bar with a back button, and a String for child
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.trailingIcon,
    this.onTrailingPressed,
    this.centerTitle = true,
  }) : assert(
         trailingIcon == null || onTrailingPressed != null,
         'onTrailingPressed must not be null when trailingIcon is provided',
       );

  /// Centered title of the app bar
  final String? title;

  /// Callback when leading button is pressed
  final VoidCallback? onBackPressed;

  /// Optional trailing icon
  final Widget? trailingIcon;

  /// Callback when trailing icon is pressed
  final VoidCallback? onTrailingPressed;

  final bool centerTitle;

  /// Set height of AppBar
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: centerTitle ? null : (onBackPressed != null ? 0 : 20),
      automaticallyImplyLeading: onBackPressed != null,
      title: title != null
          ? Text(
              title!,
              style: AppTextPalette.outfit10Bold.copyWith(
                color: AppColorsPalette.yellow400,
                letterSpacing: 2.8,
              ),
            )
          : null,
      backgroundColor: Colors.transparent,
      shape: const Border(
        bottom: BorderSide(color: AppColorsPalette.gray800, width: 2),
      ),
      leadingWidth: 70,
      leading: onBackPressed != null
          ? Padding(
              // These padding metrics are not exactly from design, but these are chosen to ensure:
              // - Left padding is 20
              // - Size is 40x40
              // - App bar's height is 60
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 6),
              child: CommonButton.filled(
                padding: const .all(0),
                onPressed: onBackPressed,
                backgroundColor: Colors.transparent,
                leadingIcon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            )
          : null,
      centerTitle: centerTitle,
      actions: trailingIcon != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CommonButton.filled(
                  height: 40,
                  width: 40,
                  padding: const .all(0),
                  onPressed: onTrailingPressed,
                  backgroundColor: Colors.transparent,
                  trailingIcon: trailingIcon,
                ),
              ),
            ]
          : null,
    );
  }
}
