import 'package:flutter/widgets.dart';
import 'package:test_mcp_figma/presentation/common/widget/toast_widget.dart';

class ToastUtility {
  const ToastUtility._();

  static void show(
    BuildContext context,
    String message, {
    bool isErrorMessage = false,
    bool rootOverlay = false,
    Duration fadeDuration = const Duration(milliseconds: 250),
    Duration toastVisibleDuration = const Duration(seconds: 5),
  }) {
    final overlay = Overlay.of(context, rootOverlay: rootOverlay);
    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: IgnorePointer(
          child: ToastWidget(
            message: message,
            fadeDuration: fadeDuration,
            toastVisibleDuration: toastVisibleDuration,
            isErrorMessage: isErrorMessage,
            onDismiss: () {
              if (entry.mounted) {
                entry.remove();
              }
            },
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }
}
