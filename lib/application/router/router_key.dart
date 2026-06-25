import 'package:flutter/widgets.dart';

/// Global keys for navigation.
final class RouterKey {
  const RouterKey._();

  /// The main [GlobalKey] for the [Navigator] widget.
  /// This key is used to identify the root navigator.
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
}
