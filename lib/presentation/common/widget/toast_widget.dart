import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_mcp_figma/presentation/theme/app_colors_palette.dart';
import 'package:test_mcp_figma/presentation/theme/app_text_palette.dart';

class ToastWidget extends StatefulWidget {
  final String message;
  final Duration fadeDuration;
  final VoidCallback onDismiss;
  final bool isErrorMessage;
  final Duration toastVisibleDuration;

  const ToastWidget({
    super.key,
    required this.message,
    required this.fadeDuration,
    required this.onDismiss,
    required this.toastVisibleDuration,
    this.isErrorMessage = false,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  double _opacity = 0.0;

  Timer? _fadeInTimer;
  Timer? _visibleTimer;
  Timer? _fadeOutTimer;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _runSequence();
  }

  void _runSequence() {
    _fadeInTimer = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() {
        _opacity = 1.0;
      });

      _visibleTimer = Timer(widget.toastVisibleDuration, () {
        if (!mounted) return;
        setState(() {
          _opacity = 0.0;
        });

        _dismissTimer = Timer(widget.fadeDuration, () {
          // onDismiss should not call setState; safe to run even if unmounted
          widget.onDismiss();
        });
      });
    });
  }

  @override
  void dispose() {
    _fadeInTimer?.cancel();
    _visibleTimer?.cancel();
    _fadeOutTimer?.cancel();
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.isErrorMessage
        ? AppColorsPalette.red200
        : AppColorsPalette.yellow400;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedOpacity(
          duration: widget.fadeDuration,
          opacity: _opacity,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColorsPalette.gray900.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsPalette.black.withValues(alpha: 0.35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isErrorMessage
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: accentColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: AppTextPalette.outfit10Bold.copyWith(
                          color: AppColorsPalette.white,
                          height: 20 / 14,
                          decoration: .none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
