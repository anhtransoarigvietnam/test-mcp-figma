import 'dart:ui';

/// Device type for responsive design
enum DeviceType {
  smallMobile,
  mobile,
  tablet;

  /// Get raw shortest side of device
  static double get _rawShortestSide {
    final view = PlatformDispatcher.instance.views.single;
    final size = view.physicalSize / view.devicePixelRatio;
    return size.shortestSide;
  }

  /// Check if device is mobile
  static bool get isMobile => _rawShortestSide < 600;
  static bool get isSmallMobile => _rawShortestSide < 380;
}
