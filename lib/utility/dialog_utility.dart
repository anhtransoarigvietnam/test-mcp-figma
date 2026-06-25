// A utility to show modals with customizable content
import 'package:flutter/material.dart';
import 'package:test_mcp_figma/presentation/theme/app_colors_palette.dart';

class DialogUtility {
  static Future<T?> _showDialog<T>({
    required BuildContext context,
    required Widget Function(BuildContext, Animation<double>) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showGeneralDialog<T>(
      barrierColor:
          barrierColor ?? AppColorsPalette.black.withValues(alpha: 0.6),
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder:
          (context, unusedPrimaryAnimation, unusedSecondaryAnimation) =>
              const SizedBox(),
      useRootNavigator: true,
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            child: builder(context, curvedAnimation),
          ),
        );
      },
    );
  }

  /// Show a general modal.
  static Future<T?> showGeneralModal<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    bool isTransparent = false,
    double cornerRadius = 10,
    Color? barrierColor,
    bool removeBottom = true,
    required Duration transitionDuration,
  }) {
    return _showDialog<T>(
      barrierColor: barrierColor,
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext, animation) => MediaQuery.removeViewInsets(
        context: dialogContext,
        // If true, modal will not move up when keyboard appears
        removeBottom: removeBottom,
        // Ensures modal content is within safe area
        // Some case like iPhone with notch and device is landscape mode => need safe area
        child: SafeArea(
          left: true,
          right: true,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: .all(.circular(cornerRadius)),
            ),
            backgroundColor: isTransparent ? Colors.transparent : null,
            insetPadding: const .symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 392),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Show a sharing bottom sheet modal.
  static Future<T?> showBottomSheetModal<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool removeBottom = false,
  }) {
    final content = removeBottom
        ? MediaQuery.removeViewInsets(
            context: context,
            removeBottom: true,
            child: child,
          )
        : child;

    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isDismissible: isDismissible,
      enableDrag: true,
      useSafeArea: useSafeArea,
      isScrollControlled: true,
      barrierColor:
          barrierColor ?? AppColorsPalette.black.withValues(alpha: 0.6),
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: .infinity),
      builder: (_) => content,
    );
  }
}
